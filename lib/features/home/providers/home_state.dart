import 'package:register_visa_web_app/features/home/domain/package_response.dart';

class HomeState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? myPassport;
  final String? myDestination;
  final PackageResponse? data;

  HomeState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.myPassport,
    this.myDestination,
    this.data,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    String? myPassport,
    String? myDestination,
    PackageResponse? data,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      myDestination: myDestination,
      myPassport: myPassport,
      data: data ?? this.data,
    );
  }
}
