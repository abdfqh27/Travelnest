// src/data/model/wisata_category.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum WisataType { all, tertinggi, jawabarat, jawatengah, jawatimur, best }

@immutable
class WisataCategory extends Equatable {
  final WisataType type;
  final bool isSelected;

  const WisataCategory({required this.type, this.isSelected = false});

  @override
  List<Object?> get props => [type, isSelected];

  // Metode untuk membuat objek WisataCategory dari Firestore
  factory WisataCategory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WisataCategory(
      type: _mapStringToWisataType(data['type']),
      isSelected: data['isSelected'] ?? false,
    );
  }

  // Fungsi pembantu untuk mengonversi String ke WisataType
  static WisataType _mapStringToWisataType(String? type) {
    switch (type) {
      case 'tertinggi':
        return WisataType.tertinggi;
      case 'jawabarat':
        return WisataType.jawabarat;
      case 'jawatengah':
        return WisataType.jawatengah;
      case 'jawatimur':
        return WisataType.jawatimur;
      case 'best':
        return WisataType.best;
      default:
        return WisataType.all;
    }
  }

  // Salinan objek dengan nilai baru
  WisataCategory copyWith({WisataType? type, bool? isSelected}) {
    return WisataCategory(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'WisataCategory(type: $type, isSelected: $isSelected)';
  }
}
