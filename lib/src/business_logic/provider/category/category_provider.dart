// src/business_logic/provider/category/category_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';
import 'package:wisata_app/src/data/model/wisata.dart'; // Mengimpor WisataType dari wisata.dart

class CategoryProvider with ChangeNotifier {
  List<WisataCategory> _categories = [];
  List<Wisata> _filteredWisataList = [];
  List<Wisata> _allWisataList = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<WisataCategory> get categories => _categories;
  List<Wisata> get filteredWisataList => _filteredWisataList;

  CategoryProvider() {
    fetchCategories();
    fetchAllWisata();
  }

  // Mengambil data kategori dari Firestore
  Future<void> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      _categories = snapshot.docs.map((doc) {
        return WisataCategory.fromFirestore(doc);
      }).toList();

      // Tambahkan kategori 'All' sebagai default
      _categories.insert(0, WisataCategory(type: WisataType.all, isSelected: true));
      notifyListeners();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Mengambil semua data wisata dari Firestore
  Future<void> fetchAllWisata() async {
    try {
      final snapshot = await _firestore.collection('wisata').get();
      _allWisataList = snapshot.docs.map((doc) => Wisata.fromFirestore(doc)).toList();
      _filteredWisataList = _allWisataList;
      notifyListeners();
    } catch (e) {
      print("Error fetching wisata: $e");
    }
  }

  // Filter item berdasarkan kategori yang dipilih
  void filterItemByCategory(WisataCategory selectedCategory) {
    // Update kategori yang dipilih dengan isSelected
    _categories = _categories.map((category) {
      return category.copyWith(isSelected: category == selectedCategory);
    }).toList();

    // Filter wisata berdasarkan kategori yang dipilih
    if (selectedCategory.type == WisataType.all) {
      _filteredWisataList = _allWisataList;
    } else {
      _filteredWisataList = _allWisataList.where((wisata) => wisata.type == selectedCategory.type).toList();
    }

    notifyListeners();
  }
}
