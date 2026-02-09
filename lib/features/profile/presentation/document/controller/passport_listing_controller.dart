import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/domain/passport_listing_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/state/documnet_listing_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';

class PassportListingController extends AsyncNotifier<DocumentListingState> {
  @override
  FutureOr<DocumentListingState> build() {
    return fetchAllPassport();
  }

  Future<DocumentListingState> fetchAllPassport() async {
    // Set the loading state to true before beginning API call
    state = AsyncLoading();
    // Assuming you have an ApiManage class/service available for making API calls
    try {
      // Set loading state if required, e.g., state = const AsyncLoading();
      ResponseAPI response = await ApiManager.get(
        methodName: ApiEndpoints.getAllPassport,
      ); // Example static method, adjust to your actual API method

      // Check if response is successful and parse data
      if (response.data["statusCode"] == 200) {
        List<PassportListingModel> passports = [];
        passports = (response.data['data'] as List)
            .map((json) => PassportListingModel.fromJson(json))
            .toList();

        return DocumentListingState(
          passportList: passports,
          isLoading: false,
          isSuccess: true,
          error: null,
        );
      } else {
        return DocumentListingState(
          passportList: [],
          isLoading: false,
          isSuccess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      return DocumentListingState(
        passportList: [],
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }
}
