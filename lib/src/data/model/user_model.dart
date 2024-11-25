class UserModel {
  final String id;
  final String name;
  final String email;
  final String address;
  final String photoUrl;
  final String role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.photoUrl,
    required this.role,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? address,
    String? photoUrl,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      role: map['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'photoUrl': photoUrl,
      'role': role,
    };
  }
}
