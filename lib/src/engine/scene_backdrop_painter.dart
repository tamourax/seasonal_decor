import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../scene/palette_harmony.dart';
import '../scene/scene_spec.dart';

/// Paints atmospheric gradient/vignette layers.
class SceneBackdropPainter extends CustomPainter {
  final SceneSpec scene;
  final ScenePalette palette;
  final double time;
  final double alpha;
  final bool reduceMotion;

  final Paint _paint = Paint()..isAntiAlias = true;

  SceneBackdropPainter({
    required this.scene,
    required this.palette,
    required this.time,
    required this.alpha,
    required this.reduceMotion,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final clampedAlpha = alpha.clamp(0.0, 1.0).toDouble();
    if (clampedAlpha <= 0.0) {
      return;
    }
    _paintGradient(canvas, size, clampedAlpha);
    _paintGlow(canvas, size, clampedAlpha);
    _paintVignette(canvas, size, clampedAlpha);
  }

  void _paintGradient(Canvas canvas, Size size, double alpha) {
    final driftSeconds =
        scene.backdrop.gradientDrift.inMicroseconds / 1000000.0;
    final phase = driftSeconds <= 0 ? 0.0 : (time / driftSeconds);
    final drift =
        (math.sin(phase * math.pi * 2.0) * (reduceMotion ? 0.02 : 0.05));
    final begin = Alignment(-0.3 + drift, -1.0);
    final end = Alignment(0.3 - drift, 1.0);
    _paint.shader = LinearGradient(
      begin: begin,
      end: end,
      colors: [
        for (final color in palette.gradient)
          color.withValues(alpha: (color.a * alpha).clamp(0.0, 1.0)),
      ],
      stops: const [0.0, 0.52, 1.0],
    ).createShader(Offset.zero & size);
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, _paint);
    _paint.shader = null;
  }

  void _paintGlow(Canvas canvas, Size size, double alpha) {
    final pulseSeconds = scene.backdrop.glowPulse.inMicroseconds / 1000000.0;
    final pulsePhase = pulseSeconds <= 0 ? 0.0 : (time / pulseSeconds);
    final pulse = 0.5 + 0.5 * math.sin(pulsePhase * math.pi * 2.0);
    final pulseScale = reduceMotion ? 1.0 : (1.0 + (pulse - 0.5) * 0.2);
    final center = scene.backdrop.glowAlignment.alongSize(size);
    final radius = math.min(size.width, size.height) *
        scene.backdrop.glowRadius *
        pulseScale;
    _paint.shader = RadialGradient(
      colors: [
        palette.glow.withValues(alpha: (0.24 * alpha).clamp(0.0, 1.0)),
        palette.glow.withValues(alpha: (0.09 * alpha).clamp(0.0, 1.0)),
        const Color(0x00000000),
      ],
      stops: const [0.0, 0.4, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, _paint);
    _paint.shader = null;
  }

  void _paintVignette(Canvas canvas, Size size, double alpha) {
    final center = Offset(size.width * 0.5, size.height * 0.4);
    final radius = math.max(size.width, size.height) * 0.78;
    _paint.shader = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        const Color(0x00000000),
        palette.vignette.withValues(alpha: (0.26 * alpha).clamp(0.0, 1.0)),
      ],
      stops: const [0.56, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    _paint.style = PaintingStyle.fill;
    canvas.drawRect(Offset.zero & size, _paint);
    _paint.shader = null;
  }

  @override
  bool shouldRepaint(covariant SceneBackdropPainter oldDelegate) {
    return oldDelegate.scene != scene ||
        oldDelegate.palette != palette ||
        oldDelegate.time != time ||
        oldDelegate.alpha != alpha ||
        oldDelegate.reduceMotion != reduceMotion;
  }
}
