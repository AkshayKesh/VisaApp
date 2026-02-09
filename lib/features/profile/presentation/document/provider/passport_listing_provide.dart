import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/controller/passport_listing_controller.dart';
import 'package:register_visa_web_app/features/profile/presentation/document/state/documnet_listing_state.dart';

final passportListingProvider =
    AsyncNotifierProvider<PassportListingController, DocumentListingState>(
      PassportListingController.new,
    );
