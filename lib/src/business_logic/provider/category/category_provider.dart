// src/business_logic/provider/category/category_provider.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';
import 'package:wisata_app/src/data/model/wisata.dart' as WisataModel;

class CategoryProvider with ChangeNotifier {
  List<WisataCategory> _categories = [];
  List<WisataModel.Wisata> _filteredWisataList = [];

  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<WisataCategory> get categories => _categories;
  List<WisataModel.Wisata> get filteredWisataList => _filteredWisataList;

  // Metode untuk mengambil data kategori dari Firestore
  Future<void> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      _categories = snapshot.docs.map((doc) {
        return WisataCategory.fromFirestore(doc);
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  // Filter item berdasarkan kategori yang dipilih
  void filterItemByCategory(WisataCategory category) {
    final updatedCategories = _categories.map((element) {
      if (element == category) {
        return category.copyWith(isSelected: true);
      }
      return element.copyWith(isSelected: false);
    }).toList();

    _categories = updatedCategories;

    // Filter wisata berdasarkan kategori yang dipilih
    if (category.type == WisataModel.WisataType.all) {
      _filteredWisataList = _getAllWisata(); // Metode untuk mengambil semua wisata
    } else {
      _filteredWisataList = _getAllWisata()
          .where((wisata) => wisata.type == category.type)
          .toList();
    }

    notifyListeners();
  }

  // Fungsi untuk mengambil semua data wisata dari Firestore
  List<WisataModel.Wisata> _getAllWisata() {
    // Implementasi logika untuk mengambil data wisata dari Firestore atau repository
    // Misalnya: mengambil data dari collection 'wisata' di Firestore
    // Kembalikan data wisata dalam bentuk List<Wisata>
    return [];
  }
}
