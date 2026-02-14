import '../scene/scene_spec.dart';

enum SceneTransitionPhase {
  idle,
  entering,
  steady,
  exiting,
}

/// Handles smooth scene opacity and spawn transitions.
class SceneTransitionController {
  SceneTransitionPhase _phase = SceneTransitionPhase.idle;
  double _elapsed = 0.0;

  SceneTransitionPhase get phase => _phase;

  void enter() {
    _phase = SceneTransitionPhase.entering;
    _elapsed = 0.0;
  }

  void steady() {
    _phase = SceneTransitionPhase.steady;
    _elapsed = 0.0;
  }

  void exit() {
    _phase = SceneTransitionPhase.exiting;
    _elapsed = 0.0;
  }

  void idle() {
    _phase = SceneTransitionPhase.idle;
    _elapsed = 0.0;
  }

  void update(double dt, SceneTransitionSpec spec) {
    if (dt <= 0) {
      return;
    }
    _elapsed += dt;
    if (_phase == SceneTransitionPhase.entering) {
      final maxIn = _seconds(spec.ambientRampIn);
      if (_elapsed >= maxIn) {
        steady();
      }
      return;
    }
    if (_phase == SceneTransitionPhase.exiting) {
      final maxOut = _seconds(spec.settleOut);
      if (_elapsed >= maxOut) {
        idle();
      }
    }
  }

  double sceneAlpha(SceneTransitionSpec spec) {
    switch (_phase) {
      case SceneTransitionPhase.idle:
        return 0.0;
      case SceneTransitionPhase.entering:
        return _curve(_elapsed / _seconds(spec.ambientRampIn));
      case SceneTransitionPhase.steady:
        return 1.0;
      case SceneTransitionPhase.exiting:
        return 1.0 - _curve(_elapsed / _seconds(spec.settleOut));
    }
  }

  double backdropAlpha(SceneTransitionSpec spec) {
    switch (_phase) {
      case SceneTransitionPhase.idle:
        return 0.0;
      case SceneTransitionPhase.entering:
        return _curve(_elapsed / _seconds(spec.backdropFadeIn));
      case SceneTransitionPhase.steady:
        return 1.0;
      case SceneTransitionPhase.exiting:
        return 1.0 - _curve(_elapsed / _seconds(spec.backdropFadeOut));
    }
  }

  double ambientSpawnFactor(SceneTransitionSpec spec) {
    switch (_phase) {
      case SceneTransitionPhase.idle:
        return 0.0;
      case SceneTransitionPhase.entering:
        return _curve(_elapsed / _seconds(spec.ambientRampIn));
      case SceneTransitionPhase.steady:
        return 1.0;
      case SceneTransitionPhase.exiting:
        return 1.0 - _curve(_elapsed / _seconds(spec.spawnRampOut));
    }
  }

  bool get isActive => _phase != SceneTransitionPhase.idle;

  double _curve(double t) {
    final clamped = t.clamp(0.0, 1.0).toDouble();
    // smoothstep
    return clamped * clamped * (3 - 2 * clamped);
  }

  double _seconds(Duration value) {
    final seconds = value.inMicroseconds / 1000000.0;
    return seconds <= 0 ? 0.0001 : seconds;
  }
}
