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
    initializeCategories(); // Tambahkan kategori default saat provider dibuat
    fetchAllWisata();
  }

  // Method untuk inisialisasi kategori default
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

  // Mengambil semua data wisata dari Firestore
  Future<void> fetchAllWisata() async {
    try {
      final snapshot = await _firestore.collection('wisata').get();
      _allWisataList = snapshot.docs.map((doc) => Wisata.fromFirestore(doc)).toList();
      _filteredWisataList = _allWisataList; // Tampilkan semua data sebagai default
      notifyListeners();
    } catch (e) {
      print("Error fetching wisata: $e");
    }
  }

  // Filter item berdasarkan kategori yang dipilih
  void filterItemByCategory(WisataCategory selectedCategory) {
    // Update kategori yang dipilih
    _categories = _categories.map((category) {
      return category.copyWith(isSelected: category == selectedCategory);
    }).toList();

    // Filter wisata berdasarkan kategori
    if (selectedCategory.type == WisataType.semua) {
      _filteredWisataList = _allWisataList; // Tampilkan semua data
    } else {
      _filteredWisataList = _allWisataList
          .where((wisata) => wisata.type == selectedCategory.type)
          .toList();
    }

    notifyListeners();
  }

  void addWisata(Wisata newWisata) {
  _allWisataList.add(newWisata); // Tambahkan wisata ke daftar semua wisata
  filterItemByCategory(_categories.firstWhere((category) => category.isSelected)); // Perbarui filter berdasarkan kategori yang sedang dipilih
  notifyListeners(); // Beri tahu listener bahwa data telah berubah
}


  // Fungsi untuk memperbarui data wisata
  void updateWisata(Wisata updatedWisata) {
  final index = _allWisataList.indexWhere((wisata) => wisata.id == updatedWisata.id);
  if (index != -1) {
    _allWisataList[index] = updatedWisata; // Perbarui wisata di daftar semua wisata
    filterItemByCategory(_categories.firstWhere((category) => category.isSelected)); // Perbarui filter berdasarkan kategori yang sedang dipilih
    notifyListeners(); // Beri tahu listener bahwa data telah berubah
  }
}


  // Fungsi untuk menghapus wisata
  void deleteWisata(String wisataId) {
    _allWisataList.removeWhere((wisata) => wisata.id == wisataId); // Hapus wisata
    filterItemByCategory(
      _categories.firstWhere((category) => category.isSelected), // Perbarui filter
    );
  }
}
