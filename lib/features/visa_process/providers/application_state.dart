import 'package:register_visa_web_app/features/visa_process/domain/traveller_model.dart';

class VisaApplicationState {
  final bool isLoading;
  final bool isSuccess;
  final bool frontPhotoUrlLoading;
  final bool backPhotoUrlLoading;
  final bool passportPhotoLoading;
  final bool isSubmit;
  final bool isMakePaymentSuccess;
  final bool isMakePaymentLoading;
  final String? makePaymentError;
  final String? successPaymentMessage;
  final String? error;
  final bool? isTravelerAddStatus;
  final String? travelerAddError;
  final List<Traveller> travellers;
  final int currentTravellerIndex;

  VisaApplicationState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isMakePaymentLoading = false,
    this.isMakePaymentSuccess = false,
    this.makePaymentError,
    this.successPaymentMessage,
    this.error,
    this.isTravelerAddStatus = false,
    this.travelerAddError,
    required this.travellers,
    this.currentTravellerIndex = 0,
    this.frontPhotoUrlLoading = false,
    this.isSubmit = false,
    this.backPhotoUrlLoading = false,
    this.passportPhotoLoading = false,
  });

  VisaApplicationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isTravelerAddStatus,
    String? travelerAddError,
    bool? isMakePaymentLoading,
    bool? isMakePaymentSuccess,
    String? makePaymentError,
    String? successPaymentMessage,
    bool? frontPhotoUrlLoading,
    bool? backPhotoUrlLoading,
    bool? passportPhotoLoading,
    bool? isSubmit,
    String? error,
    List<Traveller>? travellers,
    int? currentTravellerIndex,
  }) {
    return VisaApplicationState(
      isLoading: isLoading ?? this.isLoading,
      successPaymentMessage:
          successPaymentMessage ?? this.successPaymentMessage,
      isMakePaymentLoading: isMakePaymentLoading ?? this.isMakePaymentLoading,
      isMakePaymentSuccess: isMakePaymentSuccess ?? this.isMakePaymentSuccess,
      makePaymentError: makePaymentError ?? this.makePaymentError,
      isSuccess: isSuccess ?? this.isSuccess,
      isSubmit: isSubmit ?? this.isSubmit,
      frontPhotoUrlLoading: frontPhotoUrlLoading ?? this.frontPhotoUrlLoading,
      backPhotoUrlLoading: backPhotoUrlLoading ?? this.backPhotoUrlLoading,
      passportPhotoLoading: passportPhotoLoading ?? this.passportPhotoLoading,
      isTravelerAddStatus: isTravelerAddStatus ?? this.isTravelerAddStatus,
      travelerAddError: travelerAddError ?? this.travelerAddError,
      error: error ?? this.error,
      travellers: travellers ?? this.travellers,
      currentTravellerIndex:
          currentTravellerIndex ?? this.currentTravellerIndex,
    );
  }
}
