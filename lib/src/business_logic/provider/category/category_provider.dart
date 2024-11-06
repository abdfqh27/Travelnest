import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/data/model/wisata_category.dart';
import 'package:wisata_app/src/data/repository/repository.dart';
import 'package:wisata_app/src/business_logic/provider/category/category_state.dart';



class CategoryProvider with ChangeNotifier {
  CategoryState _state;

  Repository repository;

  CategoryProvider({required this.repository})
      : _state = CategoryState.initial(
          repository.getWisataList,
          repository.getCategories,
        );

  CategoryState get state => _state;

  filterItemByCategory(WisataCategory category) {
    final List<WisataCategory> categories = _state.wisataCategories.map((element) {
      if (element == category) {
        return category.copyWith(isSelected: true);
      }
      return element.copyWith(isSelected: false);
    }).toList();

    if (category.type == WisataType.all) {
      _state = _state.copyWith(
          wisataList: repository.getWisataList, wisataCategories: categories);
    } else {
      final List<Wisata> wisataList = repository.getWisataList
          .where((item) => item.type == category.type)
          .toList();

      _state = _state.copyWith(wisataList: wisataList, wisataCategories: categories);
    }
    notifyListeners();
  }
}
