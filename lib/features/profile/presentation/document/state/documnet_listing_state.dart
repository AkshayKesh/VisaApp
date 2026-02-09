import 'package:register_visa_web_app/features/profile/presentation/document/domain/passport_listing_model.dart';

class DocumentListingState {
  int? code;
  bool? isSuccess;
  String? error;
  bool? isLoading;
  List<PassportListingModel>? passportList;
  DocumentListingState({this.code, this.isSuccess, this.error, this.isLoading, this.passportList});

  DocumentListingState copyWith({
    int? code,
    bool? isSuccess,
    String? error,
    bool? isLoading,
    List<PassportListingModel>? passportList,
  }) {
    return DocumentListingState(
      code: code ?? this.code,
      isSuccess: isSuccess ?? this.isSuccess,
      isLoading: isLoading??this.isLoading,
      error: error ?? this.error,
      passportList: passportList ?? this.passportList,
    );
  }

  factory DocumentListingState.fromJson(Map<String, dynamic> json) {
    return DocumentListingState(
      code: json['code'] ?? 0,
      isSuccess: json['sucess'] ?? false,
      error: json['error'] ?? '',
      passportList: json['passportList'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'sucess': isSuccess,
      'error': error,
      'passportList': passportList?.map((e) => e.toJson()).toList(),
    };
  }
}
