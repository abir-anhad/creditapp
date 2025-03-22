class TransactionSummary {
  final String transactionDate;
  final String totalAmount;

  TransactionSummary({
    required this.transactionDate,
    required this.totalAmount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      transactionDate: json['transaction_date'],
      totalAmount: json['total_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_date': transactionDate,
      'total_amount': totalAmount,
    };
  }
}

class TransactionDetail {
  final String transactionType;
  final String amount;
  final String date;
  final String description;
  final String ownerName;
  final String shopName;
  final String shopPhone;
  final String shopEmail;
  final String address;
  final String? image;

  TransactionDetail({
    required this.transactionType,
    required this.amount,
    required this.date,
    required this.description,
    required this.ownerName,
    required this.shopName,
    required this.shopPhone,
    required this.shopEmail,
    required this.address,
    this.image,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      transactionType: json['transaction_type'] ?? '',
      amount: json['amount'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      ownerName: json['owner_name'] ?? '',
      shopName: json['shop_name'] ?? '',
      shopPhone: json['shop_phone'] ?? '',
      shopEmail: json['shop_email'] ?? '',
      address: json['address'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_type': transactionType,
      'amount': amount,
      'date': date,
      'description': description,
      'owner_name': ownerName,
      'shop_name': shopName,
      'shop_phone': shopPhone,
      'shop_email': shopEmail,
      'address': address,
      'image': image,
    };
  }
}

class TransactionListResponse {
  final String type;
  final String text;
  final List<TransactionSummary> transactions;

  TransactionListResponse({
    required this.type,
    required this.text,
    required this.transactions,
  });

  factory TransactionListResponse.fromJson(Map<String, dynamic> json) {
    return TransactionListResponse(
      type: json['type'],
      text: json['text'],
      transactions: List<TransactionSummary>.from(
        json['transactions'].map((x) => TransactionSummary.fromJson(x)),
      ),
    );
  }
}

class TransactionDetailsResponse {
  final String type;
  final String text;
  final List<TransactionDetail> transaction;

  TransactionDetailsResponse({
    required this.type,
    required this.text,
    required this.transaction,
  });

  factory TransactionDetailsResponse.fromJson(Map<String, dynamic> json) {
    print("JSON: ${List<TransactionDetail>.from(
      json['transaction'].map((x) => TransactionDetail.fromJson(x)),
    )}");
    return TransactionDetailsResponse(
      type: json['type'],
      text: json['text'],
      transaction: List<TransactionDetail>.from(
        json['transaction'].map((x) => TransactionDetail.fromJson(x)),
      ),
    );
  }
}

class CreateTransactionResponse {
  final String type;
  final String text;

  CreateTransactionResponse({
    required this.type,
    required this.text,
  });

  factory CreateTransactionResponse.fromJson(Map<String, dynamic> json) {
    return CreateTransactionResponse(
      type: json['type'],
      text: json['text'],
    );
  }
}