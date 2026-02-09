import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/core/constants/api_end_points.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_state.dart';
import 'package:register_visa_web_app/shared/services/dio_service.dart';
import 'package:register_visa_web_app/shared/services/visa_hive_service.dart';

class DetailsController extends StateNotifier<DetailsState> {
  final String id;

  AvailableDate? _availableDates;

  AvailableDate? get selectedDate => _availableDates;

  void setFDate(AvailableDate? date) {
    _availableDates = date;
  }

  DetailsController(this.id) : super(DetailsState()) {
    fetchDetails(id);
  }

  Future<void> fetchDetails(String id) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final url = '${ApiEndpoints.packagesDetails}/${VisaHiveService.instance.getVisaById() ?? id}';
      final response = await ApiManager.get(methodName: url);

      if (response.data["statusCode"] == 200) {
        final details = VisaDetailsModel.fromJson(response.data["data"]);
        state = state.copyWith(isLoading: false, isSuccess: true, data: details);
      } else {
        state = state.copyWith(isLoading: false, isSuccess: false, error: response.data["message"]);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, isSuccess: false, error: e.toString());
    }
  }

  void reset() {
    state = DetailsState();
  }

  void incressQuantity() {
    state = state.copyWith(data: state.data?.copyWith(persenoCount: state.data!.personCount + 1));
  }

  void dicressQuantity() {
    if (state.data!.personCount == 1) return;
    state = state.copyWith(data: state.data?.copyWith(persenoCount: state.data!.personCount - 1));
  }

  void updateDate(String fromDate) {
    final updatedDates = state.data!.availableDates.map((e) {
      if (e.fromDate == fromDate) {
        setFDate(e);
        return e.copyWith(isSelected: true);
      } else {
        return e.copyWith(isSelected: false);
      }
    }).toList();
    state = state.copyWith(data: state.data!.copyWith(availableDates: updatedDates));
  }
}
