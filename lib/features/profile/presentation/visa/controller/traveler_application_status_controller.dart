import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/travel_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/traveler_app_status_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/state/traveler_app_status.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';

class TravelerAppStatusController extends StateNotifier<TravelerAppStatus> {
  TravelerAppStatusController(TravelerIdParam param) : super(TravelerAppStatus(isLoading: true)) {
    getApplicationStatusByTraveller(applicationId: param.applicationId, travelerId: param.travellerId);
  }

  Future<void> getApplicationStatusByTraveller({required String travelerId, required String applicationId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await ApiManager.post(
        methodName: ApiEndpoints.getApplicationStatusByTraveller,
        params: {"applicationId": applicationId, "travellerId": travelerId},
      );

      if (response.data["statusCode"] == 200) {
        //final model = TravelerAppStatusModel.fromJson(response.data["data"]);
        final List<TravelerAppStatusModel> modelList = (response.data["data"] as List<dynamic>)
            .map((item) => TravelerAppStatusModel.fromJson(item))
            .toList();
        state = state.copyWith(isLoading: false, sucess: true, data: modelList);

        ///state = state.copyWith(isLoading: false, sucess: true, data: model);
      } else {
        state = state.copyWith(isLoading: false, sucess: false, error: response.data["message"]);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, sucess: false, error: e.toString());
    }
  }
}
