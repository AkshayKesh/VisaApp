import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/features/auth/domain/hive_user_model.dart';
import 'package:register_visa_web_app/features/auth/domain/user.dart';
import 'package:register_visa_web_app/features/auth/providers/login_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController() : super(LoginState()) {
    _autoLogin();
  }

  Future<void> _autoLogin() async {
    //* Check persistent login, if found valid, update state accordingly
    final isLoggedIn = HiveService.isLogin();
    //* If a user exists in Hive, set AppConstants.authToken appropriately for auto-login
    //* (This helps maintain persistent login status)
    final user = HiveService.getUser(AppConstants.authToken);

    //* If the user is marked as logged in and a user exists in persistent storage,
    //* update the state to reflect a loading/success state and ensure the auth token
    //* is set globally for the duration of the session. This supports automatic login.
    if (isLoggedIn && user != null) {
      state = state.copyWith(
        isLoading: true,
        isSuccess: isLoggedIn,
        data: {"user": user, "authToken": user.token},
      );
      AppConstants.authToken = user.token;
    }
  }

  Future<void> emailLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      ResponseAPI response = await ApiManager.post(
        methodName: ApiEndpoints.login,
        params: {"email": email, "password": password},
      );

      if (response.data["statusCode"] == 200) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          data: response.data,
        );

        //* Extract sign up data from the response
        SignupData signupResponse = SignupData(
          authToken: response.data["data"]["authToken"],
          user: User.fromJson(response.data["data"]["user"]),
        );
        //* Store auth token globally
        AppConstants.authToken = signupResponse.authToken!;
        //* Store user ID globally

        //* Add user info to Hive local storage
        HiveService.addUser(
          UserModel(
            id: signupResponse.user!.id!,
            name: signupResponse.user!.fullName!,
            email: signupResponse.user!.email!,
            token: signupResponse.authToken!,
            phoneNumber: signupResponse.user!.phone!,
            profilePic: signupResponse.user!.profilePic ?? "",
          ),
        );
        //* Mark login status as true in Hive storage

        HiveService.setLogin(true);
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> checkUserOrRegister({required String email}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      ResponseAPI response = await ApiManager.post(
        methodName: ApiEndpoints.checkUserOrRegister,
        params: {"email": email},
      );
      if (response.data["statusCode"] == 201) {
        state = state.copyWith(
          isLoading: false,
          requiresLoginPassword: true,
          infoMessage: response.data["message"],
        );
      } else if (response.data["statusCode"] == 202) {
        state = state.copyWith(
          isLoading: false,
          isPasswordNotSet: true,
          infoMessage: response.data["message"],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> googleLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 🔹 Fake API delay
      await Future.delayed(const Duration(seconds: 3));
      // 🔹 Dummy validation
      if (email == "admin@gmail.com" && password == "Admin@123") {
        state = state.copyWith(isLoading: false, isSuccess: true);
      } else {
        throw Exception("Invalid email or password");
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = LoginState(isLoading: false, isSuccess: false, error: null);
  }

  void reset() {
    state = LoginState();
  }

  void updatePassword({required String email})async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      ResponseAPI response = await ApiManager.post(
        methodName: ApiEndpoints.changePassword,
        params: {"email": email},
      );
      if (response.data["statusCode"] == 201) {
        state = state.copyWith(
          isLoading: false,
          requiresLoginPassword: true,
          infoMessage: response.data["message"],
        );
      } else if (response.data["statusCode"] == 202) {
        state = state.copyWith(
          isLoading: false,
          isPasswordNotSet: true,
          infoMessage: response.data["message"],
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
