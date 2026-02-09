import 'package:register_visa_web_app/features/home/domain/package_response.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/application_listing_model.dart';

class ApplicationListingState {
  final int? statusCode;
  final String? error;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final Pagination? pagination;
  final bool isSuccess;
  final List<ApplicationsModle> applications;

  const ApplicationListingState({
    this.statusCode,
    this.error,
    this.pagination,

    this.isLoading = false,
    this.isSuccess = false,
    this.isLoadMore = false,
    this.hasMore = true,
    this.applications = const [],
  });

  /// ✅ Initial / default state
  factory ApplicationListingState.initial() {
    return const ApplicationListingState(isLoading: false, applications: []);
  }

  /// ✅ copyWith (IMMUTABLE update)
  ApplicationListingState copyWith({
    int? statusCode,
    String? error,
    Pagination? pagination,
    bool? isLoading,
    bool? isSuccess,
    bool? isLoadMore,
    bool? hasMore,
    List<ApplicationsModle>? applications,
  }) {
    return ApplicationListingState(
      statusCode: statusCode ?? this.statusCode,
      error: error,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      applications: applications ?? this.applications,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  /// ✅ fromJson (API → State)
  factory ApplicationListingState.fromJson(Map<String, dynamic> json) {
    return ApplicationListingState(
      statusCode: json['statusCode'],
      error: json['error'],
      isLoading: false,
      isSuccess: false,

      pagination: Pagination.fromJson(json['pagination']),
      applications: (json['data'] as List<dynamic>? ?? [])
          .map((e) => ApplicationsModle.fromJson(e))
          .toList(),
    );
  }

  /// ✅ toJson (State → JSON)
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'error': error,
      'isLoading': isLoading,
      'isSuccess': isSuccess,
      'data': applications.map((e) => e.toJson()).toList(),
    };
  }
}
