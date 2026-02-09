import 'dart:typed_data';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/domain/passport_listing_model.dart';
import 'package:register_visa_web_app/features/profile/providers/states/add_passport_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';

class AddPassportController extends StateNotifier<AddPassportState> {
  AddPassportController() : super(AddPassportState()) {
    loadInit();
  }
  void loadInit() {
    state = state.copyWith(
      isLoading: false,
      isSuccess: false,
      error: null,
      addPasspoetModel: AddPasspoetModel(
        passportBackPhotoUrl: "",
        passportFrontPhotoUrl: "",
        passportSizePhotoUrl: "",
        firstNameController: "",
        lastNameController: "",
        passportNumberController: "",
        isseuCountry: "USA",
      ),
    );
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passportNumberController = TextEditingController();
  Country? country;
  String birthMonth = "";
  String birthDay = "";
  String birthYear = "";
  String passportExpiryDay = "";
  String passportExpiryMonth = "";
  String passportExpiryYear = "";

  // Variables to hold string values for passport URLs
  String _passportBackUrl = "";
  String _passportFrontUrl = "";
  String _passportPhotoUrl = "";
  String? _passpoerPhotoError = "";

  String? get passportError => _passpoerPhotoError;

  set passportError(String? value) {
    _passpoerPhotoError = value;
  }

  // Passport photo URL getter and setter
  String get passportPhoto => _passportPhotoUrl;

  set passportPhoto(String value) {
    _passportPhotoUrl = value;
  }

  // Getter and Setter for passportBackUrl
  String get passportBackUrl => _passportBackUrl;

  set passportBackUrl(String value) {
    _passportBackUrl = value;
  }

  // Getter and Setter for passportFrontUrl
  String get passportFrontUrl => _passportFrontUrl;

  set passportFrontUrl(String value) {
    _passportFrontUrl = value;
  }

  // Getter and Setter for passportPhotoUrl
  String get passportPhotoUrl => _passportPhotoUrl;

  set passportPhotoUrl(String value) {
    _passportPhotoUrl = value;
  }

  void changeMonth(String? value) {
    if (value == null) return;
    birthMonth = value;
    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(birthMonth: value));
  }

  void changeDay(String? value) {
    if (value == null) return;
    birthDay = value;
    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(birthDay: value));
  }

  void changeYear(String? value) {
    if (value == null) return;
    birthYear = value;
    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(birthYear: value));
  }

  void updateMyPassportCountry(Country value) {
    country = value;

    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(isseuCountry: value.name));
  }

  void updateExpireDay(String? value) {
    if (value == null) return;

    passportExpiryDay = value;

    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(passportExpiryDay: value));
  }

  void updateExpireMonth(String? value) {
    if (value == null) return;

    passportExpiryMonth = value;

    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(passportExpiryMonth: value));
  }

  void updateExpireYear(String? value) {
    if (value == null) return;

    passportExpiryYear = value;

    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(passportExpiryYear: value));
  }

  Future addPassport({String? passportId}) async {
    try {
      if (passportError?.isNotEmpty ?? false) {
        return;
      }

      state = state.copyWith(isLoading: true, error: null, isSuccess: false);
      if (state.addPasspoetModel?.passportFrontPhotoFile != null) {
        String? value = await uploadImage(file: state.addPasspoetModel!.passportFrontPhotoFile!);
        if (value != null) {
          passportFrontUrl = value;
          state = state.copyWith();
        }
      }
      if (state.addPasspoetModel?.passportBackPhotoFile != null) {
        String? value = await uploadImage(file: state.addPasspoetModel!.passportBackPhotoFile!);
        if (value != null) {
          passportBackUrl = value;
          state = state.copyWith();
        }
      }

      if (passportId == null) {
        ResponseAPI response = await ApiManager.post(
          methodName: ApiEndpoints.addPassport,
          params: {
            "firstName": firstNameController.text,
            "lastName": lastNameController.text,
            "passportNumber": passportNumberController.text,
            "birthDay": birthDay,
            "birthMonth": getMonthNumber(birthMonth).toString(),
            "birthYear": birthYear,
            "expiryDay": passportExpiryDay,
            "expiryMonth": getMonthNumber(passportExpiryMonth).toString(),
            "expiryYear": passportExpiryYear,
            "issuingCountry": country?.name ?? "",
            "passportFrontPhoto": passportFrontUrl,
            "passportBackPhoto": passportBackUrl,
            "passportSizePhoto": passportPhotoUrl,
          },
        );
        if (response.data["statusCode"] == 200) {
          state = state.copyWith(isLoading: false, isSuccess: true);
        } else {
          state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: response.data["message"],
            addPasspoetModel: AddPasspoetModel(
              firstNameController: firstNameController.text,
              lastNameController: lastNameController.text,
              passportNumberController: passportNumberController.text,
              birthDay: birthDay,
              birthMonth: getMonthNumber(birthMonth).toString(),
              birthYear: birthYear,
              passportExpiryDay: passportExpiryDay,
              passportExpiryMonth: getMonthNumber(passportExpiryMonth).toString(),
              passportExpiryYear: passportExpiryYear,
              isseuCountry: country?.name ?? "",
              passportBackPhotoUrl: passportBackUrl,
              passportFrontPhotoUrl: passportFrontUrl,
              passportSizePhotoUrl: passportPhotoUrl,
            ),
          );
        }
      } else {
        ResponseAPI response = await ApiManager.put(
          methodName: "${ApiEndpoints.updatePassport}/$passportId",
          params: {
            "firstName": firstNameController.text,
            "lastName": lastNameController.text,
            "passportNumber": passportNumberController.text,
            "birthDay": birthDay,
            "birthMonth": getMonthNumber(birthMonth).toString(),
            "birthYear": birthYear,
            "expiryDay": passportExpiryDay,
            "expiryMonth": getMonthNumber(passportExpiryMonth).toString(),
            "expiryYear": passportExpiryYear,
            "issuingCountry": country?.name ?? "",
            "passportFrontPhoto": passportFrontUrl,
            "passportBackPhoto": passportBackUrl,
            "passportSizePhoto": passportPhotoUrl,
          },
        );
        if (response.data["statusCode"] == 200) {
          state = state.copyWith(isLoading: false, isSuccess: true);
        } else {
          state = state.copyWith(
            isLoading: false,
            isSuccess: false,
            error: response.data["message"],
            addPasspoetModel: AddPasspoetModel(
              firstNameController: firstNameController.text,
              lastNameController: lastNameController.text,
              passportNumberController: passportNumberController.text,
              birthDay: birthDay,
              birthMonth: getMonthNumber(birthMonth).toString(),
              birthYear: birthYear,

              passportExpiryDay: passportExpiryDay,
              passportExpiryMonth: getMonthNumber(passportExpiryMonth).toString(),
              passportExpiryYear: passportExpiryYear,
              isseuCountry: country?.name ?? "",

              passportBackPhotoUrl: passportBackUrl,
              passportFrontPhotoUrl: passportFrontUrl,
              passportSizePhotoUrl: passportPhotoUrl,
            ),
          );
        }
      }

      reset();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void setPassportFrontPhoto(String preview, XFile file) {
    state = state.copyWith(
      addPasspoetModel: state.addPasspoetModel?.copyWith(passportFrontPhotoFile: file, passportFrontPhotoUrl: preview),
    );
    "setPassportFrontPhoto ==> ${state.addPasspoetModel?.toJson()}".logD();
  }

  void setPassportbackPhoto(String preview, XFile file) {
    state = state.copyWith(
      addPasspoetModel: state.addPasspoetModel?.copyWith(passportBackPhotoFile: file, passportBackPhotoUrl: preview),
    );
  }

  void setPassportSizePhoto(String preview, XFile file) async {
    // Read bytes and get file size in KB
    int fileSizeBytes = await file.length();
    double fileSizeKB = fileSizeBytes / 1024;
    "File Size $fileSizeKB".logD();
    // Must then 20 KB and Less - 600 KB
    if (fileSizeKB < 20 || fileSizeKB > 600) {
      _passpoerPhotoError = _passpoerPhotoError = "Photo size must be greater than 20 KB and less than 600 KB.";
      state = state.copyWith();
      return;
    }
    // Decode image to check resolution (width/height in pixels)
    final imageBytes = await file.readAsBytes();
    final img = await decodeImageFromList(imageBytes);
    int width = img.width;
    int height = img.height;
    // Minimum: 350x350, Maximum: 1000x1000
    if ((width <= 350 && height <= 350) || (width >= 1000 && height >= 1000)) {
      _passpoerPhotoError = "Photo dimensions must be between 350x350 and 1000x1000 pixels.";
      state = state.copyWith();
      return;
    }

    ResponseAPI? value = await uploadPassportSizePhoto(file: file);
    if (value?.data["statusCode"] == 200) {
      passportPhotoUrl = value?.data["data"]["url"];
      state = state.copyWith(
        addPasspoetModel: state.addPasspoetModel?.copyWith(passportSizePhotoFile: file, passportSizePhotoUrl: passportPhotoUrl),
      );
      _passpoerPhotoError = "";
    } else {
      _passpoerPhotoError = value?.data["message"];
    }
    state = state.copyWith();
  }

  Future<String?> uploadImage({required XFile file}) async {
    String fillName = file.name;
    Uint8List fileProfilePic = await file.readAsBytes();

    ResponseAPI profileUploadRes = await ApiManager.multipartAPI(
      methodName: ApiEndpoints.uploadDocumentImage,
      params: {"image": dio.MultipartFile.fromBytes(fileProfilePic, filename: fillName)},
    );
    if (profileUploadRes.data["statusCode"] == 200) {
      return profileUploadRes.data["data"]["url"];
    } else {
      return null;
    }
  }

  Future<ResponseAPI?> uploadPassportSizePhoto({required XFile file}) async {
    String fillName = file.name;
    Uint8List fileProfilePic = await file.readAsBytes();

    return await ApiManager.multipartAPI(
      methodName: ApiEndpoints.uploadPassportSizePhoto,
      params: {"image": dio.MultipartFile.fromBytes(fileProfilePic, filename: fillName)},
    );
  }

  Country? countryFromName(String name) {
    try {
      return CountryPickerUtils.getCountryByName(name);
    } catch (_) {
      return null;
    }
  }

  void setData(PassportListingModel model) {
    firstNameController.text = model.firstNameController ?? "";
    lastNameController.text = model.lastNameController ?? "";
    passportNumberController.text = model.passportNumberController ?? "";
    birthDay = model.birthDay ?? "";
    birthMonth = monthNameFromNumber(model.birthMonth ?? "").toString();
    birthYear = model.birthYear ?? "";
    passportExpiryDay = model.passportExpiryDay ?? "";
    passportExpiryMonth = monthNameFromNumber(model.passportExpiryMonth ?? "").toString();
    passportExpiryYear = model.passportExpiryYear ?? "";

    passportFrontUrl = model.passportFrontPhoto ?? "";
    passportBackUrl = model.passportBackPhoto ?? "";
    passportPhotoUrl = model.passportSizePhoto ?? "";
    if (model.isseuCountry != null && model.isseuCountry!.isNotEmpty) {
      country = countryFromName(model.isseuCountry!);
    }

    state = state.copyWith(
      addPasspoetModel: state.addPasspoetModel?.copyWith(
        firstNameControlle: model.firstNameController ?? "",
        lastNameController: model.lastNameController ?? "",
        passportNumberController: model.passportNumberController ?? "",
        birthDay: model.birthDay ?? "",
        birthMonth: monthNameFromNumber(model.birthMonth ?? "").toString(),
        birthYear: model.birthYear ?? "",
        passportExpiryDay: model.passportExpiryDay ?? "",
        passportExpiryMonth: monthNameFromNumber(model.passportExpiryMonth ?? "").toString(),
        passportExpiryYear: model.passportExpiryYear ?? "",
        passportFrontPhotoUrl: model.passportFrontPhoto,
        passportBackPhotoUrl: model.passportBackPhoto,
        passportSizePhotoUrl: model.passportSizePhoto,
        isseuCountry: country?.name,
      ),
    );
  }

  void removeFrontPhoto() {
    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(passportFrontPhotoUrl: ""));
  }

  void removeBackPhoto() {
    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(passportBackPhotoUrl: ""));
  }

  void removePassportPhoto() {
    state = state.copyWith(addPasspoetModel: state.addPasspoetModel?.copyWith(passportSizePhotoUrl: ""));
  }

  String? checkValidataion() {
    if (firstNameController.text.trim().isEmpty) {
      return "First name is required.";
    }

    if (lastNameController.text.trim().isEmpty) {
      return "Last name is required.";
    }

    if (passportNumberController.text.trim().isEmpty) {
      return "Passport number is required.";
    }

    if (passportNumberController.text.trim().length < 6) {
      return "Passport number must be at least 6 characters.";
    }

    /// ---------- COUNTRY ----------
    if (country == null) {
      return "Issuing country is required.";
    }

    /// ---------- BIRTH DATE ----------
    if (birthDay.isEmpty || birthMonth.isEmpty || birthYear.isEmpty) {
      return "Complete birth date is required.";
    }

    DateTime? birthDate;
    try {
      birthDate = DateTime(int.parse(birthYear), getMonthNumber(birthMonth), int.parse(birthDay));
    } catch (_) {
      return "Invalid birth date.";
    }

    if (birthDate.isAfter(DateTime.now())) {
      return "Birth date cannot be in the future.";
    }

    /// ---------- EXPIRY DATE ----------
    if (passportExpiryDay.isEmpty || passportExpiryMonth.isEmpty || passportExpiryYear.isEmpty) {
      return "Complete passport expiry date is required.";
    }

    DateTime? expiryDate;
    try {
      expiryDate = DateTime(int.parse(passportExpiryYear), getMonthNumber(passportExpiryMonth), int.parse(passportExpiryDay));
    } catch (_) {
      return "Invalid passport expiry date.";
    }

    if (!expiryDate.isAfter(DateTime.now())) {
      return "Passport expiry date must be in the future.";
    }

    // Check at least passport photo uploaded (front, back, and size photo)
    if ((state.addPasspoetModel?.passportFrontPhotoUrl?.isEmpty ?? true)) {
      state = state.copyWith(error: "Passport front photo is required.");
      return "Passport front photo is required.";
    }
    if ((state.addPasspoetModel?.passportBackPhotoUrl?.isEmpty ?? true)) {
      return "Passport back photo is required.";
    }
    if ((state.addPasspoetModel?.passportSizePhotoUrl?.isEmpty ?? true)) {
      return "Passport size photo is required.";
    }
    return null;
  }

  void reset() {
    firstNameController.clear();
    lastNameController.clear();
    passportNumberController.clear();
    birthDay = "";
    birthMonth = "";
    birthYear = "";
    passportExpiryDay = "";
    passportExpiryMonth = "";
    passportExpiryYear = "";
    country = null;
    _passportFrontUrl = "";
    _passportBackUrl = "";
    _passportPhotoUrl = "";
    _passpoerPhotoError = "";
    state = AddPassportState(
      isLoading: false,
      isSuccess: false,
      error: null,
      addPasspoetModel: AddPasspoetModel(
        firstNameController: "",
        lastNameController: "",
        passportNumberController: "",
        birthDay: "",
        birthMonth: "",
        birthYear: "",
        passportExpiryDay: "",
        passportExpiryMonth: "",
        passportExpiryYear: "",
        isseuCountry: "",
        passportFrontPhotoUrl: "",
        passportBackPhotoUrl: "",
        passportSizePhotoUrl: "",
        passportFrontPhotoFile: null,
        passportBackPhotoFile: null,
        passportSizePhotoFile: null,
      ),
    );
  }
}
