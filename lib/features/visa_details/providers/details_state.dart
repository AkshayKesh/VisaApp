import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';

class DetailsState {
  final bool isLoading;
  final String? error;
  VisaDetailsModel? data;
  final bool isSuccess;

  DetailsState({
    this.isLoading = false,
    this.error,
    this.data,
    this.isSuccess = false,
  });

  DetailsState copyWith({
    bool? isLoading,
    String? error,
    VisaDetailsModel? data,
    bool? isSuccess,
  }) {
    return DetailsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      data: data ?? this.data,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

}