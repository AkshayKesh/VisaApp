import 'package:flutter_riverpod/legacy.dart';

import 'package:register_visa_web_app/features/auth/controllers/auth_controller.dart';

import 'package:register_visa_web_app/features/auth/providers/login_state.dart';

final loginProvider = StateNotifierProvider<LoginController, LoginState>(
  (ref) => LoginController(),
);
