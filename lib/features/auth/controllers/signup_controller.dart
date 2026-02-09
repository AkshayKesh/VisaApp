import 'dart:typed_data' show Uint8List;

import 'package:dio/dio.dart' as dio;
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/constants/app_constant.dart';
import 'package:register_visa_web_app/features/auth/domain/hive_user_model.dart';
import 'package:register_visa_web_app/features/auth/domain/user.dart';
import 'package:register_visa_web_app/features/auth/providers/signup_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';

class SignupController extends StateNotifier<SignupState> {
  SignupController() : super(SignupState());

   Future<void> chckLogin() async {
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

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String url,
    XFile? profilePic,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      String profilePicUrl = "";
      if (profilePic != null) {
        String fillName = profilePic.name;
        Uint8List fileProfilePic = await profilePic.readAsBytes();

        ResponseAPI profileUploadRes = await ApiManager.multipartAPI(
          methodName: ApiEndpoints.uploadProfilePic,
          params: {
            "image": dio.MultipartFile.fromBytes(
              fileProfilePic,
              filename: fillName,
            ),
          },
        );
        if (profileUploadRes.data["statusCode"] == 200) {
          profilePicUrl = profileUploadRes.data["data"]["url"];
        }
      }

      // Prepare the request data
      final Map<String, dynamic> signupData = {
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "password": password,
        "profilePic": profilePicUrl,
      };

      ResponseAPI response = await ApiManager.post(
        methodName:
            ApiEndpoints.signup, // You'll need to add this to ApiEndpoints
        params: signupData,
      );

      if (response.data["statusCode"] == 200) {
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
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          data: response.data,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          error: response.error?.message ?? 'Signup failed',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateProfileImage(String? image, XFile file) {
    state = state.copyWith(profileImage: image, file: file);
  }

  void reset() {
    state = SignupState();
  }
}
