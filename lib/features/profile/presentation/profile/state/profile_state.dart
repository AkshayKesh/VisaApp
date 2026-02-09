import 'package:image_picker/image_picker.dart';
import 'package:register_visa_web_app/features/auth/domain/user.dart';

class ProfileState {
  ProfileState({this.isLoading = false, this.error = '', this.success = false, this.data, this.profileImage, this.file});

  final bool isLoading;
  final String error;
  final bool success;
  final User? data;
  final String? profileImage;
  final XFile? file;

  ProfileState copyWith({bool? isLoading, String? error, bool? success, User? data, String? profileImage, XFile? file}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      success: success ?? this.success,
      data: data ?? this.data,
      profileImage: profileImage ?? this.profileImage,
      file: file ?? this.file,
    );
  }
}
