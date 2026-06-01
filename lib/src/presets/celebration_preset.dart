import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../config/decor_config.dart';
import '../config/intensity.dart';
import '../engine/particle.dart';

/// Visual style profile for an action celebration.
enum CelebrationStyle {
  /// Minimal and calm visual effect.
  subtle,

  /// Balanced celebratory effect.
  standard,

  /// Rich celebratory effect.
  premium,

  /// Strongest celebratory effect.
  epic,
}

/// Ready-to-use one-shot preset for in-app action celebrations.
@immutable
class CelebrationPreset {
  final String name;
  final CelebrationStyle style;
  final DecorConfig baseConfig;
  final String _defaultText;
  final Duration _defaultPlayDuration;

  /// Optional custom text for this celebration.
  final String? text;

  /// Optional intensity override.
  final DecorIntensity? intensity;

  /// Optional play-duration override.
  final Duration? playDuration;

  /// Optional backdrop visibility override for this celebration.
  final bool? showBackdrop;

  /// Optional opacity override for this celebration.
  final double? opacity;

  const CelebrationPreset._({
    required this.name,
    required this.style,
    required this.baseConfig,
    required String defaultText,
    required Duration defaultPlayDuration,
    this.text,
    this.intensity,
    this.playDuration,
    this.showBackdrop,
    this.opacity,
  })  : _defaultText = defaultText,
        _defaultPlayDuration = defaultPlayDuration;

  /// Action preset: payment success.
  factory CelebrationPreset.paymentSuccess({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Payment Success',
      style: CelebrationStyle.subtle,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.subtle,
        shapes: const [
          ParticleShape.check,
          ParticleShape.coin,
          ParticleShape.sparkle,
        ],
        colors: const [
          Color(0xFF16A34A),
          Color(0xFFEAB308),
          Color(0xFFFFFFFF),
        ],
      ),
      defaultText: 'Payment successful',
      defaultPlayDuration: const Duration(seconds: 3),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: money transfer success.
  factory CelebrationPreset.moneyTransferSuccess({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Transfer Success',
      style: CelebrationStyle.subtle,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.subtle,
        shapes: const [
          ParticleShape.money,
          ParticleShape.coin,
          ParticleShape.check,
        ],
        colors: const [
          Color(0xFF0F766E),
          Color(0xFFCA8A04),
          Color(0xFF16A34A),
        ],
      ),
      defaultText: 'Transfer completed',
      defaultPlayDuration: const Duration(seconds: 3),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: purchase success.
  factory CelebrationPreset.purchaseSuccess({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Purchase Success',
      style: CelebrationStyle.standard,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.standard,
        shapes: const [
          ParticleShape.ticket,
          ParticleShape.coin,
          ParticleShape.sparkle,
        ],
        colors: const [
          Color(0xFFF97316),
          Color(0xFFEAB308),
          Color(0xFFFFFFFF),
        ],
      ),
      defaultText: 'Purchase complete',
      defaultPlayDuration: const Duration(seconds: 4),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: booking completed.
  factory CelebrationPreset.bookingCompleted({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Booking Completed',
      style: CelebrationStyle.standard,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.standard,
        shapes: const [
          ParticleShape.calendar,
          ParticleShape.check,
          ParticleShape.star,
        ],
        colors: const [
          Color(0xFF2563EB),
          Color(0xFF16A34A),
          Color(0xFF60A5FA),
        ],
      ),
      defaultText: 'Booking confirmed',
      defaultPlayDuration: const Duration(seconds: 4),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: appointment confirmed.
  factory CelebrationPreset.appointmentConfirmed({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Appointment Confirmed',
      style: CelebrationStyle.standard,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.standard,
        shapes: const [
          ParticleShape.calendar,
          ParticleShape.check,
          ParticleShape.sparkle,
        ],
        colors: const [
          Color(0xFF0EA5E9),
          Color(0xFF16A34A),
          Color(0xFFE2E8F0),
        ],
      ),
      defaultText: 'Appointment confirmed',
      defaultPlayDuration: const Duration(seconds: 4),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: account created.
  factory CelebrationPreset.accountCreated({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Account Created',
      style: CelebrationStyle.standard,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.standard,
        shapes: const [
          ParticleShape.badge,
          ParticleShape.star,
          ParticleShape.sparkle,
        ],
        colors: const [
          Color(0xFF0284C7),
          Color(0xFFF59E0B),
          Color(0xFFFFFFFF),
        ],
      ),
      defaultText: 'Welcome!',
      defaultPlayDuration: const Duration(seconds: 4),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: reward claimed.
  factory CelebrationPreset.rewardClaimed({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Reward Claimed',
      style: CelebrationStyle.premium,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.premium,
        shapes: const [
          ParticleShape.gift,
          ParticleShape.coin,
          ParticleShape.medal,
        ],
        colors: const [
          Color(0xFFEA580C),
          Color(0xFFEAB308),
          Color(0xFF7C3AED),
        ],
      ),
      defaultText: 'Reward claimed',
      defaultPlayDuration: const Duration(seconds: 5),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: achievement unlocked.
  factory CelebrationPreset.achievementUnlocked({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Achievement Unlocked',
      style: CelebrationStyle.premium,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.premium,
        shapes: const [
          ParticleShape.trophy,
          ParticleShape.medal,
          ParticleShape.star,
        ],
        colors: const [
          Color(0xFF7C3AED),
          Color(0xFFF59E0B),
          Color(0xFFFACC15),
        ],
      ),
      defaultText: 'Achievement unlocked!',
      defaultPlayDuration: const Duration(seconds: 5),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: goal reached.
  factory CelebrationPreset.goalReached({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Goal Reached',
      style: CelebrationStyle.premium,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.premium,
        shapes: const [
          ParticleShape.target,
          ParticleShape.check,
          ParticleShape.star,
        ],
        colors: const [
          Color(0xFF0EA5E9),
          Color(0xFF16A34A),
          Color(0xFFFACC15),
        ],
      ),
      defaultText: 'Goal reached',
      defaultPlayDuration: const Duration(seconds: 5),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Action preset: milestone reached.
  factory CelebrationPreset.milestoneReached({
    String? text,
    DecorIntensity? intensity,
    Duration? playDuration,
    bool? showBackdrop,
    double? opacity,
  }) {
    return CelebrationPreset._(
      name: 'Milestone Reached',
      style: CelebrationStyle.epic,
      baseConfig: _buildActionConfig(
        style: CelebrationStyle.epic,
        shapes: const [
          ParticleShape.trophy,
          ParticleShape.badge,
          ParticleShape.star,
        ],
        colors: const [
          Color(0xFFF97316),
          Color(0xFF2563EB),
          Color(0xFFFACC15),
        ],
      ).copyWith(
        enableFireworks: true,
        rocketsMax: 4,
        rocketSpawnRate: 1.0,
        sparksPerBurstMin: 14,
        sparksPerBurstMax: 30,
        burstHeightFactor: 0.2,
        gravityY: 80,
      ),
      defaultText: 'Milestone reached',
      defaultPlayDuration: const Duration(seconds: 6),
      text: text,
      intensity: intensity,
      playDuration: playDuration,
      showBackdrop: showBackdrop,
      opacity: opacity,
    );
  }

  /// Resolved text for rendering.
  String get resolvedText {
    final custom = text?.trim();
    if (custom == null || custom.isEmpty) {
      return _defaultText;
    }
    return custom;
  }

  /// Resolved duration for playback.
  Duration get resolvedPlayDuration => playDuration ?? _defaultPlayDuration;

  /// Resolved intensity profile.
  DecorIntensity get resolvedIntensity => intensity ?? DecorIntensity.max;

  /// Resolved backdrop visibility.
  bool get resolvedShowBackdrop => showBackdrop ?? false;

  /// Resolves this preset to a fully expanded [DecorConfig].
  DecorConfig resolve() {
    final profile = resolvedIntensity.profile;
    final resolved = baseConfig.copyWith(
      particleCount: profile.particleCount,
      speedMultiplier: baseConfig.speedMultiplier * profile.speedMultiplier,
      spawnRate: profile.spawnRate * baseConfig.spawnRateScale,
      // Celebrations are overlay-only with no scene backdrops.
      backdrop: null,
      backdrops: const <DecorBackdrop>[],
    );
    if (!resolved.enableFireworks) {
      return resolved;
    }
    final burstScale = profile.speedMultiplier;
    return resolved.copyWith(
      rocketSpawnRate: resolved.rocketSpawnRate * profile.speedMultiplier,
      sparksPerBurstMin: (resolved.sparksPerBurstMin * burstScale)
          .round()
          .clamp(6, 120)
          .toInt(),
      sparksPerBurstMax: (resolved.sparksPerBurstMax * burstScale)
          .round()
          .clamp(8, 160)
          .toInt(),
      backdrop: null,
      backdrops: const <DecorBackdrop>[],
    );
  }
}

DecorConfig _buildActionConfig({
  required CelebrationStyle style,
  required List<ParticleShape> shapes,
  required List<Color> colors,
}) {
  final base = switch (style) {
    CelebrationStyle.subtle => const (
        particleCount: 64,
        speedMultiplier: 1.08,
        spawnRate: 34.0,
        spawnRateScale: 1.08,
        drift: 16.0,
      ),
    CelebrationStyle.standard => const (
        particleCount: 84,
        speedMultiplier: 1.2,
        spawnRate: 42.0,
        spawnRateScale: 1.2,
        drift: 20.0,
      ),
    CelebrationStyle.premium => const (
        particleCount: 104,
        speedMultiplier: 1.34,
        spawnRate: 52.0,
        spawnRateScale: 1.3,
        drift: 24.0,
      ),
    CelebrationStyle.epic => const (
        particleCount: 128,
        speedMultiplier: 1.5,
        spawnRate: 64.0,
        spawnRateScale: 1.4,
        drift: 28.0,
      ),
  };

  final styles = <ParticleStyle>[];
  for (var i = 0; i < shapes.length; i += 1) {
    final shape = shapes[i];
    final color = colors[i % colors.length];
    styles.add(
      ParticleStyle(
        shape: shape,
        color: color,
        minSize: _sizeMin(shape),
        maxSize: _sizeMax(shape),
        minSpeed: _speedMin(shape, style),
        maxSpeed: _speedMax(shape, style),
        minRotationSpeed: _rotationMin(shape),
        maxRotationSpeed: _rotationMax(shape),
        opacity: _opacity(shape),
      ),
    );
  }

  return DecorConfig(
    particleCount: base.particleCount,
    speedMultiplier: base.speedMultiplier,
    spawnRate: base.spawnRate,
    spawnRateScale: base.spawnRateScale,
    drift: base.drift,
    flow: ParticleFlow.falling,
    wrapMode: DecorWrapMode.respawn,
    styles: styles,
    backdrop: null,
    backdrops: const <DecorBackdrop>[],
    enableFireworks: false,
  );
}

double _sizeMin(ParticleShape shape) {
  switch (shape) {
    case ParticleShape.coin:
    case ParticleShape.money:
    case ParticleShape.check:
    case ParticleShape.calendar:
    case ParticleShape.trophy:
    case ParticleShape.target:
    case ParticleShape.medal:
    case ParticleShape.badge:
    case ParticleShape.ticket:
    case ParticleShape.gift:
      return 3.2;
    case ParticleShape.sparkle:
    case ParticleShape.star:
      return 1.8;
    default:
      return 2.2;
  }
}

double _sizeMax(ParticleShape shape) {
  switch (shape) {
    case ParticleShape.coin:
    case ParticleShape.money:
    case ParticleShape.check:
    case ParticleShape.calendar:
    case ParticleShape.trophy:
    case ParticleShape.target:
    case ParticleShape.medal:
    case ParticleShape.badge:
    case ParticleShape.ticket:
    case ParticleShape.gift:
      return 7.2;
    case ParticleShape.sparkle:
    case ParticleShape.star:
      return 4.0;
    default:
      return 4.8;
  }
}

double _speedMin(ParticleShape shape, CelebrationStyle style) {
  final base = switch (style) {
    CelebrationStyle.subtle => 22.0,
    CelebrationStyle.standard => 28.0,
    CelebrationStyle.premium => 34.0,
    CelebrationStyle.epic => 40.0,
  };
  switch (shape) {
    case ParticleShape.sparkle:
    case ParticleShape.star:
      return base;
    default:
      return base - 3;
  }
}

double _speedMax(ParticleShape shape, CelebrationStyle style) {
  final base = switch (style) {
    CelebrationStyle.subtle => 40.0,
    CelebrationStyle.standard => 50.0,
    CelebrationStyle.premium => 62.0,
    CelebrationStyle.epic => 74.0,
  };
  switch (shape) {
    case ParticleShape.sparkle:
    case ParticleShape.star:
      return base;
    default:
      return base - 5;
  }
}

double _rotationMin(ParticleShape shape) {
  switch (shape) {
    case ParticleShape.check:
      return -0.35;
    case ParticleShape.coin:
    case ParticleShape.money:
    case ParticleShape.calendar:
    case ParticleShape.trophy:
    case ParticleShape.target:
    case ParticleShape.medal:
    case ParticleShape.badge:
    case ParticleShape.ticket:
    case ParticleShape.gift:
      return -1.2;
    case ParticleShape.sparkle:
    case ParticleShape.star:
      return -1.5;
    default:
      return -0.8;
  }
}

double _rotationMax(ParticleShape shape) {
  switch (shape) {
    case ParticleShape.check:
      return 0.35;
    case ParticleShape.coin:
    case ParticleShape.money:
    case ParticleShape.calendar:
    case ParticleShape.trophy:
    case ParticleShape.target:
    case ParticleShape.medal:
    case ParticleShape.badge:
    case ParticleShape.ticket:
    case ParticleShape.gift:
      return 1.2;
    case ParticleShape.sparkle:
    case ParticleShape.star:
      return 1.5;
    default:
      return 0.8;
  }
}

double _opacity(ParticleShape shape) {
  switch (shape) {
    case ParticleShape.sparkle:
      return 0.82;
    case ParticleShape.star:
      return 0.7;
    default:
      return 0.92;
  }
}
