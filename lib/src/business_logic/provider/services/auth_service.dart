import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../../../data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> signUp(String email, String password, String name, String jeniskelamin, String nohp,
      String address, String? photoUrl, DateTime? birthDate) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      await user?.updateDisplayName(name);
      await user?.updatePhotoURL(photoUrl);

      // simpan detailnya
      await _firestore.collection('users').doc(user?.uid).set({
        'email': email,
        'name': name,
        'jeniskelamin': jeniskelamin,
        'nohp': nohp,
        'address': address,
        'photoUrl': photoUrl,
        'role': 'user', // default
        'birthDate': birthDate?.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return user;
    } catch (e) {
      if (kDebugMode) {
        print("Sign Up Error: ${e.toString()}");
      }
      return null;
    }
  }

  Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await saveLoginStatus(true);
      return result.user;
    } catch (e) {
      if (kDebugMode) {
        print("Sign In Error: ${e.toString()}");
      }
      return null;
    }
  }

  // Fetch current user's data from Firestore
  Future<UserModel?> getCurrentUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return UserModel.fromMap(
          userDoc.data() as Map<String, dynamic>, user.uid);
    }
    return null;
  }

  // Update user profile data
  Future<void> updateUserProfile(String userId, String newName, String newJenisKelamin, String newNoHp, DateTime? newBirthDate,
      String newAddress, String? newPhotoUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': newName,
        'jeniskelamin': newJenisKelamin,
        'nohp': newNoHp,
        'birthDate': newBirthDate?.toIso8601String(),
        'address': newAddress,
        'photoUrl': newPhotoUrl,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error updating profile: $e");
      }
    }
  }

  // Update user's name
  Future<void> updateUserName(String uid, String newName) async {
    await _firestore.collection('users').doc(uid).update({'name': newName});
  }

  // Update user's jenis kelamin
  Future<void> updateJenisKelamin(String uid, String newJenisKelamin) async {
    await _firestore.collection('users').doc(uid).update({'jeniskelamin': newJenisKelamin});
  }

  // Update user's no hp
  Future<void> updateNoHp(String uid, String newNoHp) async {
    await _firestore.collection('users').doc(uid).update({'nohp': newNoHp});
  }

  // Update user's birthdate
Future<void> updateBirthDate(String uid, DateTime newBirthdate) async {
  await _firestore.collection('users').doc(uid).update({'birthDate': newBirthdate.toIso8601String()});
}

  // Update user's email
  Future<void> updateUserEmail(String uid, String newEmail) async {
    await _firestore.collection('users').doc(uid).update({'email': newEmail});
  }

  // Update user's address
  Future<void> updateUserAddress(String uid, String newAddress) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'address': newAddress});
  }

  // Update user's photo URL
  Future<void> updateUserPhoto(String uid, String newPhotoUrl) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'photoUrl': newPhotoUrl});
  }

  // Method to upload a new photo to Firebase Storage and return the URL
  Future<String> uploadUserPhoto(File photo) async {
    String filePath =
        'user_photos/${DateTime.now().millisecondsSinceEpoch}.jpg';
    UploadTask uploadTask = _storage.ref().child(filePath).putFile(photo);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Method to delete an old photo from Firebase Storage
  Future<void> deletePhoto(String photoUrl) async {
    try {
      await _storage.refFromURL(photoUrl).delete();
    } catch (e) {
      if (kDebugMode) {
        print("Error deleting old photo: $e");
      }
    }
  }

  Future<void> refreshToken() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.reload(); // Memperbarui token pengguna
    }
  }

  Future<bool> hasInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } catch (_) {
    return false; // Tidak ada koneksi
  }
}

  // Fungsi untuk mengganti password
  Future<void> changePassword(String oldPassword, String newPassword) async {
  User? user = _auth.currentUser;

  if (user == null) {
    throw Exception("Pengguna tidak ditemukan.");
  }

  String email = user.email ?? "";

  try {
    // Periksa koneksi internet menggunakan metode alternatif
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      throw Exception("Tidak ada koneksi internet.");
    }
    print("Koneksi internet aktif.");

    print("Merefresh token...");
    await user.reload(); // Refresh token pengguna
    print("Token diperbarui.");

    print("Memulai login ulang...");
    // Login ulang dengan password lama untuk verifikasi
    await _auth.signInWithEmailAndPassword(email: email, password: oldPassword)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      throw Exception("Login ulang timeout. Periksa koneksi internet Anda.");
    });
    print("Login ulang berhasil.");

    print("Mengganti password...");
    // Ganti password baru
    await user.updatePassword(newPassword)
        .timeout(const Duration(seconds: 30), onTimeout: () {
      throw Exception("Update password timeout. Periksa koneksi internet Anda.");
    });
    print("Password berhasil diganti.");
  } catch (e) {
    print("Error: $e");
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'wrong-password':
          throw Exception("Password lama salah.");
        case 'weak-password':
          throw Exception("Password baru terlalu lemah.");
        default:
          throw Exception("Terjadi kesalahan: ${e.message}");
      }
    } else {
      throw Exception("Kesalahan tidak dikenal: $e");
    }
  }
}


  // Sign out the user
 void signOut() async {
    await saveLoginStatus(false);
    _auth.signOut();
  }
}
