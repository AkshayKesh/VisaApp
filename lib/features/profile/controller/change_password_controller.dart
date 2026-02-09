import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/features/profile/domain/change_password_model.dart';
import 'package:register_visa_web_app/features/profile/providers/states/change_password_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  ChangePasswordController() : super(ChangePasswordState());

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(status: ChangePasswordStatus.loading, message: null);

    try {
      ResponseAPI responseAPI = await ApiManager.put(
        methodName: ApiEndpoints.changePassword,
        params: {"oldPassword": oldPassword, "newPassword": newPassword},
      );
      ChangePasswordModel changePasswordModel = ChangePasswordModel.fromJson(
        responseAPI.data,
      );
      AppConstants.authToken = changePasswordModel.data.authToken;
      state = state.copyWith(
        status: ChangePasswordStatus.success,
        message: changePasswordModel.message,
      );
    } catch (e) {
      print(e);
    }
  }

  void reset() {
    state = ChangePasswordState();
  }
}
