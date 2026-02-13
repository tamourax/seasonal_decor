import 'dart:math' as math;
import 'dart:ui';

import '../config/decor_config.dart';
import 'particle.dart';

/// Manages a pool of particles and updates them over time.
class ParticleSystem {
  final math.Random _random;
  DecorConfig _config;
  Size _size;
  double _spawnAccumulator = 0;
  double _rocketSpawnAccumulator = 0;
  int _maxActive;
  final List<Particle> _particles;
  bool _spawningEnabled = true;
  bool _wrapEnabled = true;

  /// Creates a particle system with a fixed-size pool.
  ParticleSystem({
    required DecorConfig config,
    required Size size,
    math.Random? random,
  })  : _config = config,
        _size = size,
        _random = random ?? math.Random(),
        _maxActive = config.particleCount,
        _particles = List<Particle>.generate(
          config.particleCount,
          (_) => Particle.inactive(),
        ) {
    if (_hasBounds) {
      _respawnAll();
    }
  }

  /// Current configuration.
  DecorConfig get config => _config;

  /// Current bounds size.
  Size get size => _size;

  /// Particle pool for rendering and testing.
  List<Particle> get particles => _particles;

  /// Returns true when there are active particles in the pool.
  bool get hasActiveParticles => _particles.any((particle) => particle.active);

  /// Enables or disables spawning new particles.
  void setSpawningEnabled(bool enabled) {
    _spawningEnabled = enabled;
    if (!enabled) {
      _spawnAccumulator = 0;
      _rocketSpawnAccumulator = 0;
    }
  }

  /// Enables or disables wrapping particles when out of bounds.
  void setWrapEnabled(bool enabled) {
    _wrapEnabled = enabled;
  }

  bool get _hasBounds => _size.width > 0 && _size.height > 0;

  /// Updates the bounds and repositions particles if needed.
  void setBounds(Size size) {
    if (size.width <= 0 || size.height <= 0) {
      _size = size;
      return;
    }
    if (size == _size) {
      return;
    }
    _size = size;
    _respawnAll();
  }

  /// Updates adaptive density scaling.
  void setDensityScale(double scale) {
    final clamped = scale.clamp(0.4, 1.8) as double;
    _maxActive = math.max(1, (_config.particleCount * clamped).round());
    _maxActive = math.min(_maxActive, _config.particleCount);
    _syncActiveCount();
  }

  /// Advances the system by [dt] seconds.
  void update(double dt) {
    if (!_hasBounds) {
      return;
    }
    if (dt <= 0) {
      return;
    }
    final double delta = dt.clamp(0.0, 0.05) as double;
    if (_config.enableFireworks) {
      _updateFireworks(delta);
      return;
    }

    for (final particle in _particles) {
      if (!particle.active) {
        continue;
      }
      particle.update(delta);
      if (_isOutOfBounds(particle)) {
        if (_wrapEnabled && _config.wrapMode == DecorWrapMode.wrap) {
          _wrapParticle(particle);
        } else {
          particle.active = false;
        }
      }
    }

    if (_spawningEnabled && _config.wrapMode == DecorWrapMode.respawn) {
      _spawnAccumulator += _config.spawnRate * delta;
      _spawnWithBudget();
    }
  }

  void _syncActiveCount() {
    if (_config.enableFireworks) {
      _enforceMaxActive();
      return;
    }

    final activeCount = _countActive();
    if (activeCount > _maxActive) {
      var remainingToDisable = activeCount - _maxActive;
      for (final particle in _particles.reversed) {
        if (!particle.active) {
          continue;
        }
        particle.active = false;
        remainingToDisable -= 1;
        if (remainingToDisable <= 0) {
          break;
        }
      }
      return;
    }

    if (activeCount < _maxActive) {
      _spawnInactive(_maxActive - activeCount);
    }
  }

  void _enforceMaxActive() {
    final activeCount = _countActive();
    if (activeCount <= _maxActive) {
      return;
    }
    var remainingToDisable = activeCount - _maxActive;
    for (final particle in _particles.reversed) {
      if (!particle.active) {
        continue;
      }
      particle.active = false;
      remainingToDisable -= 1;
      if (remainingToDisable <= 0) {
        break;
      }
    }
  }

  int _countActive() {
    var count = 0;
    for (final particle in _particles) {
      if (particle.active) {
        count += 1;
      }
    }
    return count;
  }

  void _respawnAll() {
    if (_config.enableFireworks) {
      _respawnFireworks();
      return;
    }

    final target = _maxActive;
    for (var i = 0; i < _particles.length; i += 1) {
      if (i < target) {
        _spawnParticle(_particles[i]);
      } else {
        _particles[i].active = false;
      }
    }
  }

  void _respawnFireworks() {
    final maxRockets = math.min(_config.rocketsMax, _maxActive);
    final maxSparks = math.max(0, _maxActive - maxRockets);
    final initialSparks = math.min(maxSparks, maxRockets * 8);
    var rocketsSpawned = 0;
    var sparksSpawned = 0;
    for (final particle in _particles) {
      if (rocketsSpawned < maxRockets) {
        _spawnRocket(particle);
        rocketsSpawned += 1;
        continue;
      }
      if (sparksSpawned < initialSparks) {
        _spawnSpark(particle, _randomSparkOrigin());
        sparksSpawned += 1;
        continue;
      }
      if (_config.spawnRate > 0) {
        _spawnParticle(particle);
      } else {
        particle.active = false;
      }
    }
  }

  void _spawnWithBudget() {
    final activeCount = _countActive();
    final available = _maxActive - activeCount;
    if (available <= 0) {
      return;
    }
    final toSpawn = math.min(available, _spawnAccumulator.floor());
    if (toSpawn <= 0) {
      return;
    }
    _spawnAccumulator -= _spawnInactive(toSpawn);
  }

  int _spawnInactive(int count) {
    var spawned = 0;
    for (final particle in _particles) {
      if (particle.active) {
        continue;
      }
      _spawnParticle(particle);
      spawned += 1;
      if (spawned >= count) {
        break;
      }
    }
    return spawned;
  }

  void _spawnParticle(Particle particle) {
    final style = _config.styles[_random.nextInt(_config.styles.length)];
    final size = _lerp(style.minSize, style.maxSize, _random.nextDouble());
    final speed =
        _lerp(style.minSpeed, style.maxSpeed, _random.nextDouble()) *
            _config.speedMultiplier;
    final rotation = _random.nextDouble() * math.pi * 2;
    final rotationSpeed = _randomSigned(
      _lerp(
        style.minRotationSpeed,
        style.maxRotationSpeed,
        _random.nextDouble(),
      ),
    );

    final position = _spawnPosition(size);
    final velocity = _spawnVelocity(speed);

    particle.reset(
      position: position,
      velocity: velocity,
      size: size,
      rotation: rotation,
      rotationSpeed: rotationSpeed,
      color: style.color,
      opacity: style.opacity,
      shape: style.shape,
      kind: ParticleKind.normal,
      life: 0,
      maxLife: 0,
    );
  }

  Offset _spawnPosition(double size) {
    switch (_config.flow) {
      case ParticleFlow.falling:
        final x = _randomInRange(0, _size.width);
        final y = -_randomInRange(size, _size.height * 0.2 + size);
        return Offset(x, y);
      case ParticleFlow.floating:
        return Offset(
          _randomInRange(0, _size.width),
          _randomInRange(0, _size.height),
        );
    }
  }

  Offset _spawnVelocity(double speed) {
    switch (_config.flow) {
      case ParticleFlow.falling:
        final dx = _randomInRange(-_config.drift, _config.drift) *
            _config.speedMultiplier;
        return Offset(dx, speed);
      case ParticleFlow.floating:
        final angle = _random.nextDouble() * math.pi * 2;
        return Offset(math.cos(angle) * speed, math.sin(angle) * speed);
    }
  }

  bool _isOutOfBounds(Particle particle) {
    final margin = particle.size * 2.0;
    return particle.position.dx < -margin ||
        particle.position.dx > _size.width + margin ||
        particle.position.dy < -margin ||
        particle.position.dy > _size.height + margin;
  }

  void _wrapParticle(Particle particle) {
    final margin = particle.size * 2.0;
    var dx = particle.position.dx;
    var dy = particle.position.dy;

    if (dx < -margin) {
      dx = _size.width + margin;
    } else if (dx > _size.width + margin) {
      dx = -margin;
    }

    if (dy < -margin) {
      dy = _size.height + margin;
    } else if (dy > _size.height + margin) {
      dy = -margin;
    }

    particle.position = Offset(dx, dy);
  }

  void _updateFireworks(double dt) {
    final burstHeight = _size.height * _config.burstHeightFactor;
    var activeCount = 0;
    var activeRockets = 0;

    for (final particle in _particles) {
      if (!particle.active) {
        continue;
      }

      activeCount += 1;

      if (particle.kind == ParticleKind.spark) {
        particle.velocity = Offset(
          particle.velocity.dx,
          particle.velocity.dy + _config.gravityY * dt,
        );
      }

      particle.update(dt);

      if (!particle.active) {
        if (particle.kind == ParticleKind.rocket) {
          if (_spawningEnabled) {
            _burst(particle.position);
          }
        }
        continue;
      }

      if (particle.kind == ParticleKind.rocket) {
        activeRockets += 1;
        if (particle.position.dy <= burstHeight) {
          particle.active = false;
          if (_spawningEnabled) {
            _burst(particle.position);
          }
        }
      } else if (particle.kind == ParticleKind.spark) {
        if (_isOutOfBounds(particle)) {
          particle.active = false;
        }
      } else if (_isOutOfBounds(particle)) {
        if (_wrapEnabled && _config.wrapMode == DecorWrapMode.wrap) {
          _wrapParticle(particle);
        } else {
          particle.active = false;
        }
      }
    }

    if (_spawningEnabled) {
      _rocketSpawnAccumulator += _config.rocketSpawnRate * dt;
      final maxRockets = math.min(_config.rocketsMax, _maxActive);
      final availableRockets = maxRockets - activeRockets;
      final availableSlots = _maxActive - activeCount;
      if (availableRockets <= 0 || availableSlots <= 0) {
        return;
      }

      final toSpawn = math.min(
        availableRockets,
        math.min(availableSlots, _rocketSpawnAccumulator.floor()),
      );
      if (toSpawn <= 0) {
        return;
      }
      final spawned = _spawnRockets(toSpawn);
      activeCount += spawned;
      _rocketSpawnAccumulator -= spawned;

      if (_config.spawnRate <= 0 || _config.wrapMode != DecorWrapMode.respawn) {
        return;
      }

      _spawnAccumulator += _config.spawnRate * dt;
      final ambientSlots = _maxActive - activeCount;
      if (ambientSlots <= 0) {
        return;
      }
      final ambientToSpawn = math.min(ambientSlots, _spawnAccumulator.floor());
      if (ambientToSpawn <= 0) {
        return;
      }
      final spawnedAmbient = _spawnInactive(ambientToSpawn);
      _spawnAccumulator -= spawnedAmbient;
    }
  }

  int _spawnRockets(int count) {
    var spawned = 0;
    for (final particle in _particles) {
      if (particle.active) {
        continue;
      }
      _spawnRocket(particle);
      spawned += 1;
      if (spawned >= count) {
        break;
      }
    }
    return spawned;
  }

  void _spawnRocket(Particle particle) {
    final style = _config.styles[_random.nextInt(_config.styles.length)];
    final speed = _lerp(
          _config.rocketMinSpeed,
          _config.rocketMaxSpeed,
          _random.nextDouble(),
        ) *
        _config.speedMultiplier;
    final size = _config.rocketSize * (0.85 + _random.nextDouble() * 0.3);
    final life = _lerp(
      _config.rocketLifeMin,
      _config.rocketLifeMax,
      _random.nextDouble(),
    );
    final x = _randomInRange(0, _size.width);
    final y = _size.height + size + _randomInRange(0, _size.height * 0.15);
    final dx = _randomInRange(-_config.rocketDrift, _config.rocketDrift);

    particle.reset(
      position: Offset(x, y),
      velocity: Offset(dx, -speed),
      size: size,
      rotation: 0,
      rotationSpeed: 0,
      color: style.color,
      opacity: style.opacity,
      shape: ParticleShape.circle,
      kind: ParticleKind.rocket,
      life: life,
      maxLife: life,
    );
  }

  void _burst(Offset origin) {
    final min = _config.sparksPerBurstMin;
    final max = _config.sparksPerBurstMax;
    final count = _randomInRangeInt(min, max);
    var spawned = 0;

    for (final particle in _particles) {
      if (particle.active) {
        continue;
      }
      _spawnSpark(particle, origin);
      spawned += 1;
      if (spawned >= count) {
        break;
      }
    }
  }

  void _spawnSpark(Particle particle, Offset origin) {
    final style = _config.styles[_random.nextInt(_config.styles.length)];
    final speed = _lerp(
          _config.sparkMinSpeed,
          _config.sparkMaxSpeed,
          _random.nextDouble(),
        ) *
        _config.speedMultiplier;
    final angle = _random.nextDouble() * math.pi * 2;
    final life = _lerp(
      _config.sparkLifeMin,
      _config.sparkLifeMax,
      _random.nextDouble(),
    );
    final size = _lerp(
      _config.sparkMinSize,
      _config.sparkMaxSize,
      _random.nextDouble(),
    );

    particle.reset(
      position: origin,
      velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed),
      size: size,
      rotation: angle,
      rotationSpeed: 0,
      color: style.color,
      opacity: style.opacity,
      shape: ParticleShape.line,
      kind: ParticleKind.spark,
      life: life,
      maxLife: life,
    );
  }

  Offset _randomSparkOrigin() {
    final x = _randomInRange(0, _size.width);
    final y = _randomInRange(_size.height * 0.1, _size.height * 0.6);
    return Offset(x, y);
  }

  double _randomInRange(double min, double max) {
    if (max <= min) {
      return min;
    }
    return min + _random.nextDouble() * (max - min);
  }

  int _randomInRangeInt(int min, int max) {
    if (max <= min) {
      return min;
    }
    return min + _random.nextInt(max - min + 1);
  }

  double _lerp(double min, double max, double t) {
    return min + (max - min) * t;
  }

  double _randomSigned(double value) {
    if (value == 0) {
      return 0;
    }
    return _random.nextBool() ? value : -value;
  }
}
