import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/controller/application_listing_controller.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/visa_list_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/state/application_listing_state.dart';

final applicationStatusFilterProvider = StateProvider<VisaListParam>((ref) => VisaListParam(status: "closed"));
final applicationListingProvider = StateNotifierProvider.family<ApplicationListingController, ApplicationListingState, VisaListParam>((ref, param) {
  return ApplicationListingController(param);
});
