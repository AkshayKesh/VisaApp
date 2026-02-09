class PaymentCardModel {
  final String holderName;
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final String? maskedNumber;
  final String? type;
  bool isSelected;

  PaymentCardModel({
    required this.holderName,
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    this.maskedNumber,
    this.type,
    this.isSelected = false,
  });

  PaymentCardModel copyWith({
    String? holderName,
    String? id,
    String? brand,
    String? last4,
    int? expMonth,
    int? expYear,
    String? maskedNumber,
    String? type,
    bool? isSelected,
  }) {
    return PaymentCardModel(
      holderName: holderName ?? this.holderName,
      id: id ?? this.id,
      brand: brand ?? this.brand,
      last4: last4 ?? this.last4,
      expMonth: expMonth ?? this.expMonth,
      expYear: expYear ?? this.expYear,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      type: type ?? this.type,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "holderName": holderName,
      "id": id,
      "brand": brand,
      "last4": last4,
      "exp_month": expMonth,
      "exp_year": expYear,
      "maskedNumber": maskedNumber,
      "type": type,
      "isSelected": isSelected,
    };
  }

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) {
    return PaymentCardModel(
      holderName: json['name'] ?? json['holderName'] ?? "",
      id: json['id'] ?? "",
      brand: json['brand'] ?? "",
      last4: json['last4'] ?? "",
      expMonth: json['exp_month'] ?? json['expMonth'] ?? 0,
      expYear: json['exp_year'] ?? json['expYear'] ?? 0,
      maskedNumber: json['maskedNumber'],
      type: json['type'],
      isSelected: json['isSelected'] ?? false,
    );
  }
}
