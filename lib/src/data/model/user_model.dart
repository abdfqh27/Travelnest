import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String jeniskelamin;
  final String nohp;
  final String address;
  final String photoUrl;
  final String role;
  final DateTime? birthDate;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.jeniskelamin,
    required this.nohp,
    required this.email,
    required this.address,
    required this.photoUrl,
    required this.role,
    this.birthDate,
    this.createdAt
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? jeniskelamin,
    String? nohp,
    String? email,
    String? address,
    String? photoUrl,
    String? role,
    DateTime? birthDate,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      jeniskelamin: jeniskelamin ?? this.jeniskelamin,
      nohp: nohp ?? this.nohp,
      email: email ?? this.email,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      jeniskelamin: map['jeniskelamin'] ?? '',
      nohp: map['nohp'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      role: map['role'] ?? 'user',
      birthDate: map['birthDate'] != null
          ? DateTime.parse(map['birthDate']) // Konversi String ke DateTime
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate() // Konversi Timestamp ke DateTime
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jeniskelamin': jeniskelamin,
      'nohp': nohp,
      'email': email,
      'address': address,
      'photoUrl': photoUrl,
      'role': role,
      'birthDate': birthDate?.toIso8601String(),
      'createdAt': createdAt,
    };
  }
}
