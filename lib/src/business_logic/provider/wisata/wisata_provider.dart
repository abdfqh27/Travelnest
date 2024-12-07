// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;
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
  List<Wisata> get getFavoriteList => _state.wisataList;


  
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

// Fungsi untuk mendapatkan 5 wisata terbaru berdasarkan timestamp
Stream<List<Wisata>> get bestWisataStream {
  return _firestore
      .collection('wisata')
      .orderBy('timestamp', descending: true) // Urutkan berdasarkan timestamp
      .limit(5) // Ambil hanya 5 data terakhir
      .snapshots()
      .map((snapshot) {
    // Debugging: Print jumlah dokumen yang diambil
    if (kDebugMode) {
      print("Debug: Received ${snapshot.docs.length} documents from Firestore.");
    }
    List<Wisata> bestWisataList = snapshot.docs.map((doc) {
      // Debugging: Print nama setiap wisata yang diambil
      final wisata = Wisata.fromFirestore(doc);
      if (kDebugMode) {
        print("Debug: Wisata - Name: ${wisata.name}, Timestamp: ${wisata.timestamp.toDate()}");
      }
      return wisata;
    }).toList();

    // Debugging: Print seluruh daftar wisata terbaik
    if (kDebugMode) {
      print("Debug: Complete Best Wisata List: ${bestWisataList.map((w) => w.name).toList()}");
    }
    return bestWisataList;
  });
}





  // Metode untuk mengambil data wisata dari Firestore
   Future<void> fetchWisata() async {
  try {
    final snapshot = await _firestore.collection('wisata').get();
    final wisataList = snapshot.docs
        .map((doc) => Wisata.fromFirestore(doc).copyWith(id: doc.id))
        .toList();

    _state = _state.copyWith(wisataList: wisataList);

    await fetchFavoritesForCurrentUser();
    notifyListeners();
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching wisata: $e");
    }
  }
}


  Future<void> fetchFavoritesForCurrentUser() async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) return;

  try {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .get();
   if (kDebugMode) {
     print("Favorites snapshot: ${snapshot.docs.map((doc) => doc.id).toList()}");
   }


    // Buat daftar wisata dari dokumen di subkoleksi favorites
    final List<Wisata> userFavorites = [];
    for (var doc in snapshot.docs) {
      final wisataSnapshot =
          await _firestore.collection('wisata').doc(doc.id).get();
      if (wisataSnapshot.exists) {
        userFavorites.add(Wisata.fromFirestore(wisataSnapshot));
      }
    }

    // Update state dengan daftar favorit user
    _state = _state.copyWith(wisataList: userFavorites);
    notifyListeners();
  } catch (e) {
    if (kDebugMode) {
      print("Error fetching favorites for current user: $e");
    }
  }
}

void resetFavorites() {
  _state = const WisataState.initial([]);
  _wisataList = [];
  notifyListeners();
}




   // Fungsi untuk mengunggah beberapa gambar dan mendapatkan URL-nya
  // ignore: unused_element
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
  Future<void> addWisata(
  Wisata wisata,
  XFile? mainImageFile,
  List<XFile>? carouselImages,
  BuildContext context,
) async {
  try {
    String mainImageUrl = '';
    List<String> carouselImageUrls = [];

    // Unggah gambar utama
    if (mainImageFile != null) {
      final mainImageRef =
          _storage.ref().child('images/main/${mainImageFile.name}');
      await mainImageRef.putFile(File(mainImageFile.path));
      mainImageUrl = await mainImageRef.getDownloadURL();
    }

    // Unggah gambar carousel
    if (carouselImages != null && carouselImages.isNotEmpty) {
      for (final image in carouselImages) {
        final carouselRef =
            _storage.ref().child('images/carousel/${image.name}');
        await carouselRef.putFile(File(image.path));
        final imageUrl = await carouselRef.getDownloadURL();
        carouselImageUrls.add(imageUrl);
      }
    }

    // Tambahkan wisata ke Firestore
    final newWisata = wisata.copyWith(
      image: mainImageUrl,
      carouselImages: carouselImageUrls,
      timestamp: Timestamp.now(),
    );

    final docRef = await _firestore.collection('wisata').add(newWisata.toMap());

    // Perbarui state lokal dengan ID
    final wisataWithId = newWisata.copyWith(id: docRef.id);
    _state = _state.copyWith(wisataList: [..._state.wisataList, wisataWithId]);

    notifyListeners();

    // Sinkronisasi dengan CategoryProvider
    // ignore: use_build_context_synchronously
    context.read<CategoryProvider>().addWisata(wisataWithId);

    // Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wisata berhasil ditambahkan!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error adding wisata: $e");
    }
  }
} 

  // Memperbarui data wisata di Firestore
  // Menambahkan fungsi untuk update wisata
Future<void> updateWisata(
  BuildContext context,
  Wisata updatedWisata,
  XFile? mainImageFile,
  List<XFile>? carouselImages,
) async {
  try {
    String mainImageUrl = updatedWisata.image;
    List<String> carouselUrls = updatedWisata.carouselImages;

    // Perbarui gambar utama jika ada perubahan
    if (mainImageFile != null) {
      // Hapus gambar utama lama
      if (mainImageUrl.isNotEmpty) {
        await _storage.refFromURL(mainImageUrl).delete();
      }

      // Unggah gambar utama baru
      final mainImageRef =
          _storage.ref().child('images/main/${mainImageFile.name}');
      await mainImageRef.putFile(File(mainImageFile.path));
      mainImageUrl = await mainImageRef.getDownloadURL();
    }

    // Perbarui gambar carousel jika ada perubahan
    if (carouselImages != null && carouselImages.isNotEmpty) {
      // Hapus gambar carousel lama
      for (final url in carouselUrls) {
        await _storage.refFromURL(url).delete();
      }

      // Unggah gambar carousel baru
      carouselUrls = [];
      for (final image in carouselImages) {
        final carouselRef =
            _storage.ref().child('images/carousel/${image.name}');
        await carouselRef.putFile(File(image.path));
        final imageUrl = await carouselRef.getDownloadURL();
        carouselUrls.add(imageUrl);
      }
    }

    // Perbarui data wisata di Firestore
    final updatedData = updatedWisata.copyWith(
      image: mainImageUrl,
      carouselImages: carouselUrls,
    );
    await _firestore.collection('wisata').doc(updatedData.id).update(updatedData.toMap());

    // Perbarui state lokal
    final index = _state.wisataList.indexWhere((w) => w.id == updatedData.id);
    if (index != -1) {
      final updatedList = List<Wisata>.from(_state.wisataList)
        ..[index] = updatedData;
      _state = _state.copyWith(wisataList: updatedList);
      notifyListeners();
    }

    // Sinkronisasi dengan CategoryProvider
    context.read<CategoryProvider>().updateWisata(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wisata berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error updating wisata: $e");
    }
  }
}

  // Menghapus wisata dari Firestore
  Future<void> deleteWisata(BuildContext context, String id) async {
  try {
    final wisata = _state.wisataList.firstWhere((w) => w.id == id);

    // Hapus gambar utama
    if (wisata.image.isNotEmpty) {
      await _storage.refFromURL(wisata.image).delete();
    }

    // Hapus gambar carousel
    for (final url in wisata.carouselImages) {
      await _storage.refFromURL(url).delete();
    }

    // Hapus data dari Firestore
    await _firestore.collection('wisata').doc(id).delete();

    // Perbarui state lokal
    _state = _state.copyWith(
      wisataList: _state.wisataList.where((w) => w.id != id).toList(),
    );

    notifyListeners();

    // Sinkronisasi dengan CategoryProvider
    context.read<CategoryProvider>().deleteWisata(id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wisata berhasil dihapus!'),
        backgroundColor: Colors.red,
      ),
    );
  } catch (e) {
    if (kDebugMode) {
      print("Error deleting wisata: $e");
    }
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
  Future<void> toggleFavorite(Wisata wisata) async {
  final userId = _auth.currentUser?.uid;
  if (userId == null) {
    if (kDebugMode) {
      print("User is not logged in.");
    }
    return;
  }

  try {
    // Referensi ke subkoleksi favorites
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(wisata.id);

    // Cek apakah wisata sudah ada di favorites
    final docSnapshot = await docRef.get();
    final isFavorite = docSnapshot.exists;

    if (isFavorite) {
      // Jika sudah ada, hapus dari favorites
      await docRef.delete();

      // Hapus dari state lokal
      _state = _state.copyWith(
        wisataList: _state.wisataList.where((w) => w.id != wisata.id).toList(),
      );
    } else {
      // Jika belum ada, tambahkan ke favorites
      await docRef.set({'addedAt': FieldValue.serverTimestamp()});

      // Tambahkan ke state lokal
      _state = _state.copyWith(
        wisataList: [..._state.wisataList, wisata],
      );
    }

    notifyListeners(); // Perbarui UI
  } catch (e) {
    if (kDebugMode) {
      print("Error toggling favorite: $e");
    }
  }
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
