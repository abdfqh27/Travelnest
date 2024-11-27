import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for currency formatting
import 'package:provider/provider.dart';
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/business_logic/provider/category/category_provider.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wisata_app/src/data/repository/repository.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_state.dart';

class WisataProvider with ChangeNotifier {
  WisataState _state;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  WisataProvider() : _state = const WisataState.initial([]){
    // Panggil `fetchWisata` untuk memastikan data diambil saat provider diinisialisasi
    fetchWisata();
  }

  // final Repository repository;

  // WisataProvider({
  //   required this.repository,
  // }) : _state = WisataState.initial(repository.getWisataList);

  // Tambahkan getter ini untuk mendapatkan daftar wisata
  // List<Wisata> get wisataList => _state.wisataList;
  List<Wisata> get wisataList => _wisataList;
  List<Wisata> _wisataList = [];

  
  WisataState get state => _state;

  String get userId => _auth.currentUser?.uid ?? "";

  // Format the price as Rupiah
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
  
  Stream<List<Wisata>> getWisataStream() {
  return _firestore.collection('wisata').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) => Wisata.fromFirestore(doc)).toList();
  });
}


  // Metode untuk mengambil data wisata dari Firestore
   Future<void> fetchWisata() async {
    try {
      final snapshot = await _firestore.collection('wisata').get();
      _wisataList = snapshot.docs.map((doc) => Wisata.fromFirestore(doc)).toList();
      await fetchFavorites();
      notifyListeners();
    } catch (e) {
      print("Error fetching wisata: $e");
    }
  }

  Future<void> fetchFavorites() async {
  if (userId.isEmpty) return;

  try {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();

    final favoriteIds = snapshot.docs.map((doc) => doc.id).toSet();

    _wisataList = _wisataList.map((wisata) {
      return wisata.copyWith(isFavorite: favoriteIds.contains(wisata.id));
    }).toList();
    notifyListeners();
  } catch (e) {
    print("Error fetching favorites: $e");
  }
}


   // Fungsi untuk mengunggah beberapa gambar dan mendapatkan URL-nya
  Future<List<String>> _uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];
    for (XFile image in images) {
      final storageRef = _storage.ref().child('images/${image.name}');
      await storageRef.putFile(File(image.path));
      final imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }
    return imageUrls;
  }

  // Menambahkan wisata baru ke Firestore dan mengunggah gambar ke Firebase Storage
  Future<void> addWisata(Wisata wisata,  XFile? mainImageFile, List<XFile>? carouselImages, BuildContext context,) async {
    List<String> carouselImageUrls = [];
    String mainImageUrl = '';

    // Mengunggah gambar ke Firebase Storage jika ada
    // Unggah gambar utama jika ada
  if (mainImageFile != null) {
    final storageRef = _storage.ref().child('images/${mainImageFile.name}');
    await storageRef.putFile(File(mainImageFile.path));
    mainImageUrl = await storageRef.getDownloadURL();
  }

  // Unggah gambar carousel jika ada
  if (carouselImages != null && carouselImages.isNotEmpty) {
    for (XFile image in carouselImages) {
      final storageRef = _storage.ref().child('images/${image.name}');
      await storageRef.putFile(File(image.path));
      final imageUrl = await storageRef.getDownloadURL();
      carouselImageUrls.add(imageUrl);
    }
  }

    // Tambahkan wisata ke Firestore dengan URL gambar dari Firebase Storage
  final newWisata = wisata.copyWith(image: mainImageUrl, carouselImages: carouselImageUrls);
  final docRef = await _firestore.collection('wisata').add(newWisata.toMap());
  //update state wisata provider
    _state = _state.copyWith(
      wisataList: [..._state.wisataList, newWisata.copyWith(id: docRef.id)],
    );

    notifyListeners();

    // Panggil CategoryProvider untuk memperbarui filter
    context.read<CategoryProvider>().addWisata(newWisata);
    // Tampilkan SnackBar setelah berhasil menambahkan
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wisata berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );
  } 

  // Memperbarui data wisata di Firestore
  // Menambahkan fungsi untuk update wisata
Future<void> updateWisata(BuildContext context, Wisata updatedWisata, XFile? mainImageFile, List<XFile>? carouselImages) async {
  try {
    String imageUrl = updatedWisata.image;
    List<String> carouselUrls = updatedWisata.carouselImages;

    // Jika gambar utama di-update, hapus gambar lama dan unggah gambar baru
    if (mainImageFile != null) {
      // Hapus gambar utama lama dari Firebase Storage jika ada
      if (imageUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(imageUrl).delete();
        } catch (e) {
          print("Error deleting old main image: $e");
        }
      }

      // Unggah gambar utama baru
      final storageRef = _storage.ref().child('images/${mainImageFile.name}');
      await storageRef.putFile(File(mainImageFile.path));
      imageUrl = await storageRef.getDownloadURL();
    }

    // Jika gambar carousel di-update, hapus gambar lama dan unggah gambar baru
    if (carouselImages != null && carouselImages.isNotEmpty) {
      // Hapus semua gambar carousel lama dari Firebase Storage
      for (String oldUrl in carouselUrls) {
        try {
          await _storage.refFromURL(oldUrl).delete();
        } catch (e) {
          print("Error deleting old carousel image: $e");
        }
      }

      // Unggah gambar carousel baru
      carouselUrls = await _uploadImages(carouselImages);
    }

    // Update data wisata di Firestore
    final wisata = updatedWisata.copyWith(image: imageUrl, carouselImages: carouselUrls);
    await _firestore.collection('wisata').doc(wisata.id).update(wisata.toMap());

    // Update state di provider
    final index = _state.wisataList.indexWhere((w) => w.id == wisata.id);
    if (index != -1) {
      final updatedList = List<Wisata>.from(_state.wisataList);
      updatedList[index] = wisata;
      _state = _state.copyWith(wisataList: updatedList);
      notifyListeners();
    }

    // Panggil CategoryProvider untuk menyegarkan filter
      context.read<CategoryProvider>().updateWisata(wisata);

      // Tampilkan SnackBar setelah berhasil mengupdate
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data wisata berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print("Error updating wisata: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal memperbarui wisata: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  // Menghapus wisata dari Firestore
  Future<void> deleteWisata(BuildContext context, String id) async {
     try {
      final wisata = _state.wisataList.firstWhere((w) => w.id == id);

      // Hapus gambar utama dan gambar carousel dari Firebase Storage
      if (wisata.image.isNotEmpty) {
        await _storage.refFromURL(wisata.image).delete(); // Hapus gambar utama
      }
      for (String carouselImageUrl in wisata.carouselImages) {
        await _storage.refFromURL(carouselImageUrl).delete(); // Hapus gambar carousel
      }

      // Hapus data dari Firestore
      await _firestore.collection('wisata').doc(id).delete();

      // Hapus dari state lokal
      _state = _state.copyWith(
        wisataList: _state.wisataList.where((w) => w.id != id).toList(),
      );
      notifyListeners();
      // Tampilkan SnackBar setelah berhasil menghapus
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data wisata berhasil dihapus!'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Error deleting wisata: $e");
    }
  }

//menambahkan quantity
// Menambah quantity
  void increaseQuantity(Wisata wisata) {
    int index = _state.wisataList.indexWhere((element) => element.id == wisata.id);
    if (index != -1) {
      final updatedWisata = _state.wisataList[index].copyWith(
        quantity: _state.wisataList[index].quantity + 1,
      );
      final updatedList = List<Wisata>.from(_state.wisataList)..[index] = updatedWisata;
      _state = _state.copyWith(wisataList: updatedList);
      notifyListeners();
    }
  }

  // Mengurangi quantity
  void decreaseQuantity(Wisata wisata) {
    int index = _state.wisataList.indexWhere((element) => element.id == wisata.id);
    if (index != -1 && _state.wisataList[index].quantity > 1) {
      final updatedWisata = _state.wisataList[index].copyWith(
        quantity: _state.wisataList[index].quantity - 1,
      );
      final updatedList = List<Wisata>.from(_state.wisataList)..[index] = updatedWisata;
      _state = _state.copyWith(wisataList: updatedList);
      notifyListeners();
    }
  }


  // Menandai atau membatalkan favorit item
  void toggleFavorite(Wisata wisata) async {
    if (userId.isEmpty) return;

    final isFavorite = !wisata.isFavorite;
    final updatedWisata = wisata.copyWith(isFavorite: isFavorite);

    // Update state lokal
    _wisataList = _wisataList.map((w) => w.id == wisata.id ? updatedWisata : w).toList();
    notifyListeners();

    try {
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(wisata.id);

      if (isFavorite) {
        await docRef.set({'addedAt': DateTime.now()});
      } else {
        await docRef.delete();
      }
    } catch (e) {
      print("Error toggling favorite: $e");
    }
  }

  List<Wisata> get getFavoriteList {
  return _wisataList.where((wisata) => wisata.isFavorite).toList();
}


  // List<Wisata> get getFavoriteList =>
  //     _wisataList.where((wisata) => wisata.isFavorite).toList();



  // Menambah item ke keranjang
void addToCart(Wisata wisata) {
  int index = _state.wisataList.indexWhere((element) => element.id == wisata.id);
  if (index != -1) {
    final updatedWisata = _state.wisataList[index].copyWith(cart: true);
    final updatedList = List<Wisata>.from(_state.wisataList)..[index] = updatedWisata;
    _state = _state.copyWith(wisataList: updatedList);
    notifyListeners();
  }
}

// Menghapus item dari keranjang
void removeItem(Wisata wisata) {
  int index = _state.wisataList.indexWhere((element) => element.id == wisata.id);
  if (index != -1) {
    final updatedWisata = _state.wisataList[index].copyWith(cart: false);
    final updatedList = List<Wisata>.from(_state.wisataList)..[index] = updatedWisata;
    _state = _state.copyWith(wisataList: updatedList);
    notifyListeners();
  }
}

  // Update this function to format price as Rupiah
  double pricePerEachItem(Wisata wisata) {
    return wisata.quantity * wisata.price;
  }

  // Update total price to be displayed in Rupiah format
  // Menghitung total harga
  double get getTotalPrice {
    double totalPrice = 5000;
    for (var element in _state.wisataList) {
      if (element.cart) {
        totalPrice += element.quantity * element.price;
      }
    }
    return totalPrice;
  }

  // Format harga total sebagai Rupiah
  String getTotalPriceFormatted() {
    return _currencyFormat.format(getTotalPrice);
  }

  // Mendapatkan daftar cart
  List<Wisata> get getCartList => _state.wisataList.where((element) => element.cart).toList();

}
