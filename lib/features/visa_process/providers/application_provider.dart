import 'package:flutter_riverpod/legacy.dart';
import 'package:register_visa_web_app/features/visa_details/providers/details_provider.dart';
import 'package:register_visa_web_app/features/visa_process/controller/application_controller.dart';
import 'package:register_visa_web_app/features/visa_process/providers/application_state.dart';

final visaApplicationProvider = StateNotifierProvider.autoDispose.family<VisaApplicationController, VisaApplicationState, MyPassportModel>(
  (ref, MyPassportModel value) => VisaApplicationController(value),
);

final activeStepProvider = StateNotifierProvider<ActiveStepNotifier, int>((ref) => ActiveStepNotifier());

class ActiveStepNotifier extends StateNotifier<int> {
  ActiveStepNotifier() : super(1);

  void setActiveStep(int step) {
    state = step;
  }
}

final processingTypeProvider = StateProvider<String?>((ref) => null);
final processingFeeProvider = StateProvider<String?>((ref) => "0");

class BooleanListNotifier extends StateNotifier<List<bool>> {
  BooleanListNotifier(int length, {int defaultTrueIndex = 0}) : super(List.generate(length, (i) => i == defaultTrueIndex));

  /// toggle specific index
  void toggle(int index) {
    final list = [...state];
    list[index] = !list[index];
    state = list;
  }

  /// set specific index value
  void setValue(int index, bool value) {
    final list = [...state];
    list[index] = value;
    state = list;
  }

  /// only one open at a time (accordion style)
  void openOnly(int index) {
    state = List.generate(state.length, (i) => i == index);
  }

  /// reset all
  void reset() {
    state = List.filled(state.length, false);
  }
}

final booleanListProvider = StateNotifierProvider.family<BooleanListNotifier, List<bool>, int>((ref, length) => BooleanListNotifier(length));

final currentStepProvider = StateProvider<int>((ref) => 0);
class ExpansionListNotifier extends StateNotifier<List<bool>> {
  ExpansionListNotifier(int length)
    : super(List.generate(length, (index) => index == 0));

  void toggle(int index) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) !state[i] else state[i],
    ];
  }
}

final expansionListProvider =
    StateNotifierProvider.family<ExpansionListNotifier, List<bool>, int>(
      (ref, length) => ExpansionListNotifier(length),
    );
