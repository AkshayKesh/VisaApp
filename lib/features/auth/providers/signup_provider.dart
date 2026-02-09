import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/auth/controllers/signup_controller.dart';
import 'package:register_visa_web_app/features/auth/providers/signup_state.dart';

final signupProvider = StateNotifierProvider<SignupController, SignupState>(
  (ref) => SignupController(),
);
