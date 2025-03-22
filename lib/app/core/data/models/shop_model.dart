class ShopModel {
  final int? id;
  final String? ownerName;
  final String? shopName;
  final String? initialAmount;
  final String? tempInitialAmount;
  final String? gstNo;
  final String? shopPhone;
  final String? shopEmail;
  final String? image;
  final String? address;
  final String? description;

  ShopModel({
    this.id,
    this.ownerName,
    this.shopName,
    this.initialAmount,
    this.tempInitialAmount,
    this.gstNo,
    this.shopPhone,
    this.shopEmail,
    this.image,
    this.address,
    this.description,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'],
      ownerName: json['owner_name'],
      shopName: json['shop_name'],
      initialAmount: json['initial_amount'],
      tempInitialAmount: json['temp_initial_amount'],
      gstNo: json['gst_no'],
      shopPhone: json['shop_phone'],
      shopEmail: json['shop_email'],
      image: json['image'],
      address: json['address'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_name': ownerName,
      'shop_name': shopName,
      'initial_amount': initialAmount,
      'temp_initial_amount': tempInitialAmount,
      'gst_no': gstNo,
      'shop_phone': shopPhone,
      'shop_email': shopEmail,
      'image': image,
      'address': address,
      'description': description,
    };
  }
}

class ShopListResponse {
  final String type;
  final String text;
  final List<ShopModel> shops;

  ShopListResponse({
    required this.type,
    required this.text,
    required this.shops,
  });

  factory ShopListResponse.fromJson(Map<String, dynamic> json) {
    return ShopListResponse(
      type: json['type'],
      text: json['text'],
      shops: List<ShopModel>.from(
        json['shops'].map((x) => ShopModel.fromJson(x)),
      ),
    );
  }
}