import 'package:flutter/foundation.dart';

import '../presets/celebration_preset.dart';

/// Public controller for triggering one-shot celebration overlays.
class SeasonalDecorController extends ChangeNotifier {
  int _celebrationToken = 0;
  CelebrationPreset? _latestCelebration;

  /// Monotonic token incremented for every [celebrate] call.
  int get celebrationToken => _celebrationToken;

  /// Most recently requested celebration preset.
  CelebrationPreset? get latestCelebration => _latestCelebration;

  /// Triggers a one-shot action celebration.
  ///
  /// If another celebration is active, the latest call should replace it.
  void celebrate(CelebrationPreset preset) {
    _latestCelebration = preset;
    _celebrationToken += 1;
    notifyListeners();
  }
}
