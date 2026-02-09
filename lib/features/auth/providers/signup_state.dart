

import 'package:image_picker/image_picker.dart';

class SignupState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final dynamic data;
  final String? profileImage;
  final XFile? file;

  SignupState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.data,
    this.profileImage,
    this.file,
  });

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    dynamic data,
    String? profileImage,
    XFile? file,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      data: data ?? this.data,
      profileImage: profileImage ?? this.profileImage,
      file: file ?? this.file,
    );
  }
}
