import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/core/utils/utils.dart';
import 'package:register_visa_web_app/features/evisa_application/controller/evisa_application_controller.dart';
import 'package:register_visa_web_app/features/evisa_application/providers/evisa_application_state.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/application_details_travelers_model.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';

final evisaApplicationProvider =
    NotifierProvider<EvisaApplicationController, EvisaApplicationState>(
      EvisaApplicationController.new,
    );

final applicationDetailsByIdProvider =
    FutureProvider.family<ApplicationDetailsTravelers?, String>((
      ref,
      applicationId,
    ) async {
      if (applicationId.isEmpty) return null;
      try {
        final response = await ApiManager.get(
          methodName: '${ApiEndpoints.getApplicationById}/$applicationId',
        );
        if (response.data["statusCode"] == 200 &&
            response.data["data"] != null) {
          return ApplicationDetailsTravelers.fromJson(
            response.data["data"] as Map<String, dynamic>,
          );
        }
      } catch (_) {}
      return null;
    });

class AirportItem {
  final String id;
  final String name;
  const AirportItem({required this.id, required this.name});
}

List<AirportItem> _parseAirportItems(dynamic raw) {
  if (raw == null) return [];
  if (raw is List && raw.isNotEmpty) {
    if (raw.first is String) return [];
    return raw
        .map((e) {
          if (e is! Map) return null;
          final id = (e["_id"] ?? e["id"] ?? "").toString();
          final name =
              (e["name"] ??
                      e["airportName"] ??
                      e["airport"] ??
                      e["title"] ??
                      "")
                  .toString();
          return id.isNotEmpty && name.isNotEmpty
              ? AirportItem(id: id, name: name)
              : null;
        })
        .whereType<AirportItem>()
        .toList();
  }
  if (raw is Map && raw["list"] is List) return _parseAirportItems(raw["list"]);
  return [];
}

final airportListProvider = FutureProvider<List<AirportItem>>((ref) async {
  try {
    final response = await ApiManager.post(
      methodName: ApiEndpoints.airportList,
      params: {"page": 1, "limit": 100},
    );
    final data = response.data as Map<String, dynamic>?;
    if (data == null) return [];
    final raw = data["data"] ?? data["list"] ?? data;
    final list = _parseAirportItems(raw);
    if (list.isNotEmpty) return list;
  } catch (_) {}
  return [];
});

/// Returns null on success, error message on failure.
Future<String?> createTripDetailsApi(
  String applicationId,
  EvisaApplicationState state,
) async {
  try {
    final countryBefore = state.countryBefore ?? [];
    final response = await ApiManager.post(
      methodName: ApiEndpoints.createTripDetails,
      params: {
        "applicationId": applicationId,
        "phoneNumber": state.phoneNumber ?? "",
        "updatesOn": state.updatesOn ?? "SMS",
        "religion": state.religion ?? "",
        "arrivalDate": state.arrivalDate ?? "",
        "arrivalPoint": state.arrivalPoint ?? "",
        "countryBefore": countryBefore,
      },
    );
    final data = response.data as Map<String, dynamic>?;
    if (data == null) return "Something went wrong";
    if (data["statusCode"] == 200) return null;
    return Utils.getErrorMessage(data);
  } catch (e) {
    return e.toString();
  }
}

final createTripDetailsLoadingProvider = StateProvider<bool>((ref) => false);

/// Returns null on success, error message on failure.
Future<String?> createPersonDetailsApi(
  String applicationId,
  String travelerId,
  EvisaApplicationState state,
) async {
  try {
    final p = state.personDetails;
    if (p == null) return "Please complete all sections";
    final params = <String, dynamic>{
      "applicationId": applicationId,
      "travelerId": travelerId,
      "parentsFromPakistan": p.parentsFromPakistan ?? false,
      "gender": p.gender ?? "",
      "countryBirth": p.countryBirth ?? "",
      "anotherNationality": p.anotherNationality ?? false,
      "maritalStatus": p.maritalStatus ?? "",
      "residenceCountry": p.residenceCountry ?? "",
      "homeAddress": p.homeAddress ?? "",
      "homeCity": p.homeCity ?? "",
      "homeState": p.homeState ?? "",
      "homeZip": p.homeZip ?? "",
      "employmentStatus": p.employmentStatus ?? "",
      "employeeName": p.employeeName ?? "",
      "employeeAddress": p.employeeAddress ?? "",
      "universityName": p.universityName ?? "",
      "universityAddress": p.universityAddress ?? "",
      "city": p.city ?? "",
      "state": p.state ?? "",
      "zipCode": p.zipCode ?? "",
      "policeOrMilitary": p.policeOrMilitary ?? false,
      "fatherFullName": p.fatherFullName ?? "",
      "fatherNationality": p.fatherNationality ?? "",
      "fatherCountryBirth": p.fatherCountryBirth ?? "",
      "motherFullName": p.motherFullName ?? "",
      "motherNationality": p.motherNationality ?? "",
      "motherCountryBirth": p.motherCountryBirth ?? "",
      "lastSixDayVisitOtherCountry": p.lastSixDayVisitOtherCountry ?? false,
    };
    final response = await ApiManager.post(
      methodName: ApiEndpoints.createPersonDetails,
      params: params,
    );
    final data = response.data as Map<String, dynamic>?;
    if (data == null) return "Something went wrong";
    if (data["statusCode"] == 200) return null;
    return Utils.getErrorMessage(data);
  } catch (e) {
    return e.toString();
  }
}

final createPersonDetailsLoadingProvider = StateProvider<bool>((ref) => false);

/// Returns error message for one applicant or null if valid.
String? validatePassportForApplicant(
  int applicantIndex,
  EvisaApplicationState state,
) {
  final photoUrl = state.applicantPhotoUrlByIndex.length > applicantIndex
      ? state.applicantPhotoUrlByIndex[applicantIndex]
      : null;
  final bio = state.passportBioByIndex.length > applicantIndex
      ? state.passportBioByIndex[applicantIndex]
      : null;
  if (photoUrl == null || photoUrl.isEmpty)
    return 'Applicant photo is required';
  if (bio == null) return 'Passport details are required';
  if ((bio.frontImageUrl ?? '').trim().isEmpty)
    return 'Passport front photo is required';
  if ((bio.backImageUrl ?? '').trim().isEmpty)
    return 'Passport back photo is required';
  if ((bio.firstName ?? '').trim().isEmpty) return 'First name is required';
  if ((bio.lastName ?? '').trim().isEmpty) return 'Last name is required';
  if ((bio.number ?? '').trim().isEmpty) return 'Passport number is required';
  if ((bio.issueCountry ?? '').trim().isEmpty)
    return 'Issuing country is required';
  if ((bio.expiryDay ?? '').trim().isEmpty ||
      (bio.expiryMonth ?? '').trim().isEmpty ||
      (bio.expiryYear ?? '').trim().isEmpty)
    return 'Date of expiry is required';
  return null;
}

/// Returns null on success, error message on failure.
Future<String?> updatePassportApi(
  String passportId,
  int applicantIndex,
  EvisaApplicationState state,
) async {
  try {
    final err = validatePassportForApplicant(applicantIndex, state);
    if (err != null) return err;
    final photoUrl = state.applicantPhotoUrlByIndex[applicantIndex]!;
    final bio = state.passportBioByIndex[applicantIndex]!;
    final expiryDayNum = int.tryParse((bio.expiryDay ?? '').trim());
    final expiryMonthStr = (bio.expiryMonth ?? '').trim();
    int? expiryMonthNum;
    if (expiryMonthStr.isNotEmpty) {
      final parsed = int.tryParse(expiryMonthStr);
      expiryMonthNum = (parsed != null && parsed >= 1 && parsed <= 12)
          ? parsed
          : getMonthNumber(expiryMonthStr);
    }
    final expiryYearNum = int.tryParse((bio.expiryYear ?? '').trim());
    if (expiryDayNum == null || expiryMonthNum == null || expiryYearNum == null)
      return 'Invalid expiry date';
    final params = <String, dynamic>{
      'passportFrontPhoto': (bio.frontImageUrl ?? '').trim(),
      'passportBackPhoto': (bio.backImageUrl ?? '').trim(),
      'passportSizePhoto': (photoUrl).trim(),
      'firstName': (bio.firstName ?? '').trim(),
      'lastName': (bio.lastName ?? '').trim(),
      'passportNumber': (bio.number ?? '').trim(),
      'issuingCountry': (bio.issueCountry ?? '').trim(),
      'expiryDay': expiryDayNum,
      'expiryMonth': expiryMonthNum,
      'expiryYear': expiryYearNum,
    };
    final response = await ApiManager.put(
      methodName: ApiEndpoints.updatePassportById(passportId),
      params: params,
    );
    final data = response.data as Map<String, dynamic>?;
    if (data == null) return 'Something went wrong';
    if (data['statusCode'] == 200) return null;
    return data['message']?.toString() ?? 'Something went wrong';
  } catch (e) {
    return e.toString();
  }
}

final updatePassportLoadingProvider = StateProvider<bool>((ref) => false);
