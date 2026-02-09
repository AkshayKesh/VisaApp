import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/profile/presentation/profile/controller/profile_controller.dart';
import 'package:register_visa_web_app/features/profile/presentation/profile/state/profile_state.dart';

final profileProvider = StateNotifierProvider<ProfileController, ProfileState>(
      (ref) => ProfileController(),
);
