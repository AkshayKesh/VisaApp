import 'package:country_pickers/country.dart';

class PassportListingModel {
  PassportListingModel({
    required this.id,
    required this.userId,
    required this.passportFrontPhoto,
    required this.passportBackPhoto,
    required this.passportSizePhoto,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.firstNameController,
    this.lastNameController,
    this.passportNumberController,
    this.isseuCountry,
    this.birthDay,
    this.birthMonth,
    this.birthYear,
    this.passportExpiryDay,
    this.passportExpiryMonth,
    this.passportExpiryYear,
    this.country,
  });

  final String? id;
  final String? userId;
  final String? passportFrontPhoto;
  final String? passportBackPhoto;
  final String? passportSizePhoto;
  String? firstNameController;
  String? lastNameController;
  String? passportNumberController;
  String? isseuCountry;
  String? birthDay;
  String? birthMonth;
  String? birthYear;
  String? passportExpiryDay;
  String? passportExpiryMonth;
  String? passportExpiryYear;
  Country? country;

  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PassportListingModel copyWith({
    String? id,
    String? userId,
    String? passportFrontPhoto,
    String? passportBackPhoto,
    String? passportSizePhoto,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstNameControlle,
    String? lastNameController,
    String? passportNumberController,
    String? isseuCountry,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
    String? passportExpiryDay,
    String? passportExpiryMonth,
    String? passportExpiryYear,
    Country? country,
  }) {
    return PassportListingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      passportFrontPhoto: passportFrontPhoto ?? this.passportFrontPhoto,
      passportBackPhoto: passportBackPhoto ?? this.passportBackPhoto,
      passportSizePhoto: passportSizePhoto ?? this.passportSizePhoto,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,

      firstNameController: firstNameControlle ?? firstNameController,
      isseuCountry: isseuCountry ?? this.isseuCountry,
      lastNameController: lastNameController ?? this.lastNameController,
      passportNumberController: passportNumberController ?? this.passportNumberController,
      birthDay: birthDay ?? this.birthDay,
      birthMonth: birthMonth ?? this.birthMonth,
      birthYear: birthYear ?? this.birthYear,
      passportExpiryDay: passportExpiryDay ?? this.passportExpiryDay,
      passportExpiryMonth: passportExpiryMonth ?? this.passportExpiryMonth,
      country: country ?? this.country,
      passportExpiryYear: passportExpiryYear ?? this.passportExpiryYear,
    );
  }

  factory PassportListingModel.fromJson(Map<String, dynamic> json) {
    return PassportListingModel(
      firstNameController: json['firstName'],
      lastNameController: json['lastName'],
      passportNumberController: json['passportNumber'],
      isseuCountry: json['issuingCountry'],

      birthDay: json['birthDay']?.toString(),
      birthMonth: json['birthMonth']?.toString(),
      birthYear: json['birthYear']?.toString(),

      passportExpiryDay: json['expiryDay']?.toString(),
      passportExpiryMonth: json['expiryMonth']?.toString(),
      passportExpiryYear: json['expiryYear']?.toString(),

      id: json["_id"],
      userId: json["userId"],
      passportFrontPhoto: json["passportFrontPhoto"],
      passportBackPhoto: json["passportBackPhoto"],
      passportSizePhoto: json["passportSizePhoto"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    'firstName': firstNameController,
    'lastName': lastNameController,
    'passportNumber': passportNumberController,
    'issuingCountry': isseuCountry,
    'birthDay': birthDay,
    'birthMonth': birthMonth,
    'birthYear': birthYear,
    'country': country,
    'expiryDay': passportExpiryDay,
    'expiryMonth': passportExpiryMonth,
    'expiryYear': passportExpiryYear,
    "_id": id,
    "userId": userId,
    "passportFrontPhoto": passportFrontPhoto,
    "passportBackPhoto": passportBackPhoto,
    "passportSizePhoto": passportSizePhoto,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $userId, $passportFrontPhoto, $passportBackPhoto, $passportSizePhoto,  $status, $createdAt, $updatedAt, ";
  }
}
