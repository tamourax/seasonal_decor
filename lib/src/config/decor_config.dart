import 'dart:ui';

import '../engine/particle.dart';

/// Particle motion patterns.
enum ParticleFlow {
  /// Particles fall downward with gentle horizontal drift.
  falling,

  /// Particles float in random directions.
  floating,
}

/// How particles behave when leaving the visible bounds.
enum DecorWrapMode {
  /// Mark particles inactive and respawn them later.
  respawn,

  /// Wrap particles to the opposite edge.
  wrap,
}

/// Style information used when spawning particles.
class ParticleStyle {
  /// Shape to draw.
  final ParticleShape shape;

  /// Base color.
  final Color color;

  /// Minimum size in logical pixels.
  final double minSize;

  /// Maximum size in logical pixels.
  final double maxSize;

  /// Minimum speed in logical pixels per second.
  final double minSpeed;

  /// Maximum speed in logical pixels per second.
  final double maxSpeed;

  /// Minimum rotation speed in radians per second.
  final double minRotationSpeed;

  /// Maximum rotation speed in radians per second.
  final double maxRotationSpeed;

  /// Per-particle opacity multiplier.
  final double opacity;

  const ParticleStyle({
    required this.shape,
    required this.color,
    required this.minSize,
    required this.maxSize,
    required this.minSpeed,
    required this.maxSpeed,
    required this.minRotationSpeed,
    required this.maxRotationSpeed,
    this.opacity = 1.0,
  });
}

/// Decorative backdrop options.
enum BackdropType {
  /// A large crescent shape for Ramadan.
  crescent,
}

/// Background artwork drawn behind particles.
class DecorBackdrop {
  /// Backdrop type.
  final BackdropType type;

  /// Color used for the shape.
  final Color color;

  /// Opacity multiplier.
  final double opacity;

  /// Anchor point in normalized 0..1 coordinates.
  final Offset anchor;

  /// Size relative to the shortest side.
  final double sizeFactor;

  const DecorBackdrop({
    required this.type,
    required this.color,
    required this.opacity,
    required this.anchor,
    required this.sizeFactor,
  });

  /// Convenience constructor for a crescent backdrop.
  const DecorBackdrop.crescent({
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.crescent,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );
}

/// Configuration for a seasonal decorative overlay.
class DecorConfig {
  /// Base particle count (before adaptive density scaling).
  final int particleCount;

  /// Global speed multiplier applied to particle velocity.
  final double speedMultiplier;

  /// Maximum respawn rate (particles per second).
  final double spawnRate;

  /// Additional multiplier applied to intensity spawn rate values.
  final double spawnRateScale;

  /// Maximum horizontal drift for falling particles.
  final double drift;

  /// Particle movement pattern.
  final ParticleFlow flow;

  /// Behavior when particles leave the view bounds.
  final DecorWrapMode wrapMode;

  /// Particle style palette.
  final List<ParticleStyle> styles;

  /// Optional decorative backdrop.
  final DecorBackdrop? backdrop;

  const DecorConfig({
    required this.particleCount,
    required this.speedMultiplier,
    required this.spawnRate,
    required this.spawnRateScale,
    required this.drift,
    required this.flow,
    required this.wrapMode,
    required this.styles,
    this.backdrop,
  });

  /// Returns a copy with updated values.
  DecorConfig copyWith({
    int? particleCount,
    double? speedMultiplier,
    double? spawnRate,
    double? spawnRateScale,
    double? drift,
    ParticleFlow? flow,
    DecorWrapMode? wrapMode,
    List<ParticleStyle>? styles,
    DecorBackdrop? backdrop,
  }) {
    return DecorConfig(
      particleCount: particleCount ?? this.particleCount,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      spawnRate: spawnRate ?? this.spawnRate,
      spawnRateScale: spawnRateScale ?? this.spawnRateScale,
      drift: drift ?? this.drift,
      flow: flow ?? this.flow,
      wrapMode: wrapMode ?? this.wrapMode,
      styles: styles ?? this.styles,
      backdrop: backdrop ?? this.backdrop,
    );
  }
}
