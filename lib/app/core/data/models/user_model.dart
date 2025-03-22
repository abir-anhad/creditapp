class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? image;
  final String? coverImage;
  final String? role;
  final String? token;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
    this.coverImage,
    this.role,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      image: json['image'],
      coverImage: json['cover_image'],
      role: json['role'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'cover_image': coverImage,
      'role': role,
      'token': token,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? image,
    String? coverImage,
    String? role,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
      coverImage: coverImage ?? this.coverImage,
      role: role ?? this.role,
      token: token ?? this.token,
    );
  }
}