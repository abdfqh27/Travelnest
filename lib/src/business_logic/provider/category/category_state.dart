import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';

@immutable
class CategoryState extends Equatable {
  final List<WisataCategory> wisataCategories;
  final List<Wisata> wisataList;

  const CategoryState.initial(
      List<Wisata> wisataList, List<WisataCategory> wisataCategories)
      : this(wisataList: wisataList, wisataCategories: wisataCategories);

  const CategoryState({required this.wisataCategories, required this.wisataList});

  @override
  List<Object?> get props => [wisataCategories, wisataList];

  CategoryState copyWith({
    List<WisataCategory>? wisataCategories,
    List<Wisata>? wisataList,
  }) {
    return CategoryState(
      wisataCategories: wisataCategories ?? this.wisataCategories,
      wisataList: wisataList ?? this.wisataList,
    );
  }
}
