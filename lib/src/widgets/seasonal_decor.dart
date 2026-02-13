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

  @override
  void initState() {
    super.initState();
    _controller = DecorController(
      vsync: this,
      config: widget.preset.resolve(widget.intensity),
    );
    _lifecyclePause = LifecyclePause(
      onPaused: _handlePaused,
      onResumed: _handleResumed,
      enabled: widget.pauseWhenInactive,
    );
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

  void _syncAnimation() {
    final shouldAnimate = widget.enabled && !_appPaused && !_reduceMotion;
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
    final overlayOpacity = widget.opacity.clamp(0.0, 1.0) as double;

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
              repaint: _controller,
            ),
            size: Size.infinite,
          ),
        );

        return Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            if (widget.enabled)
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
    _lifecyclePause.dispose();
    _controller.dispose();
    super.dispose();
  }
}
