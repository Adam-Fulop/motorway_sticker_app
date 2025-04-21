import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedCountiesNotifier extends Notifier<Map<String, bool>> {
  @override
  Map<String, bool> build() {
    return {};
  }

  void toggleCounty(String countyId) {
    state = {...state, countyId: !(state[countyId] ?? false)};
  }

  void clearSelection() {
    state = {};
  }
}

final selectedCountiesProvider =
    NotifierProvider<SelectedCountiesNotifier, Map<String, bool>>(() {
      return SelectedCountiesNotifier();
    });
