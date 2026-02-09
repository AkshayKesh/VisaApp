import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Traveller {
  final String id;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController passportNumberController;
  final TextEditingController issuedCountryController;
  TextEditingController? emailController;
  String passportExpiryDate;
  String? birthDay;
  String? birthMonth;
  String? birthYear;
  String? passportExpiryDay;
  String? passportExpiryMonth;
  String? passportExpiryYear;
  String dateOfIssue;
  String? isseuCountry;
  String? passportPhotoUrl;
  final String? passportFrontPhotoUrl;
  final XFile? passportFrontPhotoFile;
  final String? passportBackPhotoUrl;
  final XFile? passportBackPhotoFile;
  final String? passportSizePhotoUrl;
  final XFile? passportSizePhotoFile;
  bool isExpanded;
   Country? country;
  // Controllers are created lazily and not serialized

  Traveller({
    required this.id,
    required this.firstNameController,
    required this.lastNameController,
    required this.passportNumberController,
    required this.passportExpiryDate,
    required this.dateOfIssue,
    required this.issuedCountryController,
    this.emailController,
    this.birthDay,
    this.birthMonth,
    this.birthYear,
    this.passportExpiryDay,
    this.passportExpiryMonth,
    this.passportExpiryYear,
    this.isseuCountry,
    this.passportPhotoUrl,
    this.passportFrontPhotoUrl,
    this.passportFrontPhotoFile,
    this.passportBackPhotoUrl,
    this.passportBackPhotoFile,
    this.passportSizePhotoUrl,
    this.passportSizePhotoFile,
    this.country,
    this.isExpanded = false,
  });

  factory Traveller.fromJson(Map<String, dynamic> json) {
    return Traveller(
      id: json['id'] as String? ?? '',
      lastNameController: json['lastName'],
      firstNameController: json['firstName'],
      isseuCountry: json['isseuCountry'],
      emailController: json['email'],
      birthDay: json["birthDay"],
      birthMonth: json["birthMonth"],
      birthYear: json["birthYear"],
      passportExpiryDay: json["passportExpiryDay"],
      passportExpiryMonth: json["passportExpiryMonth"],
      passportExpiryYear: json["passportExpiryYear"],
      passportNumberController: json['passportNumber'],
      issuedCountryController: json['issuingCountry'],
      passportExpiryDate: json['passportExpiryDate'] as String? ?? '',
      dateOfIssue: json['dateOfIssue'] as String? ?? '',
      passportPhotoUrl: json['passportPhotoUrl'] as String?,
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstNameController,
      'isseuCountry': isseuCountry,
      'lastName': lastNameController,
      'passportNumber': passportNumberController,
      'issuingCountry': issuedCountryController,
      'email': emailController,
      'passportExpiryDate': passportExpiryDate,
      'dateOfIssue': dateOfIssue,
      'passportPhotoUrl': passportPhotoUrl,
      'birthDay': birthDay,
      'birthMonth': birthMonth,
      'birthYear': birthYear,
      'country': country,
      'passportExpiryDay': passportExpiryDay,
      'passportExpiryMonth': passportExpiryMonth,
      'passportExpiryYear': passportExpiryYear,
    };
  }

  // Create a copy with updated values
  Traveller copyWith({
    String? id,
    TextEditingController? firstNameControlle,
    TextEditingController? lastNameController,
    TextEditingController? emailController,
    String? isseuCountry,
    Country? country,
    TextEditingController? passportNumberController,
    TextEditingController? issuingCountryController,
    String? passportExpiryDate,
    String? dateOfIssue,
    String? passportPhotoUrl,
    String? passportBackPhotoUrl,
    String? passportFrontPhotoUrl,
    XFile? passportFrontPhotoFile,
    XFile? passportBackPhotoFile,
    String? passportSizePhotoUrl,
    XFile? passportSizePhotoFile,
    String? birthDay,
    String? birthMonth,
    String? birthYear,
    String? passportExpiryDay,
    String? passportExpiryMonth,
    String? passportExpiryYear,
    bool? isExpanded,
  }) {
    return Traveller(
      firstNameController: firstNameControlle ?? firstNameController,
      id: id ?? this.id,
      isExpanded: isExpanded ?? this.isExpanded,
      lastNameController: lastNameController ?? this.lastNameController,
      isseuCountry: isseuCountry ?? this.isseuCountry,
      emailController: emailController ?? this.emailController,
      passportNumberController: passportNumberController ?? this.passportNumberController,
      passportExpiryDate: passportExpiryDate ?? this.passportExpiryDate,
      dateOfIssue: dateOfIssue ?? this.dateOfIssue,
      issuedCountryController: issuingCountryController ?? issuedCountryController,
      passportPhotoUrl: passportPhotoUrl ?? this.passportPhotoUrl,
      passportFrontPhotoUrl: passportFrontPhotoUrl ?? this.passportFrontPhotoUrl,
      passportBackPhotoUrl: passportBackPhotoUrl ?? this.passportBackPhotoUrl,
      passportFrontPhotoFile: passportFrontPhotoFile ?? this.passportFrontPhotoFile,
      passportBackPhotoFile: passportBackPhotoFile ?? this.passportBackPhotoFile,
      passportSizePhotoUrl: passportSizePhotoUrl ?? this.passportSizePhotoUrl,
      passportSizePhotoFile: passportSizePhotoFile ?? this.passportSizePhotoFile,
      birthDay: birthDay ?? this.birthDay,
      birthMonth: birthMonth ?? this.birthMonth,
      birthYear: birthYear ?? this.birthYear,
      passportExpiryDay: passportExpiryDay ?? this.passportExpiryDay,
      passportExpiryMonth: passportExpiryMonth ?? this.passportExpiryMonth,
      country: country ?? this.country,
      passportExpiryYear: passportExpiryYear ?? this.passportExpiryYear,
    );
  }
}
