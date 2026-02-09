import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/profile/controller/add_passport_controller.dart';
import 'package:register_visa_web_app/features/profile/providers/states/add_passport_state.dart';

final addPassportProvider = StateNotifierProvider<AddPassportController, AddPassportState>((ref) => AddPassportController());
