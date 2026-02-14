import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import '../config/decor_config.dart';
import 'particle_system.dart';

/// Drives the particle system using a ticker.
class DecorController extends ChangeNotifier {
  static const double _baselineArea = 360.0 * 640.0;

  late final Ticker _ticker;
  final ParticleSystem _system;
  DecorConfig _config;
  Size _bounds = Size.zero;
  double _densityScale = 1.0;
  bool _running = false;
  Duration _lastTick = Duration.zero;

  /// Creates a [DecorController] using the given [vsync] provider.
  DecorController({
    required TickerProvider vsync,
    required DecorConfig config,
  })  : _config = config,
        _system = ParticleSystem(config: config, size: Size.zero) {
    _ticker = vsync.createTicker(_handleTick);
  }

  /// Current particle system.
  ParticleSystem get system => _system;

  /// Current configuration.
  DecorConfig get config => _config;

  /// Returns whether the controller is running.
  bool get isRunning => _running;

  /// Starts the ticker if not already running.
  void start() {
    if (_running) {
      return;
    }
    _running = true;
    _lastTick = Duration.zero;
    _ticker.start();
  }

  /// Stops the ticker if running.
  void stop() {
    if (!_running) {
      return;
    }
    _running = false;
    _ticker.stop();
    _lastTick = Duration.zero;
    notifyListeners();
  }

  /// Updates the size bounds and recalculates adaptive density.
  void updateBounds(Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }
    if (size == _bounds) {
      return;
    }
    _bounds = size;
    final area = size.width * size.height;
    final scale = math.sqrt(area / _baselineArea);
    final clampedScale = scale.clamp(0.6, 1.4).toDouble();
    _densityScale = clampedScale;
    _system.setBounds(size);
    _system.setDensityScale(clampedScale);
    notifyListeners();
  }

  /// Updates the configuration while keeping the existing system instance.
  void updateConfig(DecorConfig config) {
    final previous = _config;
    _config = config;

    final requiresRebuild = previous.particleCount != config.particleCount;
    final requiresRespawn = previous.enableFireworks != config.enableFireworks ||
        previous.flow != config.flow ||
        previous.wrapMode != config.wrapMode;

    if (requiresRebuild) {
      _system.rebuildPool(config);
    } else {
      _system.setConfig(config, respawn: requiresRespawn);
    }
    _system.setDensityScale(_densityScale);
    notifyListeners();
  }

  void _handleTick(Duration elapsed) {
    if (!_running) {
      return;
    }
    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }
    final delta = elapsed - _lastTick;
    _lastTick = elapsed;
    final dt = delta.inMicroseconds / 1000000.0;
    if (dt > 0) {
      _system.update(dt);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
