import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum WisataType { all, tertinggi, jawabarat, jawatengah, jawatimur, best }

@immutable
class Wisata extends Equatable {
  final int id;
  final String image; // Main image
  final List<String> carouselImages; // Carousel images
  final String name;
  final double price;
  final int quantity;
  final bool isFavorite;
  final String description;
  final double score;
  final WisataType type;
  final int voter;
  final bool cart;

  const Wisata({
    this.cart = false,
    required this.id,
    required this.image,
    required this.carouselImages,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.isFavorite = false,
    required this.description,
    required this.score,
    required this.type,
    required this.voter,
  });

//metode representasi string dari objek wisata nya
  @override
  String toString() {
    return '\nWisata{id: $id, name: $name, quantity: $quantity, isFavorite: $isFavorite, cart: $cart}';
  }

//untuk mendefinisikan properti yang akan dibandigkan sama atau tidak
  @override
  List<Object?> get props => [
        id,
        image,
        carouselImages,
        name,
        price,
        quantity,
        isFavorite,
        description,
        score,
        type,
        voter,
        cart
      ];

//metode yang digunakan untuk membuat salinan dari objek wisata
  Wisata copyWith({
    int? id,
    String? image,
    List<String>? carouselImages,
    String? name,
    double? price,
    int? quantity,
    bool? isFavorite,
    String? description,
    double? score,
    WisataType? type,
    int? voter,
    bool? cart,
  }) {
    return Wisata(
      id: id ?? this.id,
      image: image ?? this.image,
      carouselImages: carouselImages ?? this.carouselImages,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      score: score ?? this.score,
      type: type ?? this.type,
      voter: voter ?? this.voter,
      cart: cart ?? this.cart,
    );
  }
}
