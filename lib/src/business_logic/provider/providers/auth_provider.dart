import 'dart:io';
import 'package:flutter/material.dart';
import '../../../data/model/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();

  UserModel? get user => _user;

  Future<void> signUp(String email, String password, String name,
      String address, String? photoUrl) async {
    await _authService.signUp(email, password, name, address, photoUrl);
    await fetchUserData();
  }

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
    await fetchUserData();
  }

  //dari firestore
  Future<void> fetchUserData() async {
    _user = await _authService.getCurrentUserData();
    notifyListeners();
  }

  // Future<void> updateUserProfile(
  //     String newName, String newAddress, File? newPhoto) async {
  //   String? updatedPhotoUrl = _user?.photoUrl;

  //   // Check if there is a new photo to upload
  //   if (newPhoto != null) {
  //     String? oldPhotoUrl = _user?.photoUrl;

  //     // Upload new photo and get URL
  //     updatedPhotoUrl = await _authService.uploadUserPhoto(newPhoto);

  //     // Delete old photo after new photo is successfully uploaded
  //     if (oldPhotoUrl != null && oldPhotoUrl.isNotEmpty) {
  //       await _authService.deletePhoto(oldPhotoUrl);
  //     }
  //   }

  //   if (_user != null) {
  //     await _authService.updateUserProfile(
  //         _user!.id, newName, newAddress, updatedPhotoUrl);

  //     // Update local user data
  //     _user = _user!.copyWith(
  //         name: newName, address: newAddress, photoUrl: updatedPhotoUrl);
  //     notifyListeners();
  //   }
  // }

  Future<void> updateUserProfile(
      String newName, String newAddress, File? newPhoto) async {
    try {
      String? updatedPhotoUrl = _user?.photoUrl;

      // Check if there is a new photo to upload
      if (newPhoto != null) {
        String? oldPhotoUrl = _user?.photoUrl;

        // Upload new photo and get the URL
        updatedPhotoUrl = await _authService.uploadUserPhoto(newPhoto);

        // Delete old photo after new photo is successfully uploaded
        if (oldPhotoUrl != null && oldPhotoUrl.isNotEmpty) {
          await _authService.deletePhoto(oldPhotoUrl);
        }
      }

      if (_user != null) {
        // Update user profile data in Firestore
        await _authService.updateUserProfile(
            _user!.id, newName, newAddress, updatedPhotoUrl);

        // Update the local user data
        _user = _user!.copyWith(
            name: newName, address: newAddress, photoUrl: updatedPhotoUrl);

        notifyListeners(); // Notify listeners to update the UI
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  void signOut() {
    _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
