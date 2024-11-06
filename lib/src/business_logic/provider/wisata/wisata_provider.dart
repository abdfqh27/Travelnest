import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:intl/intl.dart'; // Import intl package for currency formatting
import 'package:wisata_app/core/app_extension.dart';
import 'package:wisata_app/src/data/model/wisata.dart';
import 'package:wisata_app/src/data/repository/repository.dart';
import 'package:wisata_app/src/business_logic/provider/wisata/wisata_state.dart';

class WisataProvider with ChangeNotifier {
  WisataState _state;

  final Repository repository;

  WisataProvider({
    required this.repository,
  }) : _state = WisataState.initial(repository.getWisataList);

  WisataState get state => _state;

  // Format the price as Rupiah
  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');

//menambahkan quantity
  void increaseQuantity(Wisata wisata) {
    int index = _state.wisataList.getIndex(wisata);
    final List<Wisata> wisataList = _state.wisataList.map((element) {
      if (element.id == wisata.id) {
        return _state.wisataList[index]
            .copyWith(quantity: _state.wisataList[index].quantity + 1);
      }
      return element;
    }).toList();

    _state = _state.copyWith(wisataList: wisataList);
    notifyListeners();
  }

  void decreaseQuantity(Wisata wisata) {
    int index = _state.wisataList.getIndex(wisata);

    final List<Wisata> wisataList = _state.wisataList.map((element) {
      if (element.id == wisata.id && element.quantity > 1) {
        return _state.wisataList[index].copyWith(
          quantity: _state.wisataList[index].quantity - 1,
        );
      }
      //for Item quantity less than zero this statement will be called
      if (element.id == wisata.id) {
        //Remove item from cart
        return _state.wisataList[index].copyWith(cart: false);
      }
      return element;
    }).toList();
    _state = _state.copyWith(wisataList: wisataList);
    notifyListeners();
  }

  void removeItem(Wisata wisata) {
    final List<Wisata> wisataList = _state.wisataList.map((element) {
      if (element.id == wisata.id) {
        return wisata.copyWith(cart: false);
      }
      return element;
    }).toList();

    _state = _state.copyWith(wisataList: wisataList);
    notifyListeners();
  }

  void isFavorite(Wisata wisata) {
    int index = _state.wisataList.getIndex(wisata);
    final List<Wisata> wisataList = _state.wisataList.map((element) {
      if (element.id == wisata.id) {
        return wisata.copyWith(isFavorite: !_state.wisataList[index].isFavorite);
      }
      return element;
    }).toList();
    _state = _state.copyWith(wisataList: wisataList);
    notifyListeners();
  }

  void addToCart(Wisata wisata) {
    int index = _state.wisataList.getIndex(wisata);

    final List<Wisata> cartwisata = _state.wisataList.map((element) {
      if (element.id == wisata.id) {
        return _state.wisataList[index].copyWith(cart: true);
      }
      return element;
    }).toList();

    _state = _state.copyWith(wisataList: cartwisata);
  }

  // Update this function to format price as Rupiah
  double pricePerEachItem(Wisata wisata) {
    return wisata.quantity * wisata.price;
  }

  // Update total price to be displayed in Rupiah format
  double get getTotalPrice {
    double totalPrice = 5000; // Default minimum for taxes
    for (var element in _state.wisataList) {
      if (element.cart) {
        totalPrice += element.quantity * element.price;
      }
    }
    return totalPrice;
  }

  // Format the total price as Rupiah
  String getTotalPriceFormatted() {
    return _currencyFormat.format(getTotalPrice);
  }

  // Mendapatkan the cart list
  List<Wisata> get getCartList => _state.wisataList.where((element) => element.cart).toList();

  // Mendapatkan the favorite list
  List<Wisata> get getFavoriteList => _state.wisataList.where((element) => element.isFavorite).toList();
}
