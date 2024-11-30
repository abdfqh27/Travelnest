import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_provider.dart';
import '../../../data/model/user_model.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;

  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  //simpan status
  Future<void> _saveLoginStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', status);
  }

//periksa status
  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name,
      String address, String? photoUrl) async {
    await _authService.signUp(email, password, name, address, photoUrl);
    await fetchUserData();
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
    await _authService.signIn(email, password);
    await fetchUserData();
    _isLoggedIn = true;
    await _saveLoginStatus(true);

    // Ambil data favorit untuk user yang baru login
    context.read<WisataProvider>().fetchFavoritesForCurrentUser();
  } catch (e) {
    throw Exception("Login gagal: $e");
  }
  }

  //dari firestore
  Future<void> fetchUserData() async {
    _user = await _authService.getCurrentUserData();
    notifyListeners();
  }

  Future<void> cekLoginStatus() async {
    await _loadLoginStatus();
    if (_isLoggedIn) {
      await fetchUserData();
    }
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

  void signOut(BuildContext context) async {
  _authService.signOut();
  context.read<WisataProvider>().resetFavorites(); // Reset favorit saat logout
    _user = null;
    _isLoggedIn = false;
    _saveLoginStatus(false);
    notifyListeners();
  }
   String get userId => _user?.id ?? "";
}
