
import 'package:flutter_riverpod/legacy.dart';

/// Controls expand / collapse state of each timeline tile
final timelineExpansionProvider = StateNotifierProvider.autoDispose
    .family<TimelineExpansionController, bool, String>((ref, id) {
      return TimelineExpansionController();
    });

class TimelineExpansionController extends StateNotifier<bool> {
  TimelineExpansionController() : super(false);

  void toggle() => state = !state;

  void expand() => state = true;

  void collapse() => state = false;
}
