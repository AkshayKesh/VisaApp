import 'package:country_pickers/country.dart';
import 'package:image_picker/image_picker.dart';

class AddPassportState {
  bool isLoading;
  bool isSuccess;
  String? error;
  AddPasspoetModel? addPasspoetModel;

  AddPassportState({this.isLoading = false, this.isSuccess = false, this.error, this.addPasspoetModel});

  AddPassportState copyWith({bool? isLoading, bool? isSuccess, String? error, AddPasspoetModel? addPasspoetModel}) {
    return AddPassportState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error ?? this.error,
      addPasspoetModel: addPasspoetModel ?? this.addPasspoetModel,
    );
  }
}

class AddPasspoetModel {
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

  // final String? fullName;
  // final String? passportNumber;
  // final String? issuingCountry;
  // final String? dateOfIssue;
  // final String? dateOfExpiry;
  final String? passportFrontPhotoUrl;
  final XFile? passportFrontPhotoFile;
  final String? passportBackPhotoUrl;
  final XFile? passportBackPhotoFile;
  final String? passportSizePhotoUrl;
  final XFile? passportSizePhotoFile;

  AddPasspoetModel({
    // this.fullName,
    // this.passportNumber,
    // this.issuingCountry,
    // this.dateOfIssue,
    // this.dateOfExpiry,
    this.passportFrontPhotoUrl,
    this.passportFrontPhotoFile,
    this.passportBackPhotoUrl,
    this.passportBackPhotoFile,
    this.passportSizePhotoUrl,
    this.passportSizePhotoFile,

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
  AddPasspoetModel copyWith({
    // String? fullName,
    // String? passportNumber,
    // String? issuingCountry,
    // String? dateOfIssue,
    // String? dateOfExpiry,
    String? passportFrontPhotoUrl,
    String? passportBackPhotoUrl,
    XFile? passportFrontPhotoFile,
    XFile? passportBackPhotoFile,
    String? passportSizePhotoUrl,
    XFile? passportSizePhotoFile,

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
    return AddPasspoetModel(
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
      // fullName: fullName ?? this.fullName,
      // passportNumber: passportNumber ?? this.passportNumber,
      // issuingCountry: issuingCountry ?? this.issuingCountry,
      // dateOfIssue: dateOfIssue ?? this.dateOfIssue,
      // dateOfExpiry: dateOfExpiry ?? this.dateOfExpiry,
      passportFrontPhotoUrl: passportFrontPhotoUrl ?? this.passportFrontPhotoUrl,
      passportBackPhotoUrl: passportBackPhotoUrl ?? this.passportBackPhotoUrl,
      passportFrontPhotoFile: passportFrontPhotoFile ?? this.passportFrontPhotoFile,
      passportBackPhotoFile: passportBackPhotoFile ?? this.passportBackPhotoFile,
      passportSizePhotoUrl: passportSizePhotoUrl ?? this.passportSizePhotoUrl,
      passportSizePhotoFile: passportSizePhotoFile ?? this.passportSizePhotoFile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      // 'fullName': fullName,
      // 'passportNumber': passportNumber,
      // 'issuingCountry': issuingCountry,
      // 'dateOfIssue': dateOfIssue,
      // 'dateOfExpiry': dateOfExpiry,
    };
  }
}
