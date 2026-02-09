// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:country_pickers/country.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:register_visa_web_app/core/constants/visa_type_enum.dart';
import 'package:register_visa_web_app/features/visa_details/controller/details_controller.dart';
import 'package:register_visa_web_app/features/visa_details/domain/visa_details_model.dart';

final detailsProvider =
    StateNotifierProvider.family<DetailsController, dynamic, String?>(
      (ref, id) => DetailsController(id!),
    );

/// Provider for holding and updating the selected VisaType (String key), stores currently selected VisaOption for each type.
/// This allows for later updates of the selected VisaOption, based on the selected visa type (as a key).
final selectedVisaTypeProvider = StateProvider.family<VisaOption?, String>(
  (ref, visaType) => null,
);

VisaOption? getVisaOptionByType(String visaType, List<VisaOption> visaList) {
  try {
    return visaList.firstWhere(
      (visa) => VisaType.getLabelFromKey(visa.visaType) == visaType,
    );
  } catch (_) {
    return null;
  }
}

/// Provider for holding and updating the person count.
/// Default count is 1.
/// Provider for holding and updating the person's count and country.
/// Allows user to provide and update both count and country.
final personCountProvider = StateProvider<MyPassportModel>(
  (ref) => MyPassportModel(count: 1),
);

class MyPassportModel {
  Country? country;
  int count;
  MyPassportModel({this.country, this.count = 1});
  MyPassportModel copyWith({Country? country, int? count}) {
    return MyPassportModel(
      country: country ?? this.country,
      count: count ?? this.count,
    );
  }
}
