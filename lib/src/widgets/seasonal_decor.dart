import 'dart:async';

import 'package:flutter/foundation.dart' show listEquals, mapEquals;
import 'package:flutter/widgets.dart';

import '../config/decor_config.dart';
import '../config/intensity.dart';
import '../engine/decor_controller.dart';
import '../engine/decor_painter.dart';
import '../engine/particle.dart';
import '../presets/seasonal_preset.dart';
import '../utils/lifecycle_pause.dart';
import '../utils/reduce_motion.dart';

/// Adds seasonal decorative overlays to any widget.
class SeasonalDecor extends StatefulWidget {
  /// The widget below the overlay.
  final Widget child;

  /// The decorative preset to render.
  final SeasonalPreset preset;

  /// Whether the overlay is visible.
  final bool enabled;

  /// Density and speed profile.
  final DecorIntensity intensity;

  /// Global overlay opacity.
  final double opacity;

  /// Whether to honor the platform reduce motion setting.
  final bool respectReduceMotion;

  /// Whether to pause animation when the app is inactive.
  final bool pauseWhenInactive;

  /// Whether to ignore pointer events on the overlay.
  final bool ignorePointer;

  /// How long the animation plays before stopping.
  final Duration playDuration;

  /// Whether to let particles settle after stopping.
  final bool settleOnDisable;

  /// Optional repeat cadence for the animation.
  final Duration? repeatEvery;

  /// Whether to render decorative backdrops.
  final bool showBackdrop;

  /// Whether to keep drawing backdrops when [enabled] is false.
  final bool showBackdropWhenDisabled;

  /// Whether to paint backdrops in the [BackdropLayer.background] layer.
  final bool showBackgroundBackdrops;

  /// Optional custom widget to replace built-in background backdrops.
  ///
  /// When provided, built-in [BackdropLayer.background] backdrops are hidden
  /// and this widget is painted behind particles/decorative backdrops.
  final Widget? backgroundBackdrop;

  /// Whether to paint backdrops in the [BackdropLayer.decorative] layer.
  final bool showDecorativeBackdrops;

  /// Additional speed multiplier for particle motion.
  ///
  /// `1.0` keeps preset speeds. Higher values make the animation faster.
  final double particleSpeedMultiplier;

  /// Additional size multiplier for particle visuals.
  ///
  /// `1.0` keeps preset sizes. Higher values make particles larger.
  final double particleSizeMultiplier;

  /// Additional density multiplier for decorative backdrops.
  ///
  /// Affects decorative backdrop details such as garland bulbs and bunting
  /// flags. `1.0` keeps preset density.
  final double decorativeBackdropDensityMultiplier;

  /// Whether to adapt particle/backdrop colors to platform brightness.
  ///
  /// In light theme, colors are boosted for better visibility.
  final bool adaptColorsToTheme;

  /// Optional particle shape overrides applied to [preset] as
  /// `List<ParticleShape>`.
  final List<ParticleShape>? presetShapes;

  /// Optional full style overrides applied to [preset] as
  /// `List<ParticleStyle>`.
  final List<ParticleStyle>? presetStyles;

  /// Optional per-shape speed multipliers applied to [preset] as
  /// `Map<ParticleShape, double>`.
  final Map<ParticleShape, double>? presetShapeSpeedMultipliers;

  /// Optional single backdrop override applied to [preset].
  final DecorBackdrop? presetBackdrop;

  /// Optional backdrop list override applied to [preset] as
  /// `List<DecorBackdrop>`.
  final List<DecorBackdrop>? presetBackdrops;

  /// Optional backdrop type override applied to [preset].
  final BackdropType? presetBackdropType;

  /// Optional backdrop anchor override applied to [preset].
  final Offset? presetBackdropAnchor;

  /// Optional backdrop size override applied to [preset].
  final double? presetBackdropSizeFactor;

  /// Optional backdrop color override applied to [preset].
  final Color? presetBackdropColor;

  /// Optional backdrop opacity override applied to [preset].
  final double? presetBackdropOpacity;

  /// Optional fireworks toggle override applied to [preset].
  final bool? presetEnableFireworks;

  const SeasonalDecor({
    super.key,
    required this.child,
    required this.preset,
    this.enabled = true,
    this.intensity = DecorIntensity.medium,
    this.opacity = 1.0,
    this.respectReduceMotion = true,
    this.pauseWhenInactive = true,
    this.ignorePointer = true,
    this.playDuration = const Duration(seconds: 5),
    this.settleOnDisable = true,
    this.repeatEvery,
    this.showBackdrop = true,
    this.showBackdropWhenDisabled = true,
    this.showBackgroundBackdrops = true,
    this.backgroundBackdrop,
    this.showDecorativeBackdrops = true,
    this.particleSpeedMultiplier = 1.0,
    this.particleSizeMultiplier = 1.0,
    this.decorativeBackdropDensityMultiplier = 1.0,
    this.adaptColorsToTheme = true,
    this.presetShapes,
    this.presetStyles,
    this.presetShapeSpeedMultipliers,
    this.presetBackdrop,
    this.presetBackdrops,
    this.presetBackdropType,
    this.presetBackdropAnchor,
    this.presetBackdropSizeFactor,
    this.presetBackdropColor,
    this.presetBackdropOpacity,
    this.presetEnableFireworks,
  });

  @override
  State<SeasonalDecor> createState() => _SeasonalDecorState();
}

class _SeasonalDecorState extends State<SeasonalDecor>
    with TickerProviderStateMixin {
  late DecorController _controller;
  late LifecyclePause _lifecyclePause;
  Size _lastSize = Size.zero;
  bool _appPaused = false;
  bool _reduceMotion = false;
  bool _playing = true;
  Brightness _themeBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  Timer? _stopTimer;
  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    _controller = DecorController(
      vsync: this,
      config: _resolveConfig(),
    );
    _controller.addListener(_handleControllerTick);
    _lifecyclePause = LifecyclePause(
      onPaused: _handlePaused,
      onResumed: _handleResumed,
      enabled: widget.pauseWhenInactive,
    );
    if (widget.enabled && !widget.preset.isNone) {
      _startPlayCycle();
    } else {
      _playing = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final brightness = MediaQuery.platformBrightnessOf(context);
    if (brightness != _themeBrightness) {
      _themeBrightness = brightness;
      if (widget.adaptColorsToTheme) {
        _controller.updateConfig(_resolveConfig());
        _applySystemControls();
      }
    }
    _updateReduceMotion();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant SeasonalDecor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preset != widget.preset ||
        oldWidget.intensity != widget.intensity ||
        oldWidget.showBackgroundBackdrops != widget.showBackgroundBackdrops ||
        oldWidget.backgroundBackdrop != widget.backgroundBackdrop ||
        oldWidget.showDecorativeBackdrops != widget.showDecorativeBackdrops ||
        oldWidget.particleSpeedMultiplier != widget.particleSpeedMultiplier ||
        oldWidget.particleSizeMultiplier != widget.particleSizeMultiplier ||
        oldWidget.adaptColorsToTheme != widget.adaptColorsToTheme ||
        _presetOverridesChanged(oldWidget)) {
      _controller.updateConfig(_resolveConfig());
      _applySystemControls();
    }
    if (widget.preset.isNone) {
      _cancelTimers();
      _playing = false;
      _syncAnimation();
      return;
    }
    if (oldWidget.pauseWhenInactive != widget.pauseWhenInactive) {
      _lifecyclePause.setEnabled(widget.pauseWhenInactive);
      if (!widget.pauseWhenInactive) {
        _appPaused = false;
        _syncAnimation();
      }
    }
    if (oldWidget.respectReduceMotion != widget.respectReduceMotion) {
      _updateReduceMotion();
      _syncAnimation();
    }
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _startPlayCycle();
      } else {
        _cancelTimers();
        _playing = false;
        _applySystemControls();
        _syncAnimation();
      }
      return;
    }
    if (oldWidget.playDuration != widget.playDuration ||
        oldWidget.repeatEvery != widget.repeatEvery) {
      if (widget.enabled) {
        _startPlayCycle();
      } else {
        _cancelTimers();
      }
    }
    if (oldWidget.settleOnDisable != widget.settleOnDisable) {
      _applySystemControls();
      _syncAnimation();
    }
  }

  void _handlePaused() {
    if (_appPaused) {
      return;
    }
    _appPaused = true;
    _syncAnimation();
  }

  void _handleResumed() {
    if (!_appPaused) {
      return;
    }
    _appPaused = false;
    _syncAnimation();
  }

  void _updateReduceMotion() {
    final shouldReduce =
        widget.respectReduceMotion && ReduceMotion.isEnabled(context);
    _reduceMotion = shouldReduce;
  }

  DecorConfig _resolveConfig() {
    final resolvedPreset = _resolvePreset();
    final baseConfig = resolvedPreset.resolve(widget.intensity);
    final speedAdjusted = _applySpeedMultiplier(baseConfig);
    final sizeAdjusted = _applySizeMultiplier(speedAdjusted);
    final themed = widget.adaptColorsToTheme
        ? _adaptColorsForTheme(sizeAdjusted)
        : sizeAdjusted;
    return _applyBackdropLayerVisibility(themed);
  }

  DecorConfig _applyBackdropLayerVisibility(DecorConfig config) {
    final effectiveShowBackgroundBackdrops =
        widget.showBackgroundBackdrops && widget.backgroundBackdrop == null;

    if (effectiveShowBackgroundBackdrops && widget.showDecorativeBackdrops) {
      return config;
    }

    bool shouldKeep(DecorBackdrop backdrop) {
      switch (backdrop.layer) {
        case BackdropLayer.background:
          return effectiveShowBackgroundBackdrops;
        case BackdropLayer.decorative:
          return widget.showDecorativeBackdrops;
      }
    }

    final filteredBackdrops = [
      for (final backdrop in config.backdrops)
        if (shouldKeep(backdrop)) backdrop,
    ];

    final singleBackdrop = config.backdrop;
    final filteredBackdrop =
        singleBackdrop != null && shouldKeep(singleBackdrop)
            ? singleBackdrop
            : null;

    return config.copyWith(
      backdrop: filteredBackdrop,
      backdrops: filteredBackdrops,
    );
  }

  SeasonalPreset _resolvePreset() {
    final hasOverrides = widget.presetShapes != null ||
        widget.presetStyles != null ||
        (widget.presetShapeSpeedMultipliers?.isNotEmpty ?? false) ||
        widget.presetBackdrop != null ||
        widget.presetBackdrops != null ||
        widget.presetBackdropType != null ||
        widget.presetBackdropAnchor != null ||
        widget.presetBackdropSizeFactor != null ||
        widget.presetBackdropColor != null ||
        widget.presetBackdropOpacity != null ||
        widget.presetEnableFireworks != null;

    if (!hasOverrides) {
      return widget.preset;
    }

    return widget.preset.withOverrides(
      shapes: widget.presetShapes,
      styles: widget.presetStyles,
      shapeSpeedMultipliers: widget.presetShapeSpeedMultipliers,
      backdrop: widget.presetBackdrop,
      backdrops: widget.presetBackdrops,
      backdropType: widget.presetBackdropType,
      backdropAnchor: widget.presetBackdropAnchor,
      backdropSizeFactor: widget.presetBackdropSizeFactor,
      backdropColor: widget.presetBackdropColor,
      backdropOpacity: widget.presetBackdropOpacity,
      enableFireworks: widget.presetEnableFireworks,
    );
  }

  bool _presetOverridesChanged(SeasonalDecor oldWidget) {
    return !listEquals(oldWidget.presetShapes, widget.presetShapes) ||
        !listEquals(oldWidget.presetStyles, widget.presetStyles) ||
        !mapEquals(
          oldWidget.presetShapeSpeedMultipliers,
          widget.presetShapeSpeedMultipliers,
        ) ||
        oldWidget.presetBackdrop != widget.presetBackdrop ||
        !listEquals(oldWidget.presetBackdrops, widget.presetBackdrops) ||
        oldWidget.presetBackdropType != widget.presetBackdropType ||
        oldWidget.presetBackdropAnchor != widget.presetBackdropAnchor ||
        oldWidget.presetBackdropSizeFactor != widget.presetBackdropSizeFactor ||
        oldWidget.presetBackdropColor != widget.presetBackdropColor ||
        oldWidget.presetBackdropOpacity != widget.presetBackdropOpacity ||
        oldWidget.presetEnableFireworks != widget.presetEnableFireworks;
  }

  DecorConfig _applySpeedMultiplier(DecorConfig config) {
    final speedMultiplier =
        widget.particleSpeedMultiplier.clamp(0.0, 6.0).toDouble();
    if ((speedMultiplier - 1.0).abs() < 0.0001) {
      return config;
    }

    final styles = [
      for (final style in config.styles)
        style.copyWith(
          minSpeed: style.minSpeed * speedMultiplier,
          maxSpeed: style.maxSpeed * speedMultiplier,
        ),
    ];

    if (!config.enableFireworks) {
      return config.copyWith(styles: styles);
    }

    return config.copyWith(
      styles: styles,
      rocketMinSpeed: config.rocketMinSpeed * speedMultiplier,
      rocketMaxSpeed: config.rocketMaxSpeed * speedMultiplier,
      sparkMinSpeed: config.sparkMinSpeed * speedMultiplier,
      sparkMaxSpeed: config.sparkMaxSpeed * speedMultiplier,
    );
  }

  DecorConfig _applySizeMultiplier(DecorConfig config) {
    final sizeMultiplier =
        widget.particleSizeMultiplier.clamp(0.2, 4.0).toDouble();
    if ((sizeMultiplier - 1.0).abs() < 0.0001) {
      return config;
    }

    final styles = [
      for (final style in config.styles)
        style.copyWith(
          minSize: style.minSize * sizeMultiplier,
          maxSize: style.maxSize * sizeMultiplier,
        ),
    ];

    if (!config.enableFireworks) {
      return config.copyWith(styles: styles);
    }

    return config.copyWith(
      styles: styles,
      rocketSize: config.rocketSize * sizeMultiplier,
      sparkMinSize: config.sparkMinSize * sizeMultiplier,
      sparkMaxSize: config.sparkMaxSize * sizeMultiplier,
    );
  }

  DecorConfig _adaptColorsForTheme(DecorConfig config) {
    final styles = [
      for (final style in config.styles)
        style.copyWith(color: _adaptColorForTheme(style.color)),
    ];

    final backdrop = config.backdrop;
    final adaptedBackdrop =
        backdrop == null ? null : _adaptBackdropForTheme(backdrop);
    final adaptedBackdrops = [
      for (final item in config.backdrops) _adaptBackdropForTheme(item),
    ];

    return config.copyWith(
      styles: styles,
      backdrop: adaptedBackdrop,
      backdrops: adaptedBackdrops,
    );
  }

  Color _adaptColorForTheme(Color color) {
    final hsl = HSLColor.fromColor(color);
    final saturationBoost = _themeBrightness == Brightness.light ? 0.18 : 0.06;
    var lightness = hsl.lightness;

    if (_themeBrightness == Brightness.light) {
      if (lightness > 0.78) {
        lightness = (lightness - 0.2).clamp(0.0, 1.0).toDouble();
      } else if (lightness < 0.18) {
        lightness = (lightness + 0.15).clamp(0.0, 1.0).toDouble();
      }
    } else {
      lightness = (lightness + 0.04).clamp(0.0, 1.0).toDouble();
    }

    final adapted = hsl
        .withSaturation(
          (hsl.saturation + saturationBoost).clamp(0.0, 1.0).toDouble(),
        )
        .withLightness(lightness)
        .toColor();
    return adapted.withValues(alpha: color.a);
  }

  DecorBackdrop _adaptBackdropForTheme(DecorBackdrop backdrop) {
    var opacity = backdrop.opacity;
    if (_themeBrightness == Brightness.light) {
      // Backdrops are subtle by default; boost slightly in light mode.
      opacity = (opacity * 1.45).clamp(0.0, 1.0).toDouble();
    }
    return backdrop.copyWith(
      color: _adaptColorForTheme(backdrop.color),
      opacity: opacity,
    );
  }

  void _startPlayCycle() {
    if (!widget.enabled) {
      return;
    }
    _playing = true;
    _applySystemControls();
    _stopTimer?.cancel();
    _repeatTimer?.cancel();
    if (widget.playDuration > Duration.zero) {
      _stopTimer = Timer(widget.playDuration, _stopPlaying);
    }
    _syncAnimation();
  }

  void _stopPlaying() {
    _playing = false;
    _applySystemControls();
    _syncAnimation();
    _repeatTimer?.cancel();
    if (widget.enabled && widget.repeatEvery != null) {
      _repeatTimer = Timer(widget.repeatEvery!, _startPlayCycle);
    }
  }

  void _cancelTimers() {
    _stopTimer?.cancel();
    _repeatTimer?.cancel();
  }

  void _applySystemControls() {
    if (_playing) {
      _controller.system.setSpawningEnabled(true);
      _controller.system.setWrapEnabled(true);
      return;
    }
    if (widget.settleOnDisable) {
      _controller.system.setSpawningEnabled(false);
      _controller.system.setWrapEnabled(false);
    }
  }

  void _handleControllerTick() {
    if (!widget.enabled ||
        _playing ||
        !widget.settleOnDisable ||
        _reduceMotion) {
      return;
    }
    if (!_controller.system.hasActiveParticles) {
      _controller.stop();
    }
  }

  @visibleForTesting
  bool debugIsPlaying() => _playing;

  @visibleForTesting
  bool debugIsRepeatTimerActive() => _repeatTimer?.isActive ?? false;

  @visibleForTesting
  void debugStopPlayingForTest() => _stopPlaying();

  void _syncAnimation() {
    if (widget.preset.isNone) {
      _controller.stop();
      return;
    }
    final shouldAnimate = widget.enabled &&
        !_appPaused &&
        !_reduceMotion &&
        (_playing ||
            (widget.settleOnDisable && _controller.system.hasActiveParticles));
    if (shouldAnimate) {
      _controller.start();
    } else {
      _controller.stop();
    }
  }

  Size _resolveSize(BoxConstraints constraints) {
    final size = constraints.biggest;
    if (size.width.isFinite && size.height.isFinite) {
      return size;
    }
    return MediaQuery.sizeOf(context);
  }

  @override
  Widget build(BuildContext context) {
    final overlayOpacity = widget.opacity.clamp(0.0, 1.0).toDouble();

    if (widget.preset.isNone) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedSize = _resolveSize(constraints);
        if (resolvedSize != _lastSize &&
            resolvedSize.width > 0 &&
            resolvedSize.height > 0) {
          _lastSize = resolvedSize;
          _controller.updateBounds(resolvedSize);
        }

        final overlay = RepaintBoundary(
          child: CustomPaint(
            painter: DecorPainter(
              system: _controller.system,
              config: _controller.config,
              opacity: overlayOpacity,
              staticMode: _reduceMotion,
              paintParticles: widget.enabled,
              showBackdrop: widget.showBackdrop,
              decorativeBackdropDensityMultiplier:
                  widget.decorativeBackdropDensityMultiplier,
              repaint: _controller,
            ),
            size: Size.infinite,
          ),
        );

        final shouldShowOverlay = widget.enabled ||
            (widget.showBackdropWhenDisabled && widget.showBackdrop);
        final shouldShowCustomBackgroundBackdrop =
            widget.backgroundBackdrop != null &&
                widget.showBackdrop &&
                (widget.enabled || widget.showBackdropWhenDisabled);

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            if (shouldShowCustomBackgroundBackdrop)
              IgnorePointer(
                ignoring: true,
                child: RepaintBoundary(child: widget.backgroundBackdrop!),
              ),
            if (shouldShowOverlay)
              IgnorePointer(
                ignoring: widget.ignorePointer,
                child: overlay,
              ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _cancelTimers();
    _controller.removeListener(_handleControllerTick);
    _lifecyclePause.dispose();
    _controller.dispose();
    super.dispose();
  }
}
