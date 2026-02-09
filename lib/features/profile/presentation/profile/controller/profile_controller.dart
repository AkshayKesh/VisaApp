import 'dart:typed_data' show Uint8List;

import 'package:dio/dio.dart' as dio;

import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/features/auth/domain/user.dart';
import 'package:register_visa_web_app/features/profile/presentation/profile/state/profile_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/response_model.dart';
import 'package:register_visa_web_app/shared/services/storage_services.dart';

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController() : super(ProfileState()) {
    state = ProfileState(
      data: User(
        phone: HiveService.getPhoneNumber() ?? "",
        fullName: HiveService.getUserName() ?? "",
        email: HiveService.getEmail() ?? "",
        profilePic: HiveService.getProfile() ?? "",
      ),
      profileImage: HiveService.getProfile(),
      error: "",
      isLoading: false,
      success: false,
    );
  }

  // ProfileController() : super(ProfileState()) {
  //   state = state.copyWith(
  //     data: User(
  //       phone: HiveService.getPhoneNumber() ?? "",
  //       fullName: HiveService.getUserName() ?? "",
  //       email: HiveService.getEmail() ?? "",
  //       profilePic: HiveService.getProfile() ?? "",
  //     ),
  //     profileImage: HiveService.getProfile(),
  //   );
  // }

  Future<void> updateUser(User model) async {
    try {
      state = state.copyWith(isLoading: true);
      String profilePicUrl = state.profileImage ?? "";
      if (state.file != null) {
        String fillName = state.file!.name;
        Uint8List fileProfilePic = await state.file!.readAsBytes();

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

      Map<String, dynamic> map = {
        "fullName": model.fullName,
        "phone": model.phone,
        "profilePic": profilePicUrl,
      };
      ResponseAPI response = await ApiManager.put(
        methodName: ApiEndpoints.updateUser,
        params: map,
      );
      if (response.data["statusCode"] == 200) {
        state = state.copyWith(isLoading: false, success: true);
      } else {
        state = state.copyWith(
          isLoading: false,
          success: false,
          error: response.data["message"],
        );
      }
    } catch (ele) {
      state = state.copyWith(
        error: "Something went wrong.",
        isLoading: false,
        success: false,
        data: null,
      );
    }
  }

  void updateProfileImage(String preview, XFile file) {
    state = state.copyWith(profileImage: preview, file: file);
  }
}

// class ProfileController extends StateNotifier<ProfileState> {
//   ProfileController() : super(ProfileState()) {
//     state = ProfileState(
//       data: User(
//         phone: HiveService.getPhoneNumber() ?? "",
//         fullName: HiveService.getUserName() ?? "",
//         email: HiveService.getEmail() ?? "",
//         profilePic: HiveService.getProfile() ?? "",
//
//       ),
//       error: "",
//       isLoading: false,
//       success: false,
//     );
//   }
//
//
//   void updateUser(User model) async {
//
//     state = state.copyWith(isLoading: true);
//     String profilePicUrl = state.profileImage ?? "";
//     if (state.file != null) {
//       String fillName = state.file!.name;
//       Uint8List fileProfilePic =await state.file!.readAsBytes();
//
//       ResponseAPI profileUploadRes = await ApiManager.multipartAPI(
//         methodName: ApiEndpoints.uploadProfilePic,
//         params: {"image": dio.MultipartFile.fromBytes(fileProfilePic, filename: fillName)},
//       );
//       if (profileUploadRes.data["statusCode"] == 200) {
//         profilePicUrl = profileUploadRes.data["data"]["url"];
//       }
//     }
//
//     Map<String, dynamic> map = {
//       "fullName": model.fullName,
//       "phone": model.phone,
//       "profilePic":profilePicUrl,
//     };
//     ResponseAPI response = await ApiManager.put(
//       methodName: ApiEndpoints.updateUser,
//       params: map,
//     );
//     if (response.data["statusCode"] == 200) {
//       state = state.copyWith(isLoading: false, success: true);
//     } else {
//       state = state.copyWith(
//         isLoading: false,
//         success: false,
//         error: response.data["message"],
//       );
//     }
//   }
//   void updateProfileImage(String? image, XFile file) {
//     state = state.copyWith(profileImage: image, file: file);
//   }
// }
