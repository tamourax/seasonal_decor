import 'dart:ui';

import '../config/decor_config.dart';
import '../engine/particle.dart';

/// Variants for the Eid preset.
enum EidVariant {
  /// Eid al-Fitr (small Eid).
  fitr,

  /// Eid al-Adha (big Eid).
  adha,

  /// Legacy alias for Eid al-Fitr.
  classic,
}

/// Builds the base configuration for Eid overlays.
DecorConfig buildEidConfig(EidVariant variant) {
  switch (variant) {
    case EidVariant.classic:
    case EidVariant.fitr:
      return _buildEidFitr();
    case EidVariant.adha:
      return _buildEidAdha();
  }
}

DecorConfig _buildEidFitr() {
  return DecorConfig(
    particleCount: 100,
    speedMultiplier: 0.95,
    spawnRate: 1,
    spawnRateScale: 0.7,
    drift: 14,
    flow: ParticleFlow.falling,
    wrapMode: DecorWrapMode.respawn,
    enableFireworks: false,
    styles: const [
      ParticleStyle(
        shape: ParticleShape.balloon,
        color: Color(0xFFE11D48),
        minSize: 6.0,
        maxSize: 10.0,
        minSpeed: 12,
        maxSpeed: 24,
        minRotationSpeed: 0,
        maxRotationSpeed: 0,
        opacity: 0.95,
      ),
      ParticleStyle(
        shape: ParticleShape.balloon,
        color: Color(0xFF2563EB),
        minSize: 5.5,
        maxSize: 9.0,
        minSpeed: 12,
        maxSpeed: 22,
        minRotationSpeed: 0,
        maxRotationSpeed: 0,
        opacity: 0.9,
      ),
      ParticleStyle(
        shape: ParticleShape.balloon,
        color: Color(0xFFF59E0B),
        minSize: 5.0,
        maxSize: 8.5,
        minSpeed: 10,
        maxSpeed: 20,
        minRotationSpeed: 0,
        maxRotationSpeed: 0,
        opacity: 0.85,
      ),
    ],
    backdrops: const [
      DecorBackdrop.bunting(
        color: Color(0xFF94A3B8),
        opacity: 0.35,
        anchor: Offset(0.5, 0.12),
        sizeFactor: 0.08,
      ),
    ],
  );
}

DecorConfig _buildEidAdha() {
  return DecorConfig(
    particleCount: 110,
    speedMultiplier: 0.95,
    spawnRate: 1,
    spawnRateScale: 1.0,
    drift: 10,
    flow: ParticleFlow.falling,
    wrapMode: DecorWrapMode.respawn,
    enableFireworks: true,
    rocketsMax: 3,
    rocketSpawnRate: 0.9,
    sparksPerBurstMin: 18,
    sparksPerBurstMax: 30,
    burstHeightFactor: 0.2,
    gravityY: 85,
    rocketMinSpeed: 210,
    rocketMaxSpeed: 270,
    rocketLifeMin: 0.9,
    rocketLifeMax: 1.3,
    rocketSize: 3.0,
    rocketDrift: 22,
    sparkMinSpeed: 80,
    sparkMaxSpeed: 200,
    sparkLifeMin: 0.7,
    sparkLifeMax: 1.2,
    sparkMinSize: 6.0,
    sparkMaxSize: 12.0,
    styles: const [
      ParticleStyle(
        shape: ParticleShape.sheep,
        color: Color(0xFFF3F4F6),
        minSize: 7.0,
        maxSize: 12.0,
        minSpeed: 10,
        maxSpeed: 20,
        minRotationSpeed: -0.2,
        maxRotationSpeed: 0.2,
        opacity: 0.95,
      ),
      ParticleStyle(
        shape: ParticleShape.sheep,
        color: Color(0xFFFFFFFF),
        minSize: 6.0,
        maxSize: 10.0,
        minSpeed: 10,
        maxSpeed: 20,
        minRotationSpeed: -0.2,
        maxRotationSpeed: 0.2,
        opacity: 0.95,
      ),
      ParticleStyle(
        shape: ParticleShape.sheep,
        color: Color(0xFFF8FAFC),
        minSize: 8.0,
        maxSize: 13.0,
        minSpeed: 9,
        maxSpeed: 18,
        minRotationSpeed: -0.2,
        maxRotationSpeed: 0.2,
        opacity: 0.95,
      ),
      ParticleStyle(
        shape: ParticleShape.circle,
        color: Color(0xFFF9C74F),
        minSize: 2.0,
        maxSize: 4.0,
        minSpeed: 0,
        maxSpeed: 0,
        minRotationSpeed: 0,
        maxRotationSpeed: 0,
        opacity: 0.9,
      ),
      ParticleStyle(
        shape: ParticleShape.circle,
        color: Color(0xFFB8E3FF),
        minSize: 2.0,
        maxSize: 4.0,
        minSpeed: 0,
        maxSpeed: 0,
        minRotationSpeed: 0,
        maxRotationSpeed: 0,
        opacity: 0.85,
      ),
    ],
    backdrops: const [
      DecorBackdrop.mosque(
        color: Color(0xFF4A2B7C),
        opacity: 0.55,
        anchor: Offset(0.82, 0.22),
        sizeFactor: 0.5,
      ),
    ],
  );
}
