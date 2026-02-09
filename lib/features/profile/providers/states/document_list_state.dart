import 'package:register_visa_web_app/features/profile/domain/visa_application.dart';

class Documentstate {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final List<VisaApplication>? data;

  Documentstate({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.data,
  });

  Documentstate copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    List<VisaApplication>? data,
  }) {
    return Documentstate(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      data: data ?? this.data,
    );
  }

  void addPassport() {}
}
