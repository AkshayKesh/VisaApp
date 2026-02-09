import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/profile/controller/change_password_controller.dart';
import 'package:register_visa_web_app/features/profile/providers/states/change_password_state.dart';

final changePasswordProvider =
    StateNotifierProvider<ChangePasswordController, ChangePasswordState>(
      (ref) => ChangePasswordController(),
    );
