import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart' show listEquals, mapEquals;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import '../config/decor_config.dart';
import '../config/intensity.dart';
import '../engine/backdrop_animator.dart';
import '../engine/decor_painter.dart';
import '../engine/layered_particle_system.dart';
import '../engine/moment_engine.dart';
import '../engine/moment_painter.dart';
import '../engine/particle.dart';
import '../engine/particle_system.dart';
import '../engine/scene_backdrop_painter.dart';
import '../engine/scene_transition.dart';
import '../engine/seasonal_decor_controller.dart';
import '../presets/seasonal_preset.dart';
import '../scene/palette_harmony.dart';
import '../scene/scene_registry.dart';
import '../scene/scene_spec.dart';
import '../scene/seasonal_mode.dart';
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

  /// Additional speed multiplier for particle motion.
  final double particleSpeedMultiplier;

  /// Whether to adapt particle/backdrop colors to app theme.
  final bool adaptColorsToTheme;

  /// Scene energy profile.
  final SeasonalMode mode;

  /// Optional external controller to trigger short moments.
  final SeasonalDecorController? controller;

  /// Optional particle shape overrides applied to [preset].
  final List<ParticleShape>? presetShapes;

  /// Optional full style overrides applied to [preset].
  final List<ParticleStyle>? presetStyles;

  /// Optional per-shape speed multipliers applied to [preset].
  final Map<ParticleShape, double>? presetShapeSpeedMultipliers;

  /// Optional single backdrop override applied to [preset].
  final DecorBackdrop? presetBackdrop;

  /// Optional backdrop list override applied to [preset].
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
    this.particleSpeedMultiplier = 1.0,
    this.adaptColorsToTheme = true,
    this.mode = SeasonalMode.ambient,
    this.controller,
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
  static const double _baselineArea = 360.0 * 640.0;

  late LifecyclePause _lifecyclePause;
  late final scheduler.Ticker _ticker;
  final ValueNotifier<int> _frameNotifier = ValueNotifier<int>(0);
  final MomentEngine _momentEngine = MomentEngine();
  final BackdropAnimator _backdropAnimator = BackdropAnimator();
  final SceneTransitionController _transition = SceneTransitionController();

  Size _lastSize = Size.zero;
  double _densityScale = 1.0;
  bool _appPaused = false;
  bool _reduceMotion = false;
  bool _playing = true;
  bool _tickerRunning = false;
  Duration _lastTick = Duration.zero;
  int _activeParticleCount = 0;

  Timer? _stopTimer;
  Timer? _repeatTimer;

  Brightness _themeBrightness =
      WidgetsBinding.instance.platformDispatcher.platformBrightness;
  Color _themePrimary = const Color(0xFF1BB8A3);

  LayeredParticleSystem? _ambientSystem;
  DecorConfig? _resolvedConfig;
  SceneSpec _sceneSpec = SceneRegistry.resolve(SeasonalPreset.ramadan());
  ScenePalette _scenePalette = const ScenePalette(
    gradient: [Color(0xFF0E1B33), Color(0xFF123744), Color(0xFF0A1320)],
    glow: Color(0xFFF7E8BD),
    vignette: Color(0xCC03060A),
    particleColors: [Color(0xFFCAD6FF), Color(0xFFFFE8A3)],
    momentPrimary: Color(0xFFFFE8A3),
    momentAccent: Color(0xFFCAD6FF),
  );

  SeasonalDecorController? _externalController;
  int _lastSeenMomentEventId = -1;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_handleTick);
    _attachController(widget.controller);
    _lifecyclePause = LifecyclePause(
      onPaused: _handlePaused,
      onResumed: _handleResumed,
      enabled: widget.pauseWhenInactive,
    );
    _rebuildScene();
    if (widget.enabled && !widget.preset.isNone) {
      _startPlayCycle();
    } else {
      _playing = false;
      _transition.idle();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final primary = theme.colorScheme.primary;
    if (brightness != _themeBrightness || primary != _themePrimary) {
      _themeBrightness = brightness;
      _themePrimary = primary;
      _rebuildScene();
    }
    _updateReduceMotion();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant SeasonalDecor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _attachController(widget.controller);
    }

    final shouldRebuild = oldWidget.preset != widget.preset ||
        oldWidget.intensity != widget.intensity ||
        oldWidget.particleSpeedMultiplier != widget.particleSpeedMultiplier ||
        oldWidget.adaptColorsToTheme != widget.adaptColorsToTheme ||
        oldWidget.mode != widget.mode ||
        _presetOverridesChanged(oldWidget);

    if (shouldRebuild) {
      _rebuildScene();
    }

    if (widget.preset.isNone) {
      _cancelTimers();
      _playing = false;
      _transition.idle();
      _momentEngine.clear();
      _syncAnimation();
      return;
    }

    if (oldWidget.pauseWhenInactive != widget.pauseWhenInactive) {
      _lifecyclePause.setEnabled(widget.pauseWhenInactive);
      if (!widget.pauseWhenInactive) {
        _appPaused = false;
      }
    }

    if (oldWidget.respectReduceMotion != widget.respectReduceMotion) {
      _updateReduceMotion();
      _rebuildScene();
    }

    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        _startPlayCycle();
      } else {
        _cancelTimers();
        _playing = false;
        _transition.exit();
        _applySystemControls();
      }
      _syncAnimation();
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

  void _attachController(SeasonalDecorController? controller) {
    _externalController?.removeListener(_handleControllerMoments);
    _externalController = controller;
    _externalController?.addListener(_handleControllerMoments);
    _lastSeenMomentEventId = -1;
  }

  void _handleControllerMoments() {
    final controller = _externalController;
    if (controller == null) {
      return;
    }
    final events = controller.eventsSince(_lastSeenMomentEventId);
    if (events.isEmpty) {
      return;
    }
    for (final event in events) {
      if (event.id > _lastSeenMomentEventId) {
        _lastSeenMomentEventId = event.id;
      }
      if (!widget.enabled || widget.preset.isNone) {
        continue;
      }
      _triggerMoment(event.moment, options: event.options);
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
    _reduceMotion =
        widget.respectReduceMotion && ReduceMotion.isEnabled(context);
  }

  void _rebuildScene() {
    if (!mounted) {
      return;
    }

    final preset = _resolvePreset();
    _sceneSpec = SceneRegistry.resolve(preset);

    final anchors = SceneRegistry.anchorsForPreset(preset);
    _scenePalette = PaletteHarmony.resolve(
      anchors: anchors,
      primary: _themePrimary,
      brightness: _themeBrightness,
      mode: widget.mode,
      reduceMotion: _reduceMotion,
    );

    final resolved = _resolveConfig(preset);
    _resolvedConfig = resolved;

    if (preset.isNone) {
      _ambientSystem = null;
      _frameNotifier.value += 1;
      return;
    }

    _ambientSystem = LayeredParticleSystem(
      baseConfig: resolved.copyWith(enableFireworks: false),
      sceneSpec: _sceneSpec,
      mode: widget.mode,
      reduceMotion: _reduceMotion,
      size: _lastSize,
    );
    _ambientSystem?.setDensityScale(_densityScale);
    if (_lastSize != Size.zero) {
      _ambientSystem?.setBounds(_lastSize);
    }
    _applySystemControls();
    _recalculateActiveParticleCount();
    _frameNotifier.value += 1;
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

  DecorConfig _resolveConfig(SeasonalPreset preset) {
    final base = preset.resolve(widget.intensity);
    final speedAdjusted = _applySpeedMultiplier(base);
    if (!widget.adaptColorsToTheme) {
      return speedAdjusted.copyWith(enableFireworks: false);
    }
    return _applyScenePalette(speedAdjusted).copyWith(enableFireworks: false);
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
    return config.copyWith(styles: styles);
  }

  DecorConfig _applyScenePalette(DecorConfig config) {
    final palette = _scenePalette.particleColors;
    final styles = [
      for (var i = 0; i < config.styles.length; i += 1)
        config.styles[i].copyWith(
          color: palette[i % palette.length]
              .withValues(alpha: config.styles[i].color.a),
        ),
    ];

    DecorBackdrop? backdrop = config.backdrop;
    if (backdrop != null) {
      backdrop = backdrop.copyWith(
        color: _scenePalette.glow,
        opacity: (backdrop.opacity * _sceneSpec.legacyBackdropAlpha)
            .clamp(0.0, 1.0)
            .toDouble(),
      );
    }

    final backdrops = [
      for (var i = 0; i < config.backdrops.length; i += 1)
        config.backdrops[i].copyWith(
          color: _scenePalette
              .particleColors[i % _scenePalette.particleColors.length],
          opacity:
              (config.backdrops[i].opacity * _sceneSpec.legacyBackdropAlpha)
                  .clamp(0.0, 1.0)
                  .toDouble(),
        ),
    ];

    return config.copyWith(
      styles: styles,
      backdrop: backdrop,
      backdrops: backdrops,
    );
  }

  void _startPlayCycle() {
    if (!widget.enabled || widget.preset.isNone) {
      return;
    }
    _playing = true;
    _transition.enter();
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
    _transition.exit();
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
    final system = _ambientSystem;
    if (system == null) {
      return;
    }
    if (_playing) {
      system.setSpawningEnabled(true);
      system.setWrapEnabled(true);
      return;
    }
    system.setSpawningEnabled(false);
    system.setWrapEnabled(!widget.settleOnDisable);
  }

  void _triggerMoment(
    SeasonalMoment moment, {
    SeasonalMomentOptions options = const SeasonalMomentOptions(),
  }) {
    if (_lastSize == Size.zero) {
      return;
    }
    SeasonalMoment resolved = _sceneSpec.resolveMoment(moment);
    if (_reduceMotion && resolved == SeasonalMoment.fireworksBurst) {
      resolved = SeasonalMoment.subtleSparkle;
    }
    final spec = _sceneSpec.moments[resolved];
    if (spec == null) {
      return;
    }
    _momentEngine.trigger(
      spec: spec,
      palette: _scenePalette,
      size: _lastSize,
      options: options,
      reduceMotion: _reduceMotion,
    );
    _syncAnimation();
  }

  void _syncAnimation() {
    if (widget.preset.isNone) {
      _stopTicker();
      return;
    }

    final shouldAnimate = !_appPaused &&
        (_playing ||
            _momentEngine.hasActiveMoments ||
            (_transition.isActive) ||
            (widget.settleOnDisable &&
                (_ambientSystem?.hasActiveParticles ?? false)));

    if (shouldAnimate) {
      _startTicker();
    } else {
      _stopTicker();
    }
  }

  void _startTicker() {
    if (_tickerRunning) {
      return;
    }
    _tickerRunning = true;
    _lastTick = Duration.zero;
    _ticker.start();
  }

  void _stopTicker() {
    if (!_tickerRunning) {
      return;
    }
    _tickerRunning = false;
    _lastTick = Duration.zero;
    _ticker.stop();
    _frameNotifier.value += 1;
  }

  void _handleTick(Duration elapsed) {
    if (!_tickerRunning) {
      return;
    }
    if (_lastTick == Duration.zero) {
      _lastTick = elapsed;
      return;
    }

    final delta = elapsed - _lastTick;
    _lastTick = elapsed;
    final dt = delta.inMicroseconds / 1000000.0;
    if (dt <= 0) {
      return;
    }

    _transition.update(dt, _sceneSpec.transition);
    _backdropAnimator.update(dt, reduceMotion: _reduceMotion);
    _ambientSystem?.update(dt);
    _momentEngine.update(dt, reduceMotion: _reduceMotion);
    _recalculateActiveParticleCount();

    if (!_playing &&
        !widget.enabled &&
        !_momentEngine.hasActiveMoments &&
        !(_ambientSystem?.hasActiveParticles ?? false) &&
        !_transition.isActive) {
      _stopTicker();
      return;
    }

    if (!_playing &&
        widget.enabled &&
        !widget.settleOnDisable &&
        !_momentEngine.hasActiveMoments &&
        !_transition.isActive) {
      _stopTicker();
      return;
    }

    _frameNotifier.value += 1;
  }

  void _recalculateActiveParticleCount() {
    var count = 0;
    final layers = _ambientSystem?.layers ?? const <AmbientLayerRuntime>[];
    for (final layer in layers) {
      for (final particle in layer.system.particles) {
        if (particle.active) {
          count += 1;
        }
      }
    }
    _activeParticleCount = count;
  }

  Size _resolveSize(BoxConstraints constraints) {
    final size = constraints.biggest;
    if (size.width.isFinite && size.height.isFinite) {
      return size;
    }
    return MediaQuery.sizeOf(context);
  }

  void _updateBounds(Size size) {
    if (size.width <= 0 || size.height <= 0) {
      return;
    }
    if (size == _lastSize) {
      return;
    }

    _lastSize = size;
    final area = size.width * size.height;
    final scale = math.sqrt(area / _baselineArea);
    _densityScale = scale.clamp(0.6, 1.4).toDouble();
    _ambientSystem?.setBounds(size);
    _ambientSystem?.setDensityScale(_densityScale);
    _frameNotifier.value += 1;
  }

  bool _layerStaticMode(AmbientLayerRuntime layer) {
    if (_reduceMotion) {
      return true;
    }
    if (_activeParticleCount > 320 && layer.spec.qualityPriority >= 2) {
      return true;
    }
    if (_activeParticleCount > 230 && layer.spec.qualityPriority >= 3) {
      return true;
    }
    return false;
  }

  double _layerSway(AmbientLayerRuntime layer) {
    final amplitude = _reduceMotion
        ? layer.spec.swayAmplitude * 0.25
        : layer.spec.swayAmplitude;
    final t = _backdropAnimator.time;
    return math.sin(t * layer.spec.swayFrequency * math.pi * 2.0) * amplitude;
  }

  bool _shouldPaintParticles() {
    if (_playing) {
      return true;
    }
    if (_momentEngine.hasActiveMoments) {
      return true;
    }
    return widget.settleOnDisable &&
        (_ambientSystem?.hasActiveParticles ?? false);
  }

  @visibleForTesting
  bool debugIsPlaying() => _playing;

  @visibleForTesting
  bool debugIsRepeatTimerActive() => _repeatTimer?.isActive ?? false;

  @visibleForTesting
  void debugStopPlayingForTest() => _stopPlaying();

  @override
  Widget build(BuildContext context) {
    final overlayOpacity = widget.opacity.clamp(0.0, 1.0).toDouble();
    if (widget.preset.isNone) {
      return widget.child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedSize = _resolveSize(constraints);
        if (resolvedSize.width > 0 && resolvedSize.height > 0) {
          _updateBounds(resolvedSize);
        }

        final config = _resolvedConfig;
        final layers = _ambientSystem?.layers ?? const <AmbientLayerRuntime>[];

        final sceneAlpha = _playing
            ? _transition.sceneAlpha(_sceneSpec.transition)
            : _transition.sceneAlpha(_sceneSpec.transition);
        final backdropAlpha =
            (!widget.enabled && widget.showBackdropWhenDisabled)
                ? 1.0
                : _transition.backdropAlpha(_sceneSpec.transition);

        final shouldBackdrop = widget.showBackdrop &&
            (widget.enabled ||
                widget.showBackdropWhenDisabled ||
                _transition.isActive);

        final shouldParticles = _shouldPaintParticles();
        final shouldShowOverlay = shouldBackdrop ||
            shouldParticles ||
            _momentEngine.hasActiveMoments ||
            _transition.isActive;

        if (!shouldShowOverlay) {
          return widget.child;
        }

        final overlayChildren = <Widget>[
          if (shouldBackdrop)
            RepaintBoundary(
              child: CustomPaint(
                painter: SceneBackdropPainter(
                  scene: _sceneSpec,
                  palette: _scenePalette,
                  time: _backdropAnimator.time,
                  alpha: overlayOpacity * backdropAlpha,
                  reduceMotion: _reduceMotion,
                  repaint: _frameNotifier,
                ),
                size: Size.infinite,
              ),
            ),
          if (shouldBackdrop && config != null)
            RepaintBoundary(
              child: CustomPaint(
                painter: DecorPainter(
                  system: layers.isNotEmpty
                      ? layers.first.system
                      : MomentEngineFallback.emptySystem,
                  config: config,
                  opacity: overlayOpacity * backdropAlpha,
                  staticMode: _reduceMotion,
                  paintParticles: false,
                  showBackdrop: true,
                  repaint: _frameNotifier,
                ),
                size: Size.infinite,
              ),
            ),
        ];

        if (shouldParticles && config != null) {
          for (final layer in layers) {
            overlayChildren.add(
              Transform.translate(
                offset: Offset(_layerSway(layer), 0),
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: DecorPainter(
                      system: layer.system,
                      config: layer.config,
                      opacity: overlayOpacity * sceneAlpha,
                      staticMode: _layerStaticMode(layer),
                      paintParticles: true,
                      showBackdrop: false,
                      repaint: _frameNotifier,
                    ),
                    size: Size.infinite,
                  ),
                ),
              ),
            );
          }
        }

        if (_momentEngine.hasActiveMoments) {
          overlayChildren.add(
            RepaintBoundary(
              child: CustomPaint(
                painter: MomentPainter(
                  engine: _momentEngine,
                  opacity: overlayOpacity * math.max(0.5, sceneAlpha),
                  repaint: _frameNotifier,
                ),
                size: Size.infinite,
              ),
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            IgnorePointer(
              ignoring: widget.ignorePointer,
              child: Stack(
                fit: StackFit.expand,
                children: overlayChildren,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _cancelTimers();
    _externalController?.removeListener(_handleControllerMoments);
    _stopTicker();
    _ticker.dispose();
    _lifecyclePause.dispose();
    _frameNotifier.dispose();
    super.dispose();
  }
}

/// Lightweight fallback system for backdrop-only rendering.
class MomentEngineFallback {
  static final emptySystem = _EmptyParticleSystem();
}

class _EmptyParticleSystem extends ParticleSystem {
  _EmptyParticleSystem()
      : super(
          config: const DecorConfig(
            particleCount: 1,
            speedMultiplier: 0,
            spawnRate: 0,
            spawnRateScale: 0,
            drift: 0,
            flow: ParticleFlow.falling,
            wrapMode: DecorWrapMode.respawn,
            styles: [
              ParticleStyle(
                shape: ParticleShape.circle,
                color: Color(0x00000000),
                minSize: 1,
                maxSize: 1,
                minSpeed: 0,
                maxSpeed: 0,
                minRotationSpeed: 0,
                maxRotationSpeed: 0,
                opacity: 0,
              ),
            ],
          ),
          size: Size.zero,
        );
}
