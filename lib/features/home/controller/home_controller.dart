import 'dart:async';

import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/features/home/domain/package_response.dart';
import 'package:register_visa_web_app/features/home/domain/testimonial_card.dart';
import 'package:register_visa_web_app/features/home/providers/home_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';

class HomeController extends AsyncNotifier<HomeState> {
  late ScrollController scrollController;
  @override
  FutureOr<HomeState> build() {
    // Load initial data when the provider is first created
    scrollController = ScrollController();
    return fetchPackages();
  }

  bool _isGetstartLoading = false;

  bool get getstartLoading => _isGetstartLoading;

  set isFlag(bool value) {
    _isGetstartLoading = value;
  }

  final List<Testimonial> testimonials = [
    Testimonial(
      name: 'Sarah Johnson',
      visaType: 'Thailand visa',
      timeAgo: '2 weeks ago',
      rating: 5,
      initials: 'SJ',
      message:
          'Incredibly smooth process! Got my Thailand visa approved in just 3 days. The team was super helpful and kept me updated throughout.',
    ),
    Testimonial(
      name: 'Rahul Sharma',
      visaType: 'UAE visa',
      timeAgo: '1 month ago',
      rating: 5,
      initials: 'RS',
      message:
          'Best visa service I’ve ever used. The application was straightforward and customer support was available 24/7.',
    ),
    Testimonial(
      name: 'Emma Wilson',
      visaType: 'Vietnam visa',
      timeAgo: '3 weeks ago',
      rating: 4,
      initials: 'EW',
      message:
          'Very professional service. The visa arrived exactly when promised. Will definitely use again.',
    ),
    Testimonial(
      name: 'Michael Chen',
      visaType: 'Switzerland visa',
      timeAgo: '1 week ago',
      rating: 5,
      initials: 'MC',
      message:
          'What impressed me most was the transparency. I could track my application status at every step.',
    ),
    Testimonial(
      name: 'Aisha Mohammed',
      visaType: 'Iceland visa',
      timeAgo: '5 days ago',
      rating: 5,
      initials: 'AM',
      message:
          'Quick, reliable, and affordable. I was skeptical at first but they exceeded my expectations.',
    ),
  ];

  void scrollForward() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final current = scrollController.offset;
    const delta = 300.0; // scroll distance per click
    double target = current + delta;

    if (target >= maxScroll) {
      // Reached end: trigger load more
      target = maxScroll;

      // Call your provider's loadMore method

      loadMorePackages();
    }

    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollBack() {
    if (!scrollController.hasClients) return;
    final current = scrollController.offset;
    const delta = 300.0;
    double target = current - delta;
    if (target < 0) target = 0;
    scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Gate (getter) and setter for Country initial value (default: United States)
  Country _myPassportCountry = Country(
    name: "United States",
    isoCode: "US",
    iso3Code: "USA",
    phoneCode: "",
  );

  Country get myPassportCountry => _myPassportCountry;

  set myPassportCountry(Country value) {
    _myPassportCountry = value;

    if (state.hasValue) {
      state = AsyncData(state.value!.copyWith(myPassport: value.name));
    }
  }

  Future<HomeState> fetchPackages({
    int page = 1,
    int limit = 8,
    bool isLoading = true,
  }) async {
    if (isLoading) {
      state = const AsyncLoading();
    }

    try {
      // Build query parameters for pagination

      final queryParams = 'page=$page&limit=$limit';
      final url = '${ApiEndpoints.packages}?$queryParams';

      final response = await ApiManager.get(methodName: url);

      if (response.data["statusCode"] == 200) {
        final packageResponse = PackageResponse.fromJson(response.data);

        return HomeState(
          isLoading: false,
          isSuccess: true,
          data: packageResponse,
        );
      } else {
        return HomeState(
          isLoading: false,
          isSuccess: false,
          error: response.data["message"],
        );
      }
    } catch (e) {
      return HomeState(
        isLoading: false,
        isSuccess: false,
        error: 'Failed to load packages: $e',
      );
    }
  }

  Future<void> refreshPackages() async {
    state = const AsyncLoading();
    state = AsyncData(await fetchPackages());
  }

  Future<PackageResponse?> searchPackages({
    required String search,
    int page = 1,
    int limit = 4,
  }) async {
    try {
      if (search.isEmpty) {
        return null;
      }

      final response = await ApiManager.post(
        methodName: ApiEndpoints.packagesSearch,
        params: {
          "page": page,
          "limit": limit,
          "search": search,
          "status": "active",
        },
      );

      if (response.data["statusCode"] == 200) {
        PackageResponse packageResponse = PackageResponse.fromJson(
          response.data,
        );

        return packageResponse;
      } else {
        throw Exception(response.data["message"] ?? 'Search failed');
      }
    } catch (e) {
      throw Exception('Failed to search packages: $e');
    }
  }

  /// Load more packages (append to existing data)
  Future<void> loadMorePackages() async {
    final currentState = state.value;
    if (currentState?.data?.pagination != null) {
      final currentPage = currentState!.data!.pagination.currentPage;
      final totalPages = currentState.data!.pagination.totalPages;

      if (currentPage < totalPages) {
        final nextPage = currentPage + 1;
        final newPackagesState = await fetchPackages(
          page: nextPage,
          isLoading: false,
        );

        if (newPackagesState.data != null && currentState.data != null) {
          // Combine current data with new data
          final currentPackages = currentState.data!.data;
          final newPackages = newPackagesState.data!.data;

          final combinedPackages = [...currentPackages, ...newPackages];
          final combinedResponse = PackageResponse(
            statusCode: newPackagesState.data!.statusCode,
            message: newPackagesState.data!.message,
            data: combinedPackages,
            pagination: newPackagesState.data!.pagination,
          );

          state = AsyncData(
            HomeState(
              isLoading: false,
              isSuccess: true,
              data: combinedResponse,
            ),
          );
        }
      }
    }
  }

  /// Check if there are more pages available
  bool hasNextPage() {
    final currentState = state.value;
    if (currentState?.data?.pagination != null) {
      final currentPage = currentState!.data!.pagination.currentPage;
      final totalPages = currentState.data!.pagination.totalPages;
      return currentPage < totalPages;
    }
    return false;
  }

  /// Check if there are previous pages available
  bool hasPreviousPage() {
    final currentState = state.value;
    if (currentState?.data?.pagination != null) {
      final currentPage = currentState!.data!.pagination.currentPage;
      return currentPage > 1;
    }
    return false;
  }

  /// Get current page information
  int getCurrentPage() {
    final currentState = state.value;
    return currentState?.data?.pagination.currentPage ?? 1;
  }

  /// Get total pages
  int getTotalPages() {
    final currentState = state.value;
    return currentState?.data?.pagination.totalPages ?? 1;
  }

  Future<Map<String, dynamic>> getStart(String? destenation) async {
    try {
      final response = await ApiManager.get(
        methodName: "${ApiEndpoints.getPackageByCountry}/$destenation",
      );
      return response.data;
    } catch (e) {
      return {};
    }
  }
}
