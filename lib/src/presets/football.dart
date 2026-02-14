import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the football preset.
enum FootballVariant {
  /// Classic football visual style.
  worldCup,
}

/// Builds the base configuration for football overlays.
DecorConfig buildFootballConfig(FootballVariant _) {
  final ballPalette = const [
    Color(0xFFFFFFFF),
    Color(0xFF111827),
  ];

  final styles = <ParticleStyle>[
    for (final color in ballPalette)
      ParticleStyle(
        shape: ParticleShape.ball,
        color: color,
        minSize: 4.6,
        maxSize: 8.6,
        minSpeed: 9,
        maxSpeed: 19,
        minRotationSpeed: -0.9,
        maxRotationSpeed: 0.9,
        opacity: 0.95,
      ),
  ];

  return DecorConfig(
    particleCount: 120,
    speedMultiplier: 1.0,
    spawnRate: 1,
    spawnRateScale: 0.7,
    drift: 14,
    flow: ParticleFlow.falling,
    wrapMode: DecorWrapMode.respawn,
    styles: styles,
    backdrops: const [
      DecorBackdrop.football(
        color: Color(0xFFF5F5F5),
        opacity: 0.28,
        anchor: Offset(0.84, 0.22),
        sizeFactor: 0.2,
      ),
    ],
  );
}
