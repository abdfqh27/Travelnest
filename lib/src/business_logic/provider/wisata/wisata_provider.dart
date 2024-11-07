import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:intl/intl.dart'; // Import intl package for currency formatting
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wisata_app/src/data/repository/repository.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_state.dart';

class WisataProvider with ChangeNotifier {
  WisataState _state;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  WisataProvider() : _state = const WisataState.initial([]){
    // Panggil `fetchWisata` untuk memastikan data diambil saat provider diinisialisasi
    fetchWisata();
  }

  // final Repository repository;

  // WisataProvider({
  //   required this.repository,
  // }) : _state = WisataState.initial(repository.getWisataList);

  // Tambahkan getter ini untuk mendapatkan daftar wisata
  List<Wisata> get wisataList => _state.wisataList;
  
  WisataState get state => _state;

  // Format the price as Rupiah
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

  // Metode untuk mengambil data wisata dari Firestore
  Future<void> fetchWisata() async {
    try {
      final snapshot = await _firestore.collection('wisata').get();
      _state = WisataState(
        wisataList: snapshot.docs.map((doc) => Wisata.fromFirestore(doc)).toList(),
      );
      notifyListeners();
    } catch (e) {
      print("Error fetching wisata: $e");
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
  Future<void> addWisata(Wisata wisata,  XFile? mainImageFile, List<XFile>? carouselImages) async {
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
    _state = _state.copyWith(
      wisataList: [..._state.wisataList, newWisata.copyWith(id: docRef.id)],
    );
    notifyListeners();
  }

  // Memperbarui data wisata di Firestore
  // Menambahkan fungsi untuk update wisata
Future<void> updateWisata(Wisata updatedWisata, XFile? mainImageFile, List<XFile>? carouselImages) async {
  try {
    String imageUrl = updatedWisata.image;
    List<String> carouselUrls = updatedWisata.carouselImages;

    // Jika gambar utama di-update, unggah gambar baru
    if (mainImageFile != null) {
      final storageRef = _storage.ref().child('images/${mainImageFile.name}');
      await storageRef.putFile(File(mainImageFile.path));
      imageUrl = await storageRef.getDownloadURL();
    }

    // Jika gambar carousel di-update, unggah gambar baru
    if (carouselImages != null && carouselImages.isNotEmpty) {
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
  } catch (e) {
    print("Error updating wisata: $e");
  }
}

  // Menghapus wisata dari Firestore
  Future<void> deleteWisata(String id) async {
    await _firestore.collection('wisata').doc(id).delete();
    _state = _state.copyWith(
      wisataList: _state.wisataList.where((w) => w.id != id).toList(),
    );
    notifyListeners();
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
  // Menandai atau membatalkan favorit item dan menyimpan status ke Firebase
  void toggleFavorite(Wisata wisata) async {
    int index = _state.wisataList.indexWhere((element) => element.id == wisata.id);
    if (index != -1) {
      final updatedWisata = _state.wisataList[index].copyWith(
        isFavorite: !_state.wisataList[index].isFavorite,
      );

      // Update status favorit di Firebase
      await _firestore.collection('wisata').doc(wisata.id).update({
        'isFavorite': updatedWisata.isFavorite,
      });

      // Update state lokal
      final updatedList = List<Wisata>.from(_state.wisataList)
        ..[index] = updatedWisata;
      _state = _state.copyWith(wisataList: updatedList);
      notifyListeners();
    }
  }


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

  // Mendapatkan daftar favorit
  List<Wisata> get getFavoriteList => _state.wisataList.where((element) => element.isFavorite).toList();
}
