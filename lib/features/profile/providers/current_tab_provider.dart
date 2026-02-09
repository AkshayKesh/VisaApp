
//create one provider it handle the current tal selection 
import 'package:flutter_riverpod/legacy.dart';



/// Provider to handle the current tab selection in the profile/visa management section.
final currentTabProvider = StateNotifierProvider<CurrentTabNotifier, int>((ref) => CurrentTabNotifier());

class CurrentTabNotifier extends StateNotifier<int> {
  CurrentTabNotifier() : super(0);

  void setTab(int index) {
    if (state != index) {
      state = index;
    }
  }
}
