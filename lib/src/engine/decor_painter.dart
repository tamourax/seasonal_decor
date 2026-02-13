import 'dart:math' as math;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../config/decor_config.dart';
import 'particle.dart';
import 'particle_system.dart';

/// Paints seasonal particles and optional backdrops.
class DecorPainter extends CustomPainter {
  /// Particle system to draw.
  final ParticleSystem system;

  /// Configuration for drawing.
  final DecorConfig config;

  /// Global opacity multiplier.
  final double opacity;

  /// Whether to render a static overlay (reduced motion).
  final bool staticMode;

  final Paint _paint = Paint()..isAntiAlias = true;

  DecorPainter({
    required this.system,
    required this.config,
    required this.opacity,
    required this.staticMode,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    system.setBounds(size);

    final clampedOpacity = opacity.clamp(0.0, 1.0) as double;
    _paintBackdrop(canvas, size, clampedOpacity);

    final particles = system.particles;
    final step = staticMode ? 3 : 1;
    for (var i = 0; i < particles.length; i += step) {
      final particle = particles[i];
      if (!particle.active) {
        continue;
      }
      _paintParticle(canvas, particle, clampedOpacity);
    }
  }

  void _paintBackdrop(Canvas canvas, Size size, double opacity) {
    final backdrop = config.backdrop;
    if (backdrop == null) {
      return;
    }
    switch (backdrop.type) {
      case BackdropType.crescent:
        final shortest = math.min(size.width, size.height);
        final radius = shortest * backdrop.sizeFactor;
        final center = Offset(
          size.width * backdrop.anchor.dx,
          size.height * backdrop.anchor.dy,
        );
        final color = backdrop.color.withOpacity(
          (backdrop.opacity * opacity).clamp(0.0, 1.0) as double,
        );
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        final path = _crescentPath(center, radius);
        canvas.drawPath(path, _paint);
        break;
    }
  }

  void _paintParticle(Canvas canvas, Particle particle, double opacity) {
    final color = particle.color.withOpacity(
      (particle.color.opacity * particle.opacity * opacity)
          .clamp(0.0, 1.0) as double,
    );
    _paint
      ..color = color
      ..style = PaintingStyle.fill;

    switch (particle.shape) {
      case ParticleShape.circle:
        canvas.drawCircle(particle.position, particle.size, _paint);
        break;
      case ParticleShape.star:
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.drawPath(_starPath(particle.size), _paint);
        canvas.restore();
        break;
      case ParticleShape.crescent:
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        final path = _crescentPath(Offset.zero, particle.size);
        canvas.drawPath(path, _paint);
        canvas.restore();
        break;
    }
  }

  Path _starPath(double radius) {
    const points = 5;
    final path = Path();
    final innerRadius = radius * 0.5;
    for (var i = 0; i < points * 2; i += 1) {
      final isOuter = i.isEven;
      final r = isOuter ? radius : innerRadius;
      final angle = (math.pi / 2) + (math.pi / points) * i;
      final x = math.cos(angle) * r;
      final y = -math.sin(angle) * r;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  Path _crescentPath(Offset center, double radius) {
    final outer = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: center.translate(radius * 0.4, 0),
          radius: radius * 0.8,
        ),
      );
    return Path.combine(PathOperation.difference, outer, inner);
  }

  @override
  bool shouldRepaint(covariant DecorPainter oldDelegate) {
    return oldDelegate.system != system ||
        oldDelegate.config != config ||
        oldDelegate.opacity != opacity ||
        oldDelegate.staticMode != staticMode;
  }
}
