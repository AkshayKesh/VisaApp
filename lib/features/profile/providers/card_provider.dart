import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';


import 'package:register_visa_web_app/features/profile/controller/card_controller.dart';
import 'package:register_visa_web_app/features/profile/providers/states/card_state.dart';

final cardProvider = AsyncNotifierProvider<CardController, CardState>(
   CardController.new,
);

final onLoadingButtonProvider = StateProvider<bool>((ref) => false);

