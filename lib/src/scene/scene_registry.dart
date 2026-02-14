import 'package:flutter/widgets.dart';
import '../presets/seasonal_preset.dart';
import 'scene_spec.dart';
import 'seasonal_mode.dart';

/// Catalog of supported scene definitions.
class SceneRegistry {
  static SceneSpec resolve(SeasonalPreset preset) {
    final normalizedName = preset.name.toLowerCase();
    if (normalizedName.contains('ramadan')) {
      return _ramadan;
    }
    if (normalizedName.contains('christmas')) {
      return _christmas;
    }
    if (normalizedName.contains('new year')) {
      return _newYear;
    }
    return _generic;
  }

  static List<Color> anchorsForPreset(SeasonalPreset preset) {
    final normalizedName = preset.name.toLowerCase();
    if (normalizedName.contains('ramadan')) {
      return const [
        Color(0xFF0E1B33),
        Color(0xFF124C5F),
        Color(0xFFD9B56D),
        Color(0xFFF7E8BD),
      ];
    }
    if (normalizedName.contains('christmas')) {
      return const [
        Color(0xFF0D3B2A),
        Color(0xFFB91C1C),
        Color(0xFFFFD98A),
        Color(0xFFF7FBFF),
      ];
    }
    if (normalizedName.contains('new year')) {
      return const [
        Color(0xFF090F24),
        Color(0xFF2D5BFF),
        Color(0xFFFFD166),
        Color(0xFFE6ECFF),
      ];
    }
    return const [
      Color(0xFF0D1B2A),
      Color(0xFF1B4965),
      Color(0xFF5FA8D3),
      Color(0xFFEAF4F4),
    ];
  }
}

const SceneSpec _ramadan = SceneSpec(
  id: 'ramadan',
  legacyBackdropAlpha: 0.92,
  backdrop: BackdropSceneSpec(
    gradientAnchors: [
      Color(0xFF0E1B33),
      Color(0xFF123744),
      Color(0xFF0A1320),
    ],
    glowColor: Color(0xFFF7E8BD),
    vignetteColor: Color(0xCC03060A),
    glowAlignment: Alignment(0.65, -0.72),
    glowRadius: 0.54,
    gradientDrift: Duration(seconds: 14),
    glowPulse: Duration(seconds: 8),
  ),
  ambientLayers: [
    AmbientLayerSpec(
      countRatio: 0.34,
      speedFactor: 0.62,
      opacityFactor: 0.55,
      sizeFactor: 0.82,
      swayAmplitude: 5.0,
      swayFrequency: 0.18,
      qualityPriority: 3,
    ),
    AmbientLayerSpec(
      countRatio: 0.36,
      speedFactor: 0.9,
      opacityFactor: 0.82,
      sizeFactor: 0.95,
      swayAmplitude: 8.0,
      swayFrequency: 0.24,
      qualityPriority: 2,
    ),
    AmbientLayerSpec(
      countRatio: 0.30,
      speedFactor: 1.18,
      opacityFactor: 1.0,
      sizeFactor: 1.08,
      swayAmplitude: 10.0,
      swayFrequency: 0.3,
      qualityPriority: 1,
    ),
  ],
  transition: SceneTransitionSpec(
    backdropFadeIn: Duration(milliseconds: 700),
    ambientRampIn: Duration(milliseconds: 1200),
    spawnRampOut: Duration(milliseconds: 300),
    settleOut: Duration(milliseconds: 900),
    backdropFadeOut: Duration(milliseconds: 450),
  ),
  moments: {
    SeasonalMoment.greetingBurst: MomentSpec(
      moment: SeasonalMoment.greetingBurst,
      duration: Duration(milliseconds: 1200),
      particleCount: 54,
      minSpeed: 44,
      maxSpeed: 156,
      minSize: 2.2,
      maxSize: 5.6,
      style: MomentVisualStyle.ringSpark,
    ),
    SeasonalMoment.successBurst: MomentSpec(
      moment: SeasonalMoment.successBurst,
      duration: Duration(milliseconds: 1000),
      particleCount: 42,
      minSpeed: 38,
      maxSpeed: 130,
      minSize: 2.0,
      maxSize: 4.8,
      style: MomentVisualStyle.sparkle,
    ),
    SeasonalMoment.subtleSparkle: MomentSpec(
      moment: SeasonalMoment.subtleSparkle,
      duration: Duration(milliseconds: 800),
      particleCount: 28,
      minSpeed: 20,
      maxSpeed: 72,
      minSize: 1.6,
      maxSize: 3.2,
      style: MomentVisualStyle.sparkle,
    ),
  },
  supportedMoments: {
    SeasonalMoment.greetingBurst,
    SeasonalMoment.successBurst,
    SeasonalMoment.subtleSparkle,
  },
  fireworksFallback: SeasonalMoment.subtleSparkle,
);

const SceneSpec _christmas = SceneSpec(
  id: 'christmas',
  legacyBackdropAlpha: 0.95,
  backdrop: BackdropSceneSpec(
    gradientAnchors: [
      Color(0xFF0D3B2A),
      Color(0xFF102B22),
      Color(0xFF07120D),
    ],
    glowColor: Color(0xFFFFD98A),
    vignetteColor: Color(0xCC050807),
    glowAlignment: Alignment(0.72, 0.62),
    glowRadius: 0.5,
    gradientDrift: Duration(seconds: 12),
    glowPulse: Duration(seconds: 6),
  ),
  ambientLayers: [
    AmbientLayerSpec(
      countRatio: 0.38,
      speedFactor: 0.58,
      opacityFactor: 0.52,
      sizeFactor: 0.92,
      swayAmplitude: 2.0,
      swayFrequency: 0.14,
      qualityPriority: 3,
    ),
    AmbientLayerSpec(
      countRatio: 0.34,
      speedFactor: 0.84,
      opacityFactor: 0.8,
      sizeFactor: 1.0,
      swayAmplitude: 4.0,
      swayFrequency: 0.2,
      qualityPriority: 2,
    ),
    AmbientLayerSpec(
      countRatio: 0.28,
      speedFactor: 1.12,
      opacityFactor: 0.94,
      sizeFactor: 1.08,
      swayAmplitude: 6.0,
      swayFrequency: 0.26,
      qualityPriority: 1,
    ),
  ],
  transition: SceneTransitionSpec(
    backdropFadeIn: Duration(milliseconds: 600),
    ambientRampIn: Duration(milliseconds: 900),
    spawnRampOut: Duration(milliseconds: 250),
    settleOut: Duration(milliseconds: 800),
    backdropFadeOut: Duration(milliseconds: 450),
  ),
  moments: {
    SeasonalMoment.greetingBurst: MomentSpec(
      moment: SeasonalMoment.greetingBurst,
      duration: Duration(milliseconds: 1400),
      particleCount: 68,
      minSpeed: 60,
      maxSpeed: 176,
      minSize: 2.0,
      maxSize: 5.4,
      style: MomentVisualStyle.confetti,
    ),
    SeasonalMoment.successBurst: MomentSpec(
      moment: SeasonalMoment.successBurst,
      duration: Duration(milliseconds: 1000),
      particleCount: 44,
      minSpeed: 45,
      maxSpeed: 145,
      minSize: 2.0,
      maxSize: 4.8,
      style: MomentVisualStyle.sparkle,
    ),
    SeasonalMoment.subtleSparkle: MomentSpec(
      moment: SeasonalMoment.subtleSparkle,
      duration: Duration(milliseconds: 900),
      particleCount: 34,
      minSpeed: 22,
      maxSpeed: 86,
      minSize: 1.8,
      maxSize: 3.6,
      style: MomentVisualStyle.sparkle,
    ),
  },
  supportedMoments: {
    SeasonalMoment.greetingBurst,
    SeasonalMoment.successBurst,
    SeasonalMoment.subtleSparkle,
  },
  fireworksFallback: SeasonalMoment.greetingBurst,
);

const SceneSpec _newYear = SceneSpec(
  id: 'new_year',
  legacyBackdropAlpha: 1.0,
  backdrop: BackdropSceneSpec(
    gradientAnchors: [
      Color(0xFF090F24),
      Color(0xFF131B36),
      Color(0xFF050A17),
    ],
    glowColor: Color(0xFFFFD166),
    vignetteColor: Color(0xCC01030A),
    glowAlignment: Alignment(0.0, -0.25),
    glowRadius: 0.62,
    gradientDrift: Duration(seconds: 5),
    glowPulse: Duration(seconds: 4),
  ),
  ambientLayers: [
    AmbientLayerSpec(
      countRatio: 0.34,
      speedFactor: 0.62,
      opacityFactor: 0.5,
      sizeFactor: 0.86,
      swayAmplitude: 4.0,
      swayFrequency: 0.18,
      qualityPriority: 3,
    ),
    AmbientLayerSpec(
      countRatio: 0.34,
      speedFactor: 0.94,
      opacityFactor: 0.76,
      sizeFactor: 1.0,
      swayAmplitude: 6.0,
      swayFrequency: 0.24,
      qualityPriority: 2,
    ),
    AmbientLayerSpec(
      countRatio: 0.32,
      speedFactor: 1.3,
      opacityFactor: 0.96,
      sizeFactor: 1.14,
      swayAmplitude: 8.0,
      swayFrequency: 0.3,
      qualityPriority: 1,
    ),
  ],
  transition: SceneTransitionSpec(
    backdropFadeIn: Duration(milliseconds: 500),
    ambientRampIn: Duration(milliseconds: 700),
    spawnRampOut: Duration(milliseconds: 250),
    settleOut: Duration(milliseconds: 700),
    backdropFadeOut: Duration(milliseconds: 420),
  ),
  moments: {
    SeasonalMoment.fireworksBurst: MomentSpec(
      moment: SeasonalMoment.fireworksBurst,
      duration: Duration(milliseconds: 2200),
      particleCount: 120,
      minSpeed: 92,
      maxSpeed: 280,
      minSize: 2.0,
      maxSize: 6.5,
      style: MomentVisualStyle.firework,
    ),
    SeasonalMoment.greetingBurst: MomentSpec(
      moment: SeasonalMoment.greetingBurst,
      duration: Duration(milliseconds: 1200),
      particleCount: 76,
      minSpeed: 66,
      maxSpeed: 180,
      minSize: 2.0,
      maxSize: 5.6,
      style: MomentVisualStyle.confetti,
    ),
    SeasonalMoment.successBurst: MomentSpec(
      moment: SeasonalMoment.successBurst,
      duration: Duration(milliseconds: 1000),
      particleCount: 48,
      minSpeed: 52,
      maxSpeed: 148,
      minSize: 1.8,
      maxSize: 4.8,
      style: MomentVisualStyle.sparkle,
    ),
    SeasonalMoment.subtleSparkle: MomentSpec(
      moment: SeasonalMoment.subtleSparkle,
      duration: Duration(milliseconds: 800),
      particleCount: 30,
      minSpeed: 24,
      maxSpeed: 90,
      minSize: 1.6,
      maxSize: 3.8,
      style: MomentVisualStyle.sparkle,
    ),
  },
  supportedMoments: {
    SeasonalMoment.fireworksBurst,
    SeasonalMoment.greetingBurst,
    SeasonalMoment.successBurst,
    SeasonalMoment.subtleSparkle,
  },
  fireworksFallback: SeasonalMoment.fireworksBurst,
);

const SceneSpec _generic = SceneSpec(
  id: 'generic',
  backdrop: BackdropSceneSpec(
    gradientAnchors: [
      Color(0xFF0D1B2A),
      Color(0xFF1B263B),
      Color(0xFF0A1525),
    ],
    glowColor: Color(0xFF8FB3FF),
    vignetteColor: Color(0xBF060A14),
    glowAlignment: Alignment(0.0, -0.6),
    glowRadius: 0.58,
    gradientDrift: Duration(seconds: 10),
    glowPulse: Duration(seconds: 7),
  ),
  ambientLayers: [
    AmbientLayerSpec(
      countRatio: 0.36,
      speedFactor: 0.64,
      opacityFactor: 0.56,
      sizeFactor: 0.9,
      swayAmplitude: 4.0,
      swayFrequency: 0.16,
      qualityPriority: 3,
    ),
    AmbientLayerSpec(
      countRatio: 0.34,
      speedFactor: 0.92,
      opacityFactor: 0.8,
      sizeFactor: 1.0,
      swayAmplitude: 6.0,
      swayFrequency: 0.22,
      qualityPriority: 2,
    ),
    AmbientLayerSpec(
      countRatio: 0.30,
      speedFactor: 1.2,
      opacityFactor: 0.95,
      sizeFactor: 1.08,
      swayAmplitude: 8.0,
      swayFrequency: 0.28,
      qualityPriority: 1,
    ),
  ],
  transition: SceneTransitionSpec(
    backdropFadeIn: Duration(milliseconds: 520),
    ambientRampIn: Duration(milliseconds: 820),
    spawnRampOut: Duration(milliseconds: 280),
    settleOut: Duration(milliseconds: 760),
    backdropFadeOut: Duration(milliseconds: 420),
  ),
  moments: {
    SeasonalMoment.greetingBurst: MomentSpec(
      moment: SeasonalMoment.greetingBurst,
      duration: Duration(milliseconds: 1200),
      particleCount: 60,
      minSpeed: 56,
      maxSpeed: 164,
      minSize: 2.0,
      maxSize: 5.4,
      style: MomentVisualStyle.confetti,
    ),
    SeasonalMoment.successBurst: MomentSpec(
      moment: SeasonalMoment.successBurst,
      duration: Duration(milliseconds: 1000),
      particleCount: 44,
      minSpeed: 42,
      maxSpeed: 138,
      minSize: 1.8,
      maxSize: 4.6,
      style: MomentVisualStyle.sparkle,
    ),
    SeasonalMoment.fireworksBurst: MomentSpec(
      moment: SeasonalMoment.fireworksBurst,
      duration: Duration(milliseconds: 1800),
      particleCount: 92,
      minSpeed: 82,
      maxSpeed: 250,
      minSize: 2.0,
      maxSize: 6.0,
      style: MomentVisualStyle.firework,
    ),
    SeasonalMoment.subtleSparkle: MomentSpec(
      moment: SeasonalMoment.subtleSparkle,
      duration: Duration(milliseconds: 850),
      particleCount: 28,
      minSpeed: 20,
      maxSpeed: 82,
      minSize: 1.6,
      maxSize: 3.6,
      style: MomentVisualStyle.sparkle,
    ),
  },
  supportedMoments: {
    SeasonalMoment.greetingBurst,
    SeasonalMoment.successBurst,
    SeasonalMoment.fireworksBurst,
    SeasonalMoment.subtleSparkle,
  },
  fireworksFallback: SeasonalMoment.fireworksBurst,
);
