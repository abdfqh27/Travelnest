import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

enum WisataType { semua, gunung, pantai, air_terjun, danau }

@immutable
class Wisata extends Equatable {
  final String id;
  final String image;
  final List<String> carouselImages;
  final String name;
  final double price;
  final int quantity;
  final bool isFavorite;
  final String description;
  final String location; // Lokasi wisata
  final Timestamp timestamp; // Waktu penambahan atau pembaruan
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
    required this.location,
    required this.timestamp,
    required this.score,
    required this.type,
    required this.voter,
  });

  // Konversi objek Wisata menjadi Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'carouselImages': carouselImages,
      'name': name,
      'price': price,
      'quantity': quantity,
      'isFavorite': isFavorite,
      'description': description,
      'location': location,
      'timestamp': timestamp,
      'score': score,
      'type': type.toString().split('.').last, // Simpan type sebagai String
      'voter': voter,
      'cart': cart,
    };
  }

  // Membuat objek Wisata dari Firestore Document
  factory Wisata.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Wisata(
      id: doc.id,
      image: data['image'],
      carouselImages: List<String>.from(data['carouselImages'] ?? []),
      name: data['name'],
      // Konversi harga ke double jika diperlukan
      price: (data['price'] is int)
          ? (data['price'] as int).toDouble()
          : (data['price'] ?? 0.0),
      quantity: data['quantity'] ?? 1,
      isFavorite: data['isFavorite'] ?? false,
      description: data['description'],
      location: data['location'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      // Konversi skor ke double jika diperlukan
      score: (data['score'] is int)
          ? (data['score'] as int).toDouble()
          : (data['score'] ?? 0.0),
      type: _mapStringToWisataType(data['type']),
      voter: data['voter'],
      cart: data['cart'] ?? false,
    );
  }

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
        location,
        timestamp,
        score,
        type,
        voter,
        cart,
      ];

  // Membuat salinan objek Wisata dengan nilai yang dimodifikasi
  Wisata copyWith({
    String? id,
    String? image,
    List<String>? carouselImages,
    String? name,
    double? price,
    int? quantity,
    bool? isFavorite,
    String? description,
    String? location,
    Timestamp? timestamp,
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
      location: location ?? this.location, // Perbarui location
      timestamp: timestamp ?? this.timestamp, // Perbarui timestamp
      score: score ?? this.score,
      type: type ?? this.type,
      voter: voter ?? this.voter,
      cart: cart ?? this.cart,
    );
  }

  // Fungsi pembantu untuk mapping String ke WisataType
  static WisataType _mapStringToWisataType(String? type) {
    switch (type) {
      case 'gunung':
        return WisataType.gunung;
      case 'pantai':
        return WisataType.pantai;
      case 'air_terjun':
        return WisataType.air_terjun;
      case 'danau':
        return WisataType.danau;
      default:
        return WisataType.semua;
    }
  }
}
