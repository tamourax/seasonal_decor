import 'package:flutter/widgets.dart';

/// Utility for reading the platform reduce motion preference.
class ReduceMotion {
  /// Returns true if animations should be reduced.
  static bool isEnabled(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    return mediaQuery?.disableAnimations ?? false;
  }
}
