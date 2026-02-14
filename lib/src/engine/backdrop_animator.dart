import 'dart:math' as math;

import '../scene/scene_spec.dart';

/// Time-based backdrop animation state.
class BackdropAnimator {
  double _time = 0.0;

  double get time => _time;

  void reset() {
    _time = 0.0;
  }

  void update(
    double dt, {
    required bool reduceMotion,
  }) {
    if (dt <= 0) {
      return;
    }
    final speed = reduceMotion ? 0.35 : 1.0;
    _time += dt * speed;
  }

  double driftPhase(BackdropSceneSpec spec) {
    final cycle = spec.gradientDrift.inMilliseconds / 1000.0;
    if (cycle <= 0) {
      return 0;
    }
    return (_time / cycle) % 1.0;
  }

  double glowPulse(BackdropSceneSpec spec, {required bool reduceMotion}) {
    final cycle = spec.glowPulse.inMilliseconds / 1000.0;
    if (cycle <= 0) {
      return 1.0;
    }
    final pulse = 0.5 + 0.5 * math.sin((_time / cycle) * math.pi * 2.0);
    final amplitude = reduceMotion ? 0.1 : 0.22;
    return 1.0 + (pulse - 0.5) * amplitude;
  }
}
