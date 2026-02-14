import 'dart:math' as math;
import 'dart:ui';

import '../scene/palette_harmony.dart';
import '../scene/scene_spec.dart';
import '../scene/seasonal_mode.dart';

class MomentParticle {
  bool active;
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double opacity;
  double life;
  double maxLife;
  double rotation;
  double rotationSpeed;
  Color color;
  MomentVisualStyle style;

  MomentParticle()
      : active = false,
        x = 0,
        y = 0,
        vx = 0,
        vy = 0,
        size = 0,
        opacity = 1,
        life = 0,
        maxLife = 0,
        rotation = 0,
        rotationSpeed = 0,
        color = const Color(0x00000000),
        style = MomentVisualStyle.sparkle;

  double get lifeProgress {
    if (maxLife <= 0) {
      return 1.0;
    }
    return (life / maxLife).clamp(0.0, 1.0).toDouble();
  }
}

class _ActiveMoment {
  final int id;
  final MomentSpec spec;
  final double durationSeconds;
  double elapsed;

  _ActiveMoment({
    required this.id,
    required this.spec,
    required this.durationSeconds,
  }) : elapsed = 0;

  bool get isDone => elapsed >= durationSeconds;
}

/// Pooled one-shot effects for user-triggered moments.
class MomentEngine {
  static const int _poolSize = 280;
  static const int _maxConcurrent = 2;
  static const double _cooldownSeconds = 0.25;

  final math.Random _random;
  final List<MomentParticle> _particles;
  final List<_ActiveMoment> _activeMoments;
  int _nextMomentId = 0;
  double _sinceLastTrigger = 999.0;

  MomentEngine({math.Random? random})
      : _random = random ?? math.Random(),
        _particles = List<MomentParticle>.generate(
          _poolSize,
          (_) => MomentParticle(),
        ),
        _activeMoments = <_ActiveMoment>[];

  List<MomentParticle> get particles => _particles;

  bool get hasActiveMoments {
    for (final particle in _particles) {
      if (particle.active) {
        return true;
      }
    }
    return false;
  }

  void clear() {
    _activeMoments.clear();
    for (final particle in _particles) {
      particle.active = false;
    }
  }

  void trigger({
    required MomentSpec spec,
    required ScenePalette palette,
    required Size size,
    required SeasonalMomentOptions options,
    required bool reduceMotion,
  }) {
    if (_sinceLastTrigger < _cooldownSeconds) {
      return;
    }
    if (_activeMoments.length >= _maxConcurrent) {
      _activeMoments.removeAt(0);
    }

    final intensity = options.intensity.clamp(0.0, 1.0).toDouble();
    final countScale = reduceMotion ? 0.55 : 1.0;
    final speedScale = reduceMotion ? 0.55 : 1.0;
    final count = math.max(
      8,
      (spec.particleCount * intensity * countScale).round(),
    );
    final origin = _resolveOrigin(options.origin, size);
    final duration =
        (options.durationOverride ?? spec.duration).inMicroseconds / 1000000.0;
    final clampedDuration = duration.clamp(0.35, 3.0).toDouble();
    final minSpeed = spec.minSpeed * speedScale;
    final maxSpeed = spec.maxSpeed * speedScale;

    _activeMoments.add(
      _ActiveMoment(
        id: _nextMomentId,
        spec: spec,
        durationSeconds: clampedDuration,
      ),
    );
    _nextMomentId += 1;
    _sinceLastTrigger = 0.0;

    var spawned = 0;
    for (final particle in _particles) {
      if (particle.active) {
        continue;
      }
      _spawnParticle(
        particle,
        spec: spec,
        palette: palette,
        origin: origin,
        minSpeed: minSpeed,
        maxSpeed: maxSpeed,
        minSize: spec.minSize,
        maxSize: spec.maxSize,
        duration: clampedDuration,
      );
      spawned += 1;
      if (spawned >= count) {
        break;
      }
    }
  }

  void update(
    double dt, {
    required bool reduceMotion,
  }) {
    if (dt <= 0) {
      return;
    }
    final step = dt.clamp(0.0, 0.05).toDouble();
    _sinceLastTrigger += step;

    final gravity = reduceMotion ? 22.0 : 42.0;
    for (final particle in _particles) {
      if (!particle.active) {
        continue;
      }
      if (particle.style == MomentVisualStyle.firework ||
          particle.style == MomentVisualStyle.confetti) {
        particle.vy += gravity * step;
      }

      particle.x += particle.vx * step;
      particle.y += particle.vy * step;
      particle.rotation += particle.rotationSpeed * step;
      particle.life -= step;
      if (particle.life <= 0) {
        particle.active = false;
      }
    }

    for (var i = _activeMoments.length - 1; i >= 0; i -= 1) {
      final moment = _activeMoments[i];
      moment.elapsed += step;
      if (moment.isDone) {
        _activeMoments.removeAt(i);
      }
    }
  }

  void _spawnParticle(
    MomentParticle particle, {
    required MomentSpec spec,
    required ScenePalette palette,
    required Offset origin,
    required double minSpeed,
    required double maxSpeed,
    required double minSize,
    required double maxSize,
    required double duration,
  }) {
    final angle = _random.nextDouble() * math.pi * 2.0;
    final speed = _randomInRange(minSpeed, maxSpeed);
    final size = _randomInRange(minSize, maxSize);
    final color = _pickMomentColor(palette, spec.style);

    double vx = math.cos(angle) * speed;
    double vy = math.sin(angle) * speed;
    if (spec.style == MomentVisualStyle.sparkle) {
      vy -= speed * 0.18;
    } else if (spec.style == MomentVisualStyle.ringSpark) {
      final normalizedAngle = _random.nextDouble() * math.pi * 2.0;
      vx = math.cos(normalizedAngle) * speed * 0.9;
      vy = math.sin(normalizedAngle) * speed * 0.55;
    } else if (spec.style == MomentVisualStyle.confetti) {
      vy -= speed * 0.55;
    } else if (spec.style == MomentVisualStyle.firework) {
      vy -= speed * 0.8;
    }

    particle
      ..active = true
      ..x = origin.dx + _randomSigned(_randomInRange(0.0, size * 1.2))
      ..y = origin.dy + _randomSigned(_randomInRange(0.0, size * 1.2))
      ..vx = vx
      ..vy = vy
      ..size = size
      ..opacity = _randomInRange(0.62, 1.0)
      ..life = _randomInRange(duration * 0.5, duration)
      ..maxLife = duration
      ..rotation = _random.nextDouble() * math.pi * 2.0
      ..rotationSpeed = _randomSigned(_randomInRange(0.5, 4.2))
      ..color = color
      ..style = spec.style;
  }

  Offset _resolveOrigin(Offset? normalized, Size size) {
    if (normalized == null) {
      return Offset(size.width * 0.5, size.height * 0.35);
    }
    return Offset(
      normalized.dx.clamp(0.0, 1.0) * size.width,
      normalized.dy.clamp(0.0, 1.0) * size.height,
    );
  }

  Color _pickMomentColor(ScenePalette palette, MomentVisualStyle style) {
    switch (style) {
      case MomentVisualStyle.sparkle:
        return _random.nextBool()
            ? palette.momentAccent
            : palette.momentPrimary;
      case MomentVisualStyle.confetti:
        return palette
            .particleColors[_random.nextInt(palette.particleColors.length)];
      case MomentVisualStyle.firework:
        return _random.nextDouble() > 0.5
            ? palette.momentPrimary
            : palette.momentAccent;
      case MomentVisualStyle.ringSpark:
        return _random.nextDouble() > 0.35
            ? palette.momentAccent
            : palette
                .particleColors[_random.nextInt(palette.particleColors.length)];
    }
  }

  double _randomInRange(double min, double max) {
    if (max <= min) {
      return min;
    }
    return min + _random.nextDouble() * (max - min);
  }

  double _randomSigned(double value) {
    if (value == 0) {
      return 0;
    }
    return _random.nextBool() ? value : -value;
  }
}
