import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/application_details_travelers_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/state/application_travelers_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';

class ApplicationDetasilController
    extends StateNotifier<ApplicationDetailsTravelersStatus> {
  final String id;

  ApplicationDetasilController(this.id)
    : super(ApplicationDetailsTravelersStatus()) {
    getApplicationById(id);
  }

  // List<VisaApplicationStatus> _mapList = [];

  // List<VisaApplicationStatus> get applicationStatusList => _mapList;

  // set applicationStatusList(List<VisaApplicationStatus> newList) {
  //   _mapList = newList;
  //   state = state.copyWith(); // Trigger state update if needed
  // }

  // int _currentTab = 0;

  // int get currentTab => _currentTab;

  // set currentTab(int value) {
  //   if (_currentTab != value) {
  //     _currentTab = value;
  //     state = state.copyWith(); // Trigger state update if needed
  //   }
  // }

  Future<void> getApplicationById(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiManager.get(
        methodName: "${ApiEndpoints.getApplicationById}/$id",
      );
      if (response.data["statusCode"] == 200) {
        final model = ApplicationDetailsTravelers.fromJson(
          response.data["data"],
        );
        state = state.copyWith(isLoading: false, sucess: true, data: model);
      } else {
        state = state.copyWith(
          isLoading: false,
          sucess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      e.toString().logE();
      state = state.copyWith(
        isLoading: false,
        sucess: false,
        error: e.toString(),
      );
    }
  }

  Future<void> getApplicationStatusByTraveller(
    String travelerId,
    String applicationId,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiManager.post(
        methodName: ApiEndpoints.getApplicationStatusByTraveller,
        params: {"applicationId": applicationId, "travellerId": travelerId},
      );

      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isLoading: false,
          sucess: true,
          data: response.data["data"],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          sucess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        sucess: false,
        error: e.toString(),
      );
    }
  }
}
