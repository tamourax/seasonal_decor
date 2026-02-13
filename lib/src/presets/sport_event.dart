import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the sport event preset.
enum SportEventVariant {
  /// Global celebration palette.
  worldCup,

  /// Uses provided team colors.
  teamColors,
}

/// Builds the base configuration for sport event overlays.
DecorConfig buildSportEventConfig(
  SportEventVariant variant, {
  List<Color>? teamColors,
}) {
  final palette = _resolvePalette(variant, teamColors);

  final styles = <ParticleStyle>[
    for (final color in palette)
      ParticleStyle(
        shape: ParticleShape.confettiRect,
        color: color,
        minSize: 2.8,
        maxSize: 6.0,
        minSpeed: 18,
        maxSpeed: 42,
        minRotationSpeed: -2.4,
        maxRotationSpeed: 2.4,
        opacity: 0.9,
      ),
    ParticleStyle(
      shape: ParticleShape.sparkle,
      color: palette.first,
      minSize: 2.0,
      maxSize: 3.6,
      minSpeed: 8,
      maxSpeed: 18,
      minRotationSpeed: -1.4,
      maxRotationSpeed: 1.4,
      opacity: 0.7,
    ),
  ];

  return DecorConfig(
    particleCount: 120,
    speedMultiplier: 1.0,
    spawnRate: 1,
    spawnRateScale: 0.85,
    drift: 16,
    flow: ParticleFlow.falling,
    wrapMode: DecorWrapMode.respawn,
    enableFireworks: true,
    rocketsMax: 3,
    rocketSpawnRate: 0.5,
    sparksPerBurstMin: 18,
    sparksPerBurstMax: 30,
    burstHeightFactor: 0.22,
    gravityY: 85,
    rocketMinSpeed: 210,
    rocketMaxSpeed: 280,
    rocketLifeMin: 0.9,
    rocketLifeMax: 1.4,
    rocketSize: 3.0,
    rocketDrift: 22,
    sparkMinSpeed: 70,
    sparkMaxSpeed: 180,
    sparkLifeMin: 0.7,
    sparkLifeMax: 1.2,
    sparkMinSize: 6.0,
    sparkMaxSize: 12.0,
    styles: styles,
    backdrops: const [
      DecorBackdrop.trophy(
        color: Color(0xFFFFD166),
        opacity: 0.22,
        anchor: Offset(0.5, 0.18),
        sizeFactor: 0.18,
      ),
    ],
  );
}

List<Color> _resolvePalette(
  SportEventVariant variant,
  List<Color>? teamColors,
) {
  if (variant == SportEventVariant.teamColors) {
    final resolved = teamColors ?? const [];
    if (resolved.isNotEmpty) {
      return List<Color>.from(resolved);
    }
  }
  return const [
    Color(0xFF00B86B),
    Color(0xFFFFFFFF),
    Color(0xFFFFD166),
    Color(0xFF4D96FF),
    Color(0xFFF94144),
  ];
}
