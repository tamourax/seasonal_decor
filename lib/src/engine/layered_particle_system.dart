import 'dart:math' as math;
import 'dart:ui';

import '../config/decor_config.dart';
import '../scene/scene_spec.dart';
import '../scene/seasonal_mode.dart';
import 'particle_system.dart';

/// Runtime layer binding with its particle system and tuned config.
class AmbientLayerRuntime {
  final AmbientLayerSpec spec;
  final DecorConfig config;
  final ParticleSystem system;

  const AmbientLayerRuntime({
    required this.spec,
    required this.config,
    required this.system,
  });
}

/// Three-layer ambient particle system for parallax depth.
class LayeredParticleSystem {
  final DecorConfig _baseConfig;
  final SceneSpec _sceneSpec;
  final SeasonalMode _mode;
  final bool _reduceMotion;
  final Size _size;
  final List<AmbientLayerRuntime> _layers;

  factory LayeredParticleSystem({
    required DecorConfig baseConfig,
    required SceneSpec sceneSpec,
    required SeasonalMode mode,
    required bool reduceMotion,
    required Size size,
  }) {
    final layers = <AmbientLayerRuntime>[];
    final modeCountScale = mode == SeasonalMode.ambient ? 0.88 : 1.08;
    final modeSpeedScale = mode == SeasonalMode.ambient ? 0.92 : 1.14;
    final motionCountScale = reduceMotion ? 0.45 : 1.0;
    final motionSpeedScale = reduceMotion ? 0.4 : 1.0;

    for (final layerSpec in sceneSpec.ambientLayers) {
      final count = math.max(
        6,
        (baseConfig.particleCount *
                layerSpec.countRatio *
                modeCountScale *
                motionCountScale)
            .round(),
      );
      final styles = [
        for (final style in baseConfig.styles)
          style.copyWith(
            minSize: style.minSize * layerSpec.sizeFactor,
            maxSize: style.maxSize * layerSpec.sizeFactor,
            minSpeed: style.minSpeed *
                layerSpec.speedFactor *
                modeSpeedScale *
                motionSpeedScale,
            maxSpeed: style.maxSpeed *
                layerSpec.speedFactor *
                modeSpeedScale *
                motionSpeedScale,
            opacity: (style.opacity * layerSpec.opacityFactor)
                .clamp(0.0, 1.0)
                .toDouble(),
          ),
      ];
      final config = baseConfig.copyWith(
        particleCount: count,
        styles: styles,
        enableFireworks: false,
        spawnRate: baseConfig.spawnRate * layerSpec.countRatio * modeCountScale,
      );
      layers.add(
        AmbientLayerRuntime(
          spec: layerSpec,
          config: config,
          system: ParticleSystem(config: config, size: size),
        ),
      );
    }

    return LayeredParticleSystem._(
      baseConfig: baseConfig,
      sceneSpec: sceneSpec,
      mode: mode,
      reduceMotion: reduceMotion,
      size: size,
      layers: layers,
    );
  }

  LayeredParticleSystem._({
    required DecorConfig baseConfig,
    required SceneSpec sceneSpec,
    required SeasonalMode mode,
    required bool reduceMotion,
    required Size size,
    required List<AmbientLayerRuntime> layers,
  })  : _baseConfig = baseConfig,
        _sceneSpec = sceneSpec,
        _mode = mode,
        _reduceMotion = reduceMotion,
        _size = size,
        _layers = layers;

  DecorConfig get baseConfig => _baseConfig;
  SceneSpec get sceneSpec => _sceneSpec;
  SeasonalMode get mode => _mode;
  bool get reduceMotion => _reduceMotion;
  Size get size => _size;
  List<AmbientLayerRuntime> get layers => _layers;

  bool get hasActiveParticles {
    for (final layer in _layers) {
      if (layer.system.hasActiveParticles) {
        return true;
      }
    }
    return false;
  }

  void setBounds(Size size) {
    for (final layer in _layers) {
      layer.system.setBounds(size);
    }
  }

  void setDensityScale(double scale) {
    for (final layer in _layers) {
      layer.system.setDensityScale(scale);
    }
  }

  void setSpawningEnabled(bool enabled) {
    for (final layer in _layers) {
      layer.system.setSpawningEnabled(enabled);
    }
  }

  void setWrapEnabled(bool enabled) {
    for (final layer in _layers) {
      layer.system.setWrapEnabled(enabled);
    }
  }

  void update(double dt) {
    for (final layer in _layers) {
      layer.system.update(dt);
    }
  }
}
