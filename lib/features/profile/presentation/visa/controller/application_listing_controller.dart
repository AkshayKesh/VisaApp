import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/core/utils/string_logger_extension.dart';
import 'package:register_visa_web_app/features/home/domain/package_response.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/application_listing_model.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/visa_list_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/state/application_listing_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';

class ApplicationListingController extends StateNotifier<ApplicationListingState> {
  ApplicationListingController(this.param) : super(ApplicationListingState(isLoading: true, applications: [])) {
    fetchApplication(reset: true, param: param);
  }

  final VisaListParam param;

  Future<void> fetchApplication({bool reset = false, required VisaListParam param}) async {
    if (state.isLoadMore || !state.hasMore) return;
    try {
      // Build query parameters for pagination

      final response = await ApiManager.post(
        methodName: ApiEndpoints.getAllApplication,
        params: {
          //"status": "draft", //draft , closed , pending
          "status": param.status,
          "page": param.page,
          "limit": param.limit,
        },
      );

      if (response.data["statusCode"] == 200) {
        final List<dynamic> dataList = response.data["data"] ?? [];
        final List<ApplicationsModle> newList = dataList
            .map(
              (item) => ApplicationsModle(
                id: item[ApplicationsModle.idKey],
                noOfTraveller: item[ApplicationsModle.noOfTravellerKey],
                status: item[ApplicationsModle.statusKey],
                submittedDate: item[ApplicationsModle.submittedDateKey] != null ? DateTime.tryParse(item[ApplicationsModle.submittedDateKey]) : null,
                applicationId: item[ApplicationsModle.applicationIdKey],
                packageDetails: item[ApplicationsModle.packageDetailsKey] != null
                    ? PackageDetails.fromJson(item[ApplicationsModle.packageDetailsKey])
                    : null,
                travellerDetails: item[ApplicationsModle.travellerDetailsKey] != null
                    ? List<TravellerDetail>.from(
                        (item[ApplicationsModle.travellerDetailsKey] as List).map((traveller) => TravellerDetail.fromJson(traveller)),
                      )
                    : [],
              ),
            )
            .toList();
        Pagination pagination = Pagination.fromJson(response.data["pagination"]);
        state = state.copyWith(
          isLoading: false,
          isLoadMore: false,
          isSuccess: true,
          pagination: pagination,
          applications: newList,
          hasMore: newList.length == param.limit,
        );
      } else {
        state = state.copyWith(isLoading: false, isSuccess: false, error: response.data["message"]);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isSuccess: false, error: 'Failed to load packages: $e');
    }
  }

  void loadMore(VisaListParam param) {
    "PARAM ${param.page}".logE();
    fetchApplication(param: param);
  }
}
