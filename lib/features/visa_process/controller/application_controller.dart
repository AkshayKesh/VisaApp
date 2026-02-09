import 'dart:typed_data';

import 'package:country_pickers/country.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';

import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';

class VisaApplicationController extends StateNotifier<VisaApplicationState> {
  VisaApplicationController(MyPassportModel model)
    : super(
        VisaApplicationState(
          travellers: List<Traveller>.generate(
            model.count,
            (index) => Traveller(
              id: '${index + 1}',
              dateOfIssue: '',
              firstNameController: TextEditingController(),
              lastNameController: TextEditingController(),
              passportNumberController: TextEditingController(),
              issuedCountryController: TextEditingController(),
              emailController: TextEditingController(
                text: HiveService.getEmail() ?? '',
              ),
              passportExpiryDate: '',
              isseuCountry: "USA",
              country: model.country,
            ),
          ),
          currentTravellerIndex: 0,
        ),
      );

  Map<String, dynamic> _data = {};

  List<String> travelerId = [];

  Map<String, dynamic> get data => _data;
  set setData(Map<String, dynamic>? value) {
    if (value != null) {
      _data = value;
    }
  }

  String? _passportPhotoError = "";
  String? get passportPhotoError => _passportPhotoError;

  set passportPhotoError(String? value) {
    _passportPhotoError = value;
  }

  String? _cardId = "";

  String? get cardId => _cardId;
  set cardId(String? value) {
    _cardId = value;
  }

  String? _processId;

  String? get processId => _processId;
  set processId(String? value) {
    _processId = value;
  }

  String? submitError = "";

  String? _applicationId;
  String? get applicationId => _applicationId;
  set applicationId(String? value) {
    _applicationId = value;
  }

  void addTraveller() {
    final newTraveller = Traveller(
      dateOfIssue: '',
      id: (state.travellers.length + 1).toString(),
      firstNameController: TextEditingController(),
      lastNameController: TextEditingController(),
      passportNumberController: TextEditingController(),
      issuedCountryController: TextEditingController(),
      passportExpiryDate: '',
    );

    state = state.copyWith(
      travellers: [...state.travellers, newTraveller],
      currentTravellerIndex: state.travellers.length,
    );
  }

  void changeTraveller(int index) {
    state = state.copyWith(currentTravellerIndex: index);
  }

  void updatePassportExpiryDate(String id, DateTime date) {
    final updatedTravellers = state.travellers.map((traveller) {
      if (traveller.id == id) {
        return traveller.copyWith(
          passportExpiryDate: Utils.dateFormat(date.toString()),
        );
      }
      return traveller;
    }).toList();

    state = state.copyWith(travellers: updatedTravellers);
  }

  void updateDateOfIssued(String id, DateTime date) {
    final updatedTravellers = state.travellers.map((traveller) {
      if (traveller.id == id) {
        return traveller.copyWith(
          dateOfIssue: Utils.dateFormat(date.toString()),
        );
      }
      return traveller;
    }).toList();

    state = state.copyWith(travellers: updatedTravellers);
  }

  void setPassportFrontPhoto(String id, String preview, XFile file) async {
    state = state.copyWith(frontPhotoUrlLoading: true);
    final url = await uploadImage(file: file);
    final updatedTravellers = state.travellers.map((traveller) {
      if (traveller.id == id) {
        return traveller.copyWith(
          passportFrontPhotoUrl: url,
          passportFrontPhotoFile: file,
        );
      }
      return traveller;
    }).toList();

    state = state.copyWith(
      travellers: updatedTravellers,
      frontPhotoUrlLoading: false,
    );
  }

  void setPassportbackPhoto(String id, String preview, XFile file) async {
    state = state.copyWith(backPhotoUrlLoading: true);
    final url = await uploadImage(file: file);
    final updatedTravellers = state.travellers.map((traveller) {
      if (traveller.id == id) {
        return traveller.copyWith(
          passportBackPhotoUrl: url,
          passportBackPhotoFile: file,
        );
      }
      return traveller;
    }).toList();

    state = state.copyWith(
      travellers: updatedTravellers,
      backPhotoUrlLoading: false,
    );
  }

  void setPassportSizePhoto(String preview, XFile file, String id) async {
    // Read bytes and get file size in KB
    int fileSizeBytes = await file.length();
    double fileSizeKB = fileSizeBytes / 1024;
    "File Size $fileSizeKB".logD();
    // Must then 20 KB and Less - 600 KB
    if (fileSizeKB < 20 || fileSizeKB > 600) {
      _passportPhotoError = _passportPhotoError =
          "Photo size must be greater than 20 KB and less than 600 KB.";
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
      _passportPhotoError =
          "Photo dimensions must be between 350x350 and 1000x1000 pixels.";
      state = state.copyWith();
      return;
    }
    state = state.copyWith(passportPhotoLoading: true);
    ResponseAPI? value = await uploadPassportSizePhoto(file: file);
    if (value?.data["statusCode"] == 200) {
      final url = value?.data["data"]["url"];

      final updatedTravellers = state.travellers.map((traveller) {
        if (traveller.id == id) {
          return traveller.copyWith(
            passportPhotoUrl: url,
            passportBackPhotoFile: file,
          );
        }
        return traveller;
      }).toList();
      state = state.copyWith(
        travellers: updatedTravellers,
        passportPhotoLoading: false,
      );
      _passportPhotoError = "";
    } else {
      _passportPhotoError = value?.data["message"];
    }
    state = state.copyWith();
  }

  String? checkTravelerDetails() {
    final travelerList = state.travellers;
    // Validate each traveller

    for (var traveller in travelerList) {
      // Check text controllers
      final firstName = traveller.firstNameController.text.trim();
      final lastName = traveller.lastNameController.text.trim();
      final passportNumber = traveller.passportNumberController.text.trim();

      if (firstName.isEmpty) {
        return "First name is required for a traveller.";
      }

      if (passportNumber.isEmpty) {
        return "Passport number is required for a traveller.";
      }

      // Passport expiry date
      if (traveller.passportExpiryDate.toString().isEmpty) {
        return "Passport expiry date is required for a traveller.";
      }
      // Passport Front Photo URL
      if (traveller.passportFrontPhotoUrl == null ||
          traveller.passportFrontPhotoUrl!.isEmpty) {
        return "Passport front photo is required for a traveller.";
      }
      // Passport Back Photo URL
      if (traveller.passportBackPhotoUrl == null ||
          traveller.passportBackPhotoUrl!.isEmpty) {
        return "Passport back photo is required for a traveller.";
      }
      // Passport Size Photo URL
      if (traveller.passportPhotoUrl == null ||
          traveller.passportPhotoUrl!.isEmpty) {
        return "Passport size photo is required for a traveller.";
      }
    }

    return null;
  }

  Future<void> saveTraveler(List<Traveller> travelers) async {
    // Prepare travelers data into a list of maps for the API
    state = state.copyWith(isSubmit: true);

    try {
      final travelersData = travelers
          .map(
            (traveller) => {
              "firstName": traveller.firstNameController.text.trim(),
              "lastName": traveller.lastNameController.text.trim(),
              "passportNumber": traveller.passportNumberController.text.trim(),
              "issuingCountry": traveller.country?.name,
              "birthDay": int.parse(traveller.birthDay!),
              "birthMonth": getMonthNumber(traveller.birthMonth!.toString()),
              "birthYear": int.parse(traveller.birthYear!),
              "expiryDay": int.parse(traveller.passportExpiryDay!),
              "expiryMonth": getMonthNumber(
                traveller.passportExpiryMonth!.toString(),
              ),
              "expiryYear": int.parse(traveller.passportExpiryYear!),
              if (traveller.id == "1")
                "email": traveller.emailController!.text.trim(),
            },
          )
          .toList();

      final response = await ApiManager.post(
        methodName: ApiEndpoints.addBulkPassport,
        params: {"passports": travelersData},
      );

      if (response.data["statusCode"] == 200) {
        travelerId.addAll(
          (response.data['data'] as List)
              .map((e) => e['_id'] as String)
              .toList(),
        );
        await submitApplication(travelerId);
      } else {
        state = state.copyWith(
          isSuccess: false,
          isSubmit: false,
          error: response.data["message"],
        );
        submitError = response.data["message"];
      }
    } catch (e) {
      submitError = e.toString();
      state = state.copyWith(
        isSuccess: false,
        isSubmit: false,
        error: e.toString(),
      );
    }
  }

  Future<void> submitApplication(List<String> travelerIds) async {
    // Prepare travelers data into a list of maps for the API

    try {
      Map<String, dynamic> mapData = {
        "packageId": VisaHiveService.instance.getVisaById(),
        "selectedVisaOption": {
          "visaType": VisaHiveService.instance.getVisaType(),
          "lengthOfStay": VisaHiveService.instance.getLengthOfStay(),
          "visaValidity": VisaHiveService.instance.getVisaValidity(),
          "visaFee": VisaHiveService.instance.getVisaFee(),
          "entryType": VisaHiveService.instance.getEntryType(),
        },
        "noOfTraveller": travelerIds.length.toString(),
        "travellerId": travelerIds.toList(),
      };

      // Build the bulk data request body

      final response = await ApiManager.post(
        methodName: ApiEndpoints.submitApplication,
        params: mapData,
      );

      if (response.data["statusCode"] == 200) {
        applicationId = response.data["data"]["_id"];
        state = state.copyWith(isSuccess: true, isSubmit: false);
      } else {
        state = state.copyWith(
          isSuccess: false,
          isSubmit: false,
          error: response.data["message"],
        );
        submitError = response.data["message"];
      }
    } catch (e) {
      submitError = e.toString();
      state = state.copyWith(
        isSuccess: false,
        isSubmit: false,
        error: e.toString(),
      );
    }
  }

  void removePhoto(String type, String travelerIndex) {
    List<Traveller> updatedTravellers = [];
    if (type == "back") {
      updatedTravellers = state.travellers.map((traveller) {
        if (traveller.id == travelerIndex) {
          return traveller.copyWith(
            passportBackPhotoUrl: "",
            passportBackPhotoFile: null,
          );
        }
        return traveller;
      }).toList();
    } else if (type == "front") {
      updatedTravellers = state.travellers.map((traveller) {
        if (traveller.id == travelerIndex) {
          return traveller.copyWith(
            passportFrontPhotoUrl: "",
            passportFrontPhotoFile: null,
          );
        }
        return traveller;
      }).toList();
      state = state.copyWith(travellers: updatedTravellers);
    } else if (type == "photo") {
      updatedTravellers = state.travellers.map((traveller) {
        if (traveller.id == travelerIndex) {
          return traveller.copyWith(
            passportPhotoUrl: "",
            passportSizePhotoFile: null,
          );
        }
        return traveller;
      }).toList();
    }
    state = state.copyWith(travellers: updatedTravellers);
  }

  void upatdeCard(String id) {
    cardId = id;
    state = state.copyWith();
  }

  Future<void> makePayment() async {
    state = state.copyWith(isMakePaymentLoading: true);

    try {
      Map<String, dynamic> mapData = {
        "applicationId": applicationId,
        "cardId": cardId,
        "processingFeeId": processId,
      };
      await Future.delayed(Duration(seconds: 2));
      final response = await ApiManager.post(
        methodName: ApiEndpoints.makePayment,
        params: mapData,
      );

      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isMakePaymentLoading: false,
          isMakePaymentSuccess: true,
          successPaymentMessage: response.data["message"],
        );
      } else {
        state = state.copyWith(
          isMakePaymentLoading: false,
          isMakePaymentSuccess: false,
          makePaymentError: response.data["message"],
        );
      }
    } catch (e) {
      submitError = e.toString();
      state = state.copyWith(
        isMakePaymentLoading: false,
        isMakePaymentSuccess: false,
        makePaymentError: e.toString(),
      );
    }
  }

  void removeTraveler(String id) {
    // Removes the specified traveller from the list and update state

    final updatedTravellers = List<Traveller>.from(state.travellers)
      ..removeWhere((t) => t.id == id);
    state = state.copyWith(travellers: updatedTravellers);
  }

  void clearState() {
    state = state.copyWith(
      isMakePaymentLoading: false,
      isMakePaymentSuccess: false,
      makePaymentError: null,
      travellers: [],
    );
    cardId = null;
    processId = null;
    applicationId = null;
    submitError = '';
  }

  void changeMonth(String? value, int index) {
    if (value == null) return;
    // Updates the traveler's birthMonth at the specified index
    final updatedTravellers = List<Traveller>.from(state.travellers);
    if (index >= 0 && index < updatedTravellers.length) {
      final updatedTraveller = updatedTravellers[index].copyWith(
        birthMonth: value,
      );
      updatedTravellers[index] = updatedTraveller;
      state = state.copyWith(travellers: updatedTravellers);
    }
  }

  void changeDay(String? value, int index) {
    if (value == null) return;
    // Updates the traveler's birthDay at the specified index
    final updatedTravellers = List<Traveller>.from(state.travellers);
    if (index >= 0 && index < updatedTravellers.length) {
      final updatedTraveller = updatedTravellers[index].copyWith(
        birthDay: value,
      );
      updatedTravellers[index] = updatedTraveller;
      state = state.copyWith(travellers: updatedTravellers);
    }
  }

  void changeYear(String? value, int index) {
    if (value == null) return;
    // Updates the traveler's birthYear at the specified index
    final updatedTravellers = List<Traveller>.from(state.travellers);
    if (index >= 0 && index < updatedTravellers.length) {
      final updatedTraveller = updatedTravellers[index].copyWith(
        birthYear: value,
      );
      updatedTravellers[index] = updatedTraveller;
      state = state.copyWith(travellers: updatedTravellers);
    }
  }

  void updateExpireDay(String? value, int index) {
    if (value == null) return;

    // Updates the traveler's passportExpiryDate at the specified index
    final updatedTravellers = List<Traveller>.from(state.travellers);
    if (index >= 0 && index < updatedTravellers.length) {
      final updatedTraveller = updatedTravellers[index].copyWith(
        passportExpiryDay: value,
      );
      print("VALEU $value  ${updatedTraveller.toJson()}");
      updatedTravellers[index] = updatedTraveller;
      state = state.copyWith(travellers: updatedTravellers);
    }
  }

  void updateExpireMonth(String? value, int index) {
    if (value == null) return;
    final updatedTravellers = List<Traveller>.from(state.travellers);
    if (index >= 0 && index < updatedTravellers.length) {
      final updatedTraveller = updatedTravellers[index].copyWith(
        passportExpiryMonth: value,
      );
      updatedTravellers[index] = updatedTraveller;
      state = state.copyWith(travellers: updatedTravellers);
    }
  }

  void updateExpireYear(String? value, int index) {
    if (value == null) return;
    final updatedTravellers = List<Traveller>.from(state.travellers);
    if (index >= 0 && index < updatedTravellers.length) {
      final updatedTraveller = updatedTravellers[index].copyWith(
        passportExpiryYear: value,
      );
      updatedTravellers[index] = updatedTraveller;
      state = state.copyWith(travellers: updatedTravellers);
    }
  }

  // This method validates traveler info: firstName, lastName, birthDay, birthMonth, birthYear.
  // For the first traveler, email must be present and valid; others ignore email.
  // Returns true if valid; otherwise shows a proper error message and returns false.

  bool isValidEmail(String email) {
    // Simple email validation regex
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  String? checkTravelerBasicInfo() {
    final travellers = state.travellers;
    if (travellers.isEmpty) {
      return "Please add at least one traveler.";
    }
    for (int i = 0; i < travellers.length; i++) {
      final traveller = travellers[i];
      if (traveller.firstNameController.text.trim().isEmpty) {
        return "Please enter first  name for traveler #${i + 1}";
      }
      if (traveller.lastNameController.text.trim().isEmpty) {
        return "Please enter last name for traveler #${i + 1}";
      }
      if (traveller.birthMonth == null ||
          traveller.birthMonth!.trim().isEmpty) {
        return "Please select birth month for traveler #${i + 1}";
      }
      if (traveller.birthDay == null || traveller.birthDay!.trim().isEmpty) {
        return "Please select birth day for traveler #${i + 1}";
      }

      if (traveller.birthYear == null || traveller.birthYear!.trim().isEmpty) {
        return "Please select birth year for traveler #${i + 1}";
      }
      // For first traveler, validate email presence and format
      if (i == 0) {
        final email = traveller.emailController != null
            ? traveller.emailController!.text.trim()
            : "";
        if (email.isEmpty) {
          return "Please enter traveler #1's email address.";
        }
        if (!isValidEmail(email)) {
          return "Please enter a valid email address for traveler #1.";
        }
      }
    }
    return null;
  }

  void updateMyPassportCountry(Country value, index) {
    // Update the 'isseuCountry' of the traveler at [index] with the selected country's name.
    final updatedTravellers = List<Traveller>.from(state.travellers);
    final currentTraveller = updatedTravellers[index];

    updatedTravellers[index] = currentTraveller.copyWith(
      isseuCountry: value.name,
      country: value,
    );

    state = state.copyWith(travellers: updatedTravellers);
  }

  String? checkPassportDetails() {
    final travellers = state.travellers;
    for (int i = 0; i < travellers.length; i++) {
      final traveller = travellers[i];

      // Check issuing country
      if (traveller.isseuCountry == null ||
          traveller.isseuCountry!.trim().isEmpty) {
        return "Please select the Issue Country for traveler #${i + 1}";
      }

      // Check passport number
      if (traveller.passportNumberController.text.trim().isEmpty) {
        return "Please enter the Passport Number for traveler #${i + 1}";
      }
      // Check passport expiry month
      if (traveller.passportExpiryMonth == null ||
          traveller.passportExpiryMonth!.trim().isEmpty) {
        return "Please select the passport Expiry Month for traveler #${i + 1}";
      }
      // Check passport expiry day
      if (traveller.passportExpiryDay == null ||
          traveller.passportExpiryDay!.trim().isEmpty) {
        return "Please select the passport Expiry Day for traveler #${i + 1}";
      }

      // Check passport expiry year
      if (traveller.passportExpiryYear == null ||
          traveller.passportExpiryYear!.trim().isEmpty) {
        return "Please select the passport Expiry Year for traveler #${i + 1}";
      }
      // Check if Country is null
      if (traveller.country == null) {
        return "Please select the Country for traveler #${i + 1}";
      }
    }
    return null;
  }
}

Future<String?> uploadImage({required XFile file}) async {
  String fillName = file.name;
  Uint8List fileProfilePic = await file.readAsBytes();

  ResponseAPI profileUploadRes = await ApiManager.multipartAPI(
    methodName: ApiEndpoints.uploadDocumentImage,
    params: {
      "image": dio.MultipartFile.fromBytes(fileProfilePic, filename: fillName),
    },
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
    params: {
      "image": dio.MultipartFile.fromBytes(fileProfilePic, filename: fillName),
    },
  );
}
