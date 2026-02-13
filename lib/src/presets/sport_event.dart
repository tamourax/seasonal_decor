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
  final hasTeamColors =
      variant == SportEventVariant.teamColors && palette.isNotEmpty;
  final confettiColors = palette.length > 2 ? palette.take(2).toList() : palette;
  final ballPalette = hasTeamColors
      ? palette
      : const [
          Color(0xFFFFFFFF),
          Color(0xFF111827),
        ];
  final sparkleColor = hasTeamColors ? palette.first : const Color(0xFFFFD166);

  final styles = <ParticleStyle>[
    for (final color in confettiColors)
      ParticleStyle(
        shape: ParticleShape.confettiRect,
        color: color,
        minSize: 2.6,
        maxSize: 5.2,
        minSpeed: 18,
        maxSpeed: 40,
        minRotationSpeed: -2.2,
        maxRotationSpeed: 2.2,
        opacity: 0.75,
      ),
    ParticleStyle(
      shape: ParticleShape.sparkle,
      color: sparkleColor,
      minSize: 2.0,
      maxSize: 3.6,
      minSpeed: 8,
      maxSpeed: 16,
      minRotationSpeed: -1.4,
      maxRotationSpeed: 1.4,
      opacity: 0.7,
    ),
    for (final color in ballPalette)
      ParticleStyle(
        shape: ParticleShape.ball,
        color: color,
        minSize: 3.4,
        maxSize: 6.0,
        minSpeed: 10,
        maxSpeed: 22,
        minRotationSpeed: -0.6,
        maxRotationSpeed: 0.6,
        opacity: 0.9,
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
    enableFireworks: true,
    rocketsMax: 3,
    rocketSpawnRate: 0.55,
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
