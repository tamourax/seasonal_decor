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

  /// Returns a copy with updated values.
  ParticleStyle copyWith({
    ParticleShape? shape,
    Color? color,
    double? minSize,
    double? maxSize,
    double? minSpeed,
    double? maxSpeed,
    double? minRotationSpeed,
    double? maxRotationSpeed,
    double? opacity,
  }) {
    return ParticleStyle(
      shape: shape ?? this.shape,
      color: color ?? this.color,
      minSize: minSize ?? this.minSize,
      maxSize: maxSize ?? this.maxSize,
      minSpeed: minSpeed ?? this.minSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      minRotationSpeed: minRotationSpeed ?? this.minRotationSpeed,
      maxRotationSpeed: maxRotationSpeed ?? this.maxRotationSpeed,
      opacity: opacity ?? this.opacity,
    );
  }
}

/// Decorative backdrop options.
enum BackdropType {
  /// A large crescent shape for Ramadan.
  crescent,

  /// A decorative evergreen tree.
  tree,

  /// A string of garland lights.
  garland,

  /// A string of candy canes with ornaments.
  candyGarland,

  /// A string of triangle bunting flags.
  bunting,

  /// A mosque silhouette.
  mosque,

  /// A trophy silhouette.
  trophy,

  /// A glowing lantern silhouette.
  lantern,

  /// Hanging Ramadan light strings with moon/star ornaments.
  ramadanLights,

  /// Traditional Ramadan khayamiya-style bunting strings.
  ramadanBunting,
}

/// Visual layer for backdrop artwork.
enum BackdropLayer {
  /// Backdrop art behind content emphasis (for example moon or skyline).
  background,

  /// Decorative overlay art (for example bunting/garland).
  decorative,
}

/// Background artwork drawn behind particles.
class DecorBackdrop {
  /// Backdrop type.
  final BackdropType type;

  /// Backdrop visual layer.
  final BackdropLayer layer;

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
    this.layer = BackdropLayer.decorative,
    required this.color,
    required this.opacity,
    required this.anchor,
    required this.sizeFactor,
  });

  /// Returns a copy with updated values.
  DecorBackdrop copyWith({
    BackdropType? type,
    BackdropLayer? layer,
    Color? color,
    double? opacity,
    Offset? anchor,
    double? sizeFactor,
  }) {
    return DecorBackdrop(
      type: type ?? this.type,
      layer: layer ?? this.layer,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      anchor: anchor ?? this.anchor,
      sizeFactor: sizeFactor ?? this.sizeFactor,
    );
  }

  /// Convenience constructor for a crescent backdrop.
  const DecorBackdrop.crescent({
    BackdropLayer layer = BackdropLayer.background,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.crescent,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a tree backdrop.
  const DecorBackdrop.tree({
    BackdropLayer layer = BackdropLayer.background,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.tree,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a garland backdrop.
  const DecorBackdrop.garland({
    BackdropLayer layer = BackdropLayer.decorative,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.garland,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a candy garland backdrop.
  const DecorBackdrop.candyGarland({
    BackdropLayer layer = BackdropLayer.decorative,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.candyGarland,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a bunting backdrop.
  const DecorBackdrop.bunting({
    BackdropLayer layer = BackdropLayer.decorative,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.bunting,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a mosque backdrop.
  const DecorBackdrop.mosque({
    BackdropLayer layer = BackdropLayer.background,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.mosque,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a trophy backdrop.
  const DecorBackdrop.trophy({
    BackdropLayer layer = BackdropLayer.background,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.trophy,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for a lantern backdrop.
  const DecorBackdrop.lantern({
    BackdropLayer layer = BackdropLayer.background,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.lantern,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for hanging Ramadan lights.
  const DecorBackdrop.ramadanLights({
    BackdropLayer layer = BackdropLayer.decorative,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.ramadanLights,
          layer: layer,
          color: color,
          opacity: opacity,
          anchor: anchor,
          sizeFactor: sizeFactor,
        );

  /// Convenience constructor for traditional Ramadan bunting.
  const DecorBackdrop.ramadanBunting({
    BackdropLayer layer = BackdropLayer.decorative,
    required Color color,
    required double opacity,
    required Offset anchor,
    required double sizeFactor,
  }) : this(
          type: BackdropType.ramadanBunting,
          layer: layer,
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

  /// Optional list of decorative backdrops.
  final List<DecorBackdrop> backdrops;

  /// Enables Eid-style fireworks behavior.
  final bool enableFireworks;

  /// Maximum number of rockets that can be active at once.
  final int rocketsMax;

  /// Rockets spawned per second.
  final double rocketSpawnRate;

  /// Minimum sparks per burst.
  final int sparksPerBurstMin;

  /// Maximum sparks per burst.
  final int sparksPerBurstMax;

  /// Burst height factor from the top of the screen (0..1).
  final double burstHeightFactor;

  /// Downward gravity applied to sparks.
  final double gravityY;

  /// Rocket speed range (logical px/sec).
  final double rocketMinSpeed;
  final double rocketMaxSpeed;

  /// Rocket life range (seconds).
  final double rocketLifeMin;
  final double rocketLifeMax;

  /// Rocket visual size.
  final double rocketSize;

  /// Horizontal drift for rockets.
  final double rocketDrift;

  /// Spark speed range (logical px/sec).
  final double sparkMinSpeed;
  final double sparkMaxSpeed;

  /// Spark life range (seconds).
  final double sparkLifeMin;
  final double sparkLifeMax;

  /// Spark size range (line length).
  final double sparkMinSize;
  final double sparkMaxSize;

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
    this.backdrops = const [],
    this.enableFireworks = false,
    this.rocketsMax = 6,
    this.rocketSpawnRate = 0.8,
    this.sparksPerBurstMin = 20,
    this.sparksPerBurstMax = 40,
    this.burstHeightFactor = 0.25,
    this.gravityY = 70,
    this.rocketMinSpeed = 210,
    this.rocketMaxSpeed = 260,
    this.rocketLifeMin = 1.0,
    this.rocketLifeMax = 1.6,
    this.rocketSize = 3.0,
    this.rocketDrift = 24,
    this.sparkMinSpeed = 70,
    this.sparkMaxSpeed = 190,
    this.sparkLifeMin = 0.7,
    this.sparkLifeMax = 1.3,
    this.sparkMinSize = 6.0,
    this.sparkMaxSize = 12.0,
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
    List<DecorBackdrop>? backdrops,
    bool? enableFireworks,
    int? rocketsMax,
    double? rocketSpawnRate,
    int? sparksPerBurstMin,
    int? sparksPerBurstMax,
    double? burstHeightFactor,
    double? gravityY,
    double? rocketMinSpeed,
    double? rocketMaxSpeed,
    double? rocketLifeMin,
    double? rocketLifeMax,
    double? rocketSize,
    double? rocketDrift,
    double? sparkMinSpeed,
    double? sparkMaxSpeed,
    double? sparkLifeMin,
    double? sparkLifeMax,
    double? sparkMinSize,
    double? sparkMaxSize,
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
      backdrops: backdrops ?? this.backdrops,
      enableFireworks: enableFireworks ?? this.enableFireworks,
      rocketsMax: rocketsMax ?? this.rocketsMax,
      rocketSpawnRate: rocketSpawnRate ?? this.rocketSpawnRate,
      sparksPerBurstMin: sparksPerBurstMin ?? this.sparksPerBurstMin,
      sparksPerBurstMax: sparksPerBurstMax ?? this.sparksPerBurstMax,
      burstHeightFactor: burstHeightFactor ?? this.burstHeightFactor,
      gravityY: gravityY ?? this.gravityY,
      rocketMinSpeed: rocketMinSpeed ?? this.rocketMinSpeed,
      rocketMaxSpeed: rocketMaxSpeed ?? this.rocketMaxSpeed,
      rocketLifeMin: rocketLifeMin ?? this.rocketLifeMin,
      rocketLifeMax: rocketLifeMax ?? this.rocketLifeMax,
      rocketSize: rocketSize ?? this.rocketSize,
      rocketDrift: rocketDrift ?? this.rocketDrift,
      sparkMinSpeed: sparkMinSpeed ?? this.sparkMinSpeed,
      sparkMaxSpeed: sparkMaxSpeed ?? this.sparkMaxSpeed,
      sparkLifeMin: sparkLifeMin ?? this.sparkLifeMin,
      sparkLifeMax: sparkLifeMax ?? this.sparkLifeMax,
      sparkMinSize: sparkMinSize ?? this.sparkMinSize,
      sparkMaxSize: sparkMaxSize ?? this.sparkMaxSize,
    );
  }
}
