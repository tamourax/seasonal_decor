import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'moment_engine.dart';
import '../scene/scene_spec.dart';

/// Draws active particles emitted by [MomentEngine].
class MomentPainter extends CustomPainter {
  final MomentEngine engine;
  final double opacity;

  final Paint _paint = Paint()..isAntiAlias = true;
  static final Path _unitStar = _buildStar();
  static const Rect _unitRect = Rect.fromLTRB(-0.5, -0.5, 0.5, 0.5);

  MomentPainter({
    required this.engine,
    required this.opacity,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final alpha = opacity.clamp(0.0, 1.0).toDouble();
    if (alpha <= 0) {
      return;
    }
    final particles = engine.particles;
    for (final particle in particles) {
      if (!particle.active) {
        continue;
      }
      final lifeFade = particle.lifeProgress;
      final color = particle.color.withValues(
        alpha: (particle.color.a * particle.opacity * alpha * lifeFade)
            .clamp(0.0, 1.0)
            .toDouble(),
      );
      _paintParticle(canvas, particle, color);
    }
  }

  void _paintParticle(Canvas canvas, MomentParticle particle, Color color) {
    switch (particle.style) {
      case MomentVisualStyle.sparkle:
      case MomentVisualStyle.ringSpark:
        _paint
          ..color = color.withValues(alpha: (color.a * 0.32).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
            Offset(particle.x, particle.y), particle.size * 0.68, _paint);
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitStar, _paint);
        canvas.restore();
        break;
      case MomentVisualStyle.confetti:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size * 0.52);
        canvas.drawRRect(
          RRect.fromRectAndRadius(_unitRect, const Radius.circular(0.18)),
          _paint,
        );
        canvas.restore();
        break;
      case MomentVisualStyle.firework:
        _paint
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, particle.size * 0.2)
          ..strokeCap = StrokeCap.round;
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(particle.rotation);
        canvas.drawLine(Offset.zero, Offset(0, -particle.size * 1.2), _paint);
        canvas.restore();
        _paint
          ..style = PaintingStyle.fill
          ..color = color.withValues(alpha: (color.a * 0.3).clamp(0.0, 1.0));
        canvas.drawCircle(
            Offset(particle.x, particle.y), particle.size * 0.42, _paint);
        break;
    }
  }

  static Path _buildStar() {
    const points = 4;
    final path = Path();
    for (var i = 0; i < points * 2; i += 1) {
      final radius = i.isEven ? 0.6 : 0.22;
      final theta = -math.pi / 2 + i * math.pi / points;
      final x = math.cos(theta) * radius;
      final y = math.sin(theta) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant MomentPainter oldDelegate) {
    return oldDelegate.engine != engine || oldDelegate.opacity != opacity;
  }
}
