import 'package:flutter/widgets.dart';
import '../config/decor_config.dart';
import 'seasonal_mode.dart';

/// Extra backdrop atmosphere details layered behind preset backdrops.
class BackdropSceneSpec {
  /// Base gradient anchors from top to bottom.
  final List<Color> gradientAnchors;

  /// Accent glow color.
  final Color glowColor;

  /// Optional vignette color.
  final Color vignetteColor;

  /// Center of the glow.
  final Alignment glowAlignment;

  /// Relative glow radius.
  final double glowRadius;

  /// Slow drift cycle duration.
  final Duration gradientDrift;

  /// Glow pulse cycle duration.
  final Duration glowPulse;

  const BackdropSceneSpec({
    required this.gradientAnchors,
    required this.glowColor,
    required this.vignetteColor,
    required this.glowAlignment,
    required this.glowRadius,
    required this.gradientDrift,
    required this.glowPulse,
  });
}

/// Layer profile for ambient particle depth/parallax.
class AmbientLayerSpec {
  /// Fraction of total particle budget assigned to this layer.
  final double countRatio;

  /// Speed multiplier for this depth layer.
  final double speedFactor;

  /// Relative opacity multiplier for this layer.
  final double opacityFactor;

  /// Relative scale for particle sizes in this layer.
  final double sizeFactor;

  /// Horizontal sway amplitude in pixels.
  final double swayAmplitude;

  /// Horizontal sway frequency in hertz.
  final double swayFrequency;

  /// Lower value means higher quality priority when frame skipping is needed.
  final int qualityPriority;

  const AmbientLayerSpec({
    required this.countRatio,
    required this.speedFactor,
    required this.opacityFactor,
    required this.sizeFactor,
    required this.swayAmplitude,
    required this.swayFrequency,
    required this.qualityPriority,
  });
}

/// Defines scene transition timings.
class SceneTransitionSpec {
  final Duration backdropFadeIn;
  final Duration ambientRampIn;
  final Duration spawnRampOut;
  final Duration settleOut;
  final Duration backdropFadeOut;

  const SceneTransitionSpec({
    required this.backdropFadeIn,
    required this.ambientRampIn,
    required this.spawnRampOut,
    required this.settleOut,
    required this.backdropFadeOut,
  });
}

/// Visual family used for a moment burst.
enum MomentVisualStyle {
  sparkle,
  confetti,
  firework,
  ringSpark,
}

/// Runtime spec for a short-lived moment effect.
class MomentSpec {
  final SeasonalMoment moment;
  final Duration duration;
  final int particleCount;
  final double minSpeed;
  final double maxSpeed;
  final double minSize;
  final double maxSize;
  final MomentVisualStyle style;

  const MomentSpec({
    required this.moment,
    required this.duration,
    required this.particleCount,
    required this.minSpeed,
    required this.maxSpeed,
    required this.minSize,
    required this.maxSize,
    required this.style,
  });
}

/// Full scene definition for a preset family.
class SceneSpec {
  final String id;
  final BackdropSceneSpec backdrop;
  final List<AmbientLayerSpec> ambientLayers;
  final SceneTransitionSpec transition;
  final Map<SeasonalMoment, MomentSpec> moments;
  final Set<SeasonalMoment> supportedMoments;
  final SeasonalMoment fireworksFallback;

  /// Optional fixed backdrop alpha multiplier for legacy preset backdrops.
  final double legacyBackdropAlpha;

  /// Optional backdrop type overlay for this scene.
  final BackdropType? hintBackdropType;

  const SceneSpec({
    required this.id,
    required this.backdrop,
    required this.ambientLayers,
    required this.transition,
    required this.moments,
    required this.supportedMoments,
    required this.fireworksFallback,
    this.legacyBackdropAlpha = 1.0,
    this.hintBackdropType,
  });

  SeasonalMoment resolveMoment(SeasonalMoment input) {
    if (supportedMoments.contains(input)) {
      return input;
    }
    if (input == SeasonalMoment.fireworksBurst) {
      return fireworksFallback;
    }
    if (supportedMoments.contains(SeasonalMoment.greetingBurst)) {
      return SeasonalMoment.greetingBurst;
    }
    return supportedMoments.first;
  }
}
