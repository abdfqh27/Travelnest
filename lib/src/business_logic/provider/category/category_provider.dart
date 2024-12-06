import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';
import 'package:wisata_app/src/data/model/wisata.dart';

class CategoryProvider with ChangeNotifier {
  List<WisataCategory> _categories = [];
  List<Wisata> _filteredWisataList = [];
  List<Wisata> _allWisataList = []; // Semua data wisata

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<WisataCategory> get categories => _categories;
  List<Wisata> get filteredWisataList => _filteredWisataList;

  CategoryProvider() {
    initializeCategories();
    _listenToWisataChanges(); // Dengarkan perubahan real-time
  }

  /// Inisialisasi kategori default
  void initializeCategories() {
    _categories = [
      const WisataCategory(type: WisataType.semua, isSelected: true), // Default kategori "Semua"
      const WisataCategory(type: WisataType.gunung),
      const WisataCategory(type: WisataType.pantai),
      const WisataCategory(type: WisataType.air_terjun),
      const WisataCategory(type: WisataType.danau),
    ];
    notifyListeners();
  }

  /// Dengarkan perubahan real-time pada koleksi wisata di Firestore
  void _listenToWisataChanges() {
    _firestore.collection('wisata').snapshots().listen((snapshot) {
      // Perbarui daftar semua wisata
      _allWisataList = snapshot.docs
          .map((doc) => Wisata.fromFirestore(doc).copyWith(id: doc.id))
          .toList();

      // Terapkan filter berdasarkan kategori yang sedang aktif
      _applyCurrentFilter();
    });
  }

  /// Terapkan filter berdasarkan kategori yang sedang aktif
  void _applyCurrentFilter() {
    final selectedCategory =
        _categories.firstWhere((category) => category.isSelected);

    if (selectedCategory.type == WisataType.semua) {
      _filteredWisataList = _allWisataList;
    } else {
      _filteredWisataList = _allWisataList
          .where((wisata) => wisata.type == selectedCategory.type)
          .toList();
    }

    notifyListeners(); // Beritahu UI untuk memperbarui tampilan
  }

  /// Filter item berdasarkan kategori yang dipilih
  void filterItemByCategory(WisataCategory selectedCategory) {
    // Perbarui status kategori yang dipilih
    _categories = _categories.map((category) {
      return category.copyWith(isSelected: category == selectedCategory);
    }).toList();

    // Terapkan filter berdasarkan kategori baru
    _applyCurrentFilter();
  }

  /// Tambahkan wisata baru ke kategori
  void addWisata(Wisata newWisata) {
    _allWisataList.add(newWisata); // Tambahkan wisata baru
    _applyCurrentFilter(); // Terapkan filter ulang
  }

  /// Perbarui data wisata
  void updateWisata(Wisata updatedWisata) {
    final index = _allWisataList
        .indexWhere((wisata) => wisata.id == updatedWisata.id);
    if (index != -1) {
      _allWisataList[index] = updatedWisata; // Perbarui data wisata
      _applyCurrentFilter(); // Terapkan filter ulang
    }
  }

  /// Hapus wisata
  void deleteWisata(String wisataId) {
    _allWisataList.removeWhere((wisata) => wisata.id == wisataId); // Hapus wisata
    _applyCurrentFilter(); // Terapkan filter ulang
  }

  // Fungsi untuk mencari wisata berdasarkan nama
  void searchWisata(String query) {
    if (query.isEmpty) {
      _filteredWisataList = _allWisataList;
    } else {
      _filteredWisataList = _allWisataList
          .where((wisata) => wisata.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

   // Fungsi untuk mengatur wisata list dari API atau data statis
  void setWisataList(List<Wisata> wisatas) {
    _allWisataList = wisatas;
    _filteredWisataList = wisatas; // Awalnya tampilkan semua wisata
    notifyListeners();
  }
}
