import 'dart:async';

import 'package:flutter/widgets.dart';

import '../config/intensity.dart';
import '../engine/decor_controller.dart';
import '../engine/decor_painter.dart';
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
  Timer? _stopTimer;
  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    _controller = DecorController(
      vsync: this,
      config: widget.preset.resolve(widget.intensity),
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
    _updateReduceMotion();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant SeasonalDecor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.preset != widget.preset ||
        oldWidget.intensity != widget.intensity) {
      _controller.updateConfig(widget.preset.resolve(widget.intensity));
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
    final shouldReduce = widget.respectReduceMotion &&
        ReduceMotion.isEnabled(context);
    _reduceMotion = shouldReduce;
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
              repaint: _controller,
            ),
            size: Size.infinite,
          ),
        );

        final shouldShowOverlay = widget.enabled ||
            (widget.showBackdropWhenDisabled && widget.showBackdrop);

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
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
