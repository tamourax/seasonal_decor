import 'package:flutter/widgets.dart';

/// Handles app lifecycle changes for pausing animation.
class LifecyclePause with WidgetsBindingObserver {
  /// Called when the app goes inactive or paused.
  final VoidCallback onPaused;

  /// Called when the app is resumed.
  final VoidCallback onResumed;

  bool _enabled;

  LifecyclePause({
    required this.onPaused,
    required this.onResumed,
    bool enabled = true,
  }) : _enabled = enabled {
    if (_enabled) {
      WidgetsBinding.instance.addObserver(this);
    }
  }

  /// Enables or disables lifecycle observation.
  void setEnabled(bool enabled) {
    if (_enabled == enabled) {
      return;
    }
    _enabled = enabled;
    if (_enabled) {
      WidgetsBinding.instance.addObserver(this);
    } else {
      WidgetsBinding.instance.removeObserver(this);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_enabled) {
      return;
    }
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        onPaused();
        break;
    }
  }

  /// Stop listening to lifecycle events.
  void dispose() {
    if (_enabled) {
      WidgetsBinding.instance.removeObserver(this);
    }
  }
}
