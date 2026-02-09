import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/controller/application_detasil_controller.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/controller/traveler_application_status_controller.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/domain/travel_param.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/state/application_travelers_state.dart';
import 'package:register_visa_web_app/features/profile/presentation/visa/state/traveler_app_status.dart';

final applicationDetailsProvider = StateNotifierProvider.family<ApplicationDetasilController, ApplicationDetailsTravelersStatus, String>(
  (ref, id) => ApplicationDetasilController(id),
);

final travelerApplicationStatusStaper = StateNotifierProvider.autoDispose.family<TravelerAppStatusController, TravelerAppStatus, TravelerIdParam>((
  ref,
  param,
) {
  return TravelerAppStatusController(param);
});

final currentTravelerProvider = StateProvider<int>((ref) => 0);
