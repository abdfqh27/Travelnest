import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable; //memastikan kelas tidak dapat diubah setelah dibuat
import 'package:wisata_app/src/data/model/wisata.dart';

@immutable
class WisataCategory extends Equatable {
  //atribut
  final WisataType type;
  final bool isSelected;

  const WisataCategory({required this.type, required this.isSelected});

  @override
  //memastikan tidak ada properti yang sama atau identik
  List<Object?> get props => [type, isSelected];

  WisataCategory copyWith({WisataType? type, bool? isSelected}) {
    return WisataCategory(
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return '\nWisataCategory{type: $type, isSelected: $isSelected}';
  }
}
