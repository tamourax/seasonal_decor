import 'dart:math' as math;

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

  /// Whether to paint particles (backdrops still render).
  final bool paintParticles;

  /// Whether to paint backdrops.
  final bool showBackdrop;

  final Paint _paint = Paint()..isAntiAlias = true;
  final Path _treePath = Path();
  final Path _garlandPath = Path();

  static final Path _unitStarPath = _buildUnitStarPath();
  static final Path _unitCrescentPath = _buildUnitCrescentPath();
  static final Path _unitHeartPath = _buildUnitHeartPath();
  static final Path _unitBatPath = _buildUnitBatPath();
  static final Path _unitPumpkinPath = _buildUnitPumpkinPath();
  static final Path _unitTrophyPath = _buildUnitTrophyPath();
  static const Rect _unitRect = Rect.fromLTRB(-0.5, -0.5, 0.5, 0.5);
  static const List<Color> _garlandBulbColors = [
    Color(0xFFF9C74F),
    Color(0xFFF9844A),
    Color(0xFFF94144),
    Color(0xFF90BE6D),
    Color(0xFF43AA8B),
    Color(0xFF577590),
  ];
  static const List<Color> _treeOrnamentColors = [
    Color(0xFFF94144),
    Color(0xFFF9C74F),
    Color(0xFF90BE6D),
  ];
  static const List<Offset> _treeOrnamentOffsets = [
    Offset(-0.2, -0.55),
    Offset(0.15, -0.45),
    Offset(-0.05, -0.25),
  ];

  DecorPainter({
    required this.system,
    required this.config,
    required this.opacity,
    required this.staticMode,
    required this.paintParticles,
    required this.showBackdrop,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    system.setBounds(size);

    final clampedOpacity = opacity.clamp(0.0, 1.0) as double;
    if (showBackdrop) {
      _paintBackdrop(canvas, size, clampedOpacity);
    }

    if (paintParticles) {
      final particles = system.particles;
      final step = staticMode ? 3 : 1;
      for (var i = 0; i < particles.length; i += step) {
        final particle = particles[i];
        if (!particle.active) {
          continue;
        }
        if (staticMode && particle.kind == ParticleKind.rocket) {
          continue;
        }
        _paintParticle(canvas, particle, clampedOpacity);
      }
    }
  }

  void _paintBackdrop(Canvas canvas, Size size, double opacity) {
    if (config.backdrops.isNotEmpty) {
      for (final backdrop in config.backdrops) {
        _paintBackdropItem(canvas, size, opacity, backdrop);
      }
      return;
    }
    final backdrop = config.backdrop;
    if (backdrop == null) {
      return;
    }
    _paintBackdropItem(canvas, size, opacity, backdrop);
  }

  void _paintBackdropItem(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    switch (backdrop.type) {
      case BackdropType.crescent:
        _paintCrescentBackdrop(canvas, size, opacity, backdrop);
        break;
      case BackdropType.tree:
        _paintTree(canvas, size, opacity, backdrop);
        break;
      case BackdropType.garland:
        _paintGarland(canvas, size, opacity, backdrop);
        break;
      case BackdropType.trophy:
        _paintTrophy(canvas, size, opacity, backdrop);
        break;
    }
  }

  void _paintCrescentBackdrop(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final shortest = math.min(size.width, size.height);
    final radius = shortest * backdrop.sizeFactor;
    final center = Offset(
      size.width * backdrop.anchor.dx,
      size.height * backdrop.anchor.dy,
    );
    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0) as double;
    final color = backdrop.color.withValues(alpha: combinedAlpha);
    _paint
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(radius, radius);
    canvas.drawPath(_unitCrescentPath, _paint);
    canvas.restore();
  }

  void _paintTree(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final shortest = math.min(size.width, size.height);
    final height = shortest * backdrop.sizeFactor;
    final width = height * 0.6;
    final base = Offset(
      size.width * backdrop.anchor.dx,
      size.height * backdrop.anchor.dy,
    );

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0) as double;
    final treeColor = backdrop.color.withValues(alpha: combinedAlpha);
    final trunkColor = const Color(0xFF6D4C41)
        .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0) as double);

    _treePath
      ..reset()
      ..moveTo(base.dx, base.dy - height)
      ..lineTo(base.dx - width * 0.55, base.dy - height * 0.6)
      ..lineTo(base.dx + width * 0.55, base.dy - height * 0.6)
      ..close()
      ..moveTo(base.dx, base.dy - height * 0.7)
      ..lineTo(base.dx - width * 0.7, base.dy - height * 0.25)
      ..lineTo(base.dx + width * 0.7, base.dy - height * 0.25)
      ..close()
      ..moveTo(base.dx, base.dy - height * 0.4)
      ..lineTo(base.dx - width * 0.8, base.dy)
      ..lineTo(base.dx + width * 0.8, base.dy)
      ..close();

    _paint
      ..color = treeColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(_treePath, _paint);

    final trunkHeight = height * 0.18;
    final trunkWidth = width * 0.2;
    final trunkRect = Rect.fromCenter(
      center: Offset(base.dx, base.dy - trunkHeight * 0.5),
      width: trunkWidth,
      height: trunkHeight,
    );
    _paint
      ..color = trunkColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(trunkRect, _paint);

    if (!staticMode) {
      final ornamentAlpha = (combinedAlpha * 0.9).clamp(0.0, 1.0) as double;
      for (var i = 0; i < _treeOrnamentOffsets.length; i += 1) {
        final offset = _treeOrnamentOffsets[i];
        final position = Offset(
          base.dx + offset.dx * width,
          base.dy + offset.dy * height,
        );
        _paint
          ..color = _treeOrnamentColors[i].withValues(alpha: ornamentAlpha)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(position, width * 0.05, _paint);
      }
    }
  }

  void _paintGarland(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final width = size.width;
    final y = size.height * backdrop.anchor.dy;
    final amplitude = size.height * backdrop.sizeFactor;

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0) as double;

    _garlandPath
      ..reset()
      ..moveTo(0, y)
      ..quadraticBezierTo(width * 0.5, y + amplitude, width, y);

    _paint
      ..color = backdrop.color.withValues(alpha: combinedAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, amplitude * 0.12)
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_garlandPath, _paint);

    final bulbCount = 8;
    for (var i = 0; i <= bulbCount; i += 1) {
      final t = i / bulbCount;
      final point = _quadraticBezierPoint(
        Offset(0, y),
        Offset(width * 0.5, y + amplitude),
        Offset(width, y),
        t,
      );
      final color = _garlandBulbColors[i % _garlandBulbColors.length]
          .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0) as double);
      _paint
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, amplitude * 0.22 + 2.0, _paint);
    }
  }

  void _paintTrophy(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final shortest = math.min(size.width, size.height);
    final scale = shortest * backdrop.sizeFactor;
    final center = Offset(
      size.width * backdrop.anchor.dx,
      size.height * backdrop.anchor.dy,
    );
    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0) as double;
    final color = backdrop.color.withValues(alpha: combinedAlpha);
    _paint
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale, scale);
    canvas.drawPath(_unitTrophyPath, _paint);
    canvas.restore();
  }

  void _paintParticle(Canvas canvas, Particle particle, double opacity) {
    final baseAlpha = particle.color.a;
    final lifeFade = particle.kind == ParticleKind.spark
        ? particle.lifeProgress
        : 1.0;
    final combinedAlpha =
        (baseAlpha * particle.opacity * opacity * lifeFade)
            .clamp(0.0, 1.0) as double;
    final color = particle.color.withValues(alpha: combinedAlpha);

    switch (particle.shape) {
      case ParticleShape.circle:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(particle.position, particle.size, _paint);
        break;
      case ParticleShape.star:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitStarPath, _paint);
        canvas.restore();
        break;
      case ParticleShape.sparkle:
        _paint
          ..color =
              color.withValues(alpha: (combinedAlpha * 0.35).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(particle.position, particle.size * 0.7, _paint);
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitStarPath, _paint);
        canvas.restore();
        break;
      case ParticleShape.crescent:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitCrescentPath, _paint);
        canvas.restore();
        break;
      case ParticleShape.line:
        final length = particle.size;
        final thickness = math.max(1.0, length * 0.16);
        _paint
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness
          ..strokeCap = StrokeCap.round;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.drawLine(
          Offset(-length * 0.5, 0),
          Offset(length * 0.5, 0),
          _paint,
        );
        canvas.restore();
        break;
      case ParticleShape.heart:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitHeartPath, _paint);
        canvas.restore();
        break;
      case ParticleShape.bat:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitBatPath, _paint);
        canvas.restore();
        break;
      case ParticleShape.pumpkin:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitPumpkinPath, _paint);
        canvas.restore();
        break;
      case ParticleShape.confettiRect:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size * 0.4);
        canvas.drawRect(_unitRect, _paint);
        canvas.restore();
        break;
      case ParticleShape.ball:
        final strokeWidth = math.max(1.0, particle.size * 0.2);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        _paint
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth;
        canvas.drawCircle(Offset.zero, particle.size, _paint);
        _paint
          ..color =
              color.withValues(alpha: (combinedAlpha * 0.7).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, particle.size * 0.18, _paint);
        canvas.restore();
        break;
    }
  }

  static Path _buildUnitStarPath() {
    const points = 5;
    const outerRadius = 1.0;
    const innerRadius = 0.5;
    final path = Path();
    for (var i = 0; i < points * 2; i += 1) {
      final isOuter = i.isEven;
      final r = isOuter ? outerRadius : innerRadius;
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

  static Path _buildUnitCrescentPath() {
    final outer = Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: 1));
    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(0.4, 0),
          radius: 0.8,
        ),
      );
    return Path.combine(PathOperation.difference, outer, inner);
  }

  static Path _buildUnitHeartPath() {
    final path = Path()
      ..moveTo(0.0, 0.9)
      ..cubicTo(0.9, 0.35, 0.9, -0.25, 0.0, -0.2)
      ..cubicTo(-0.9, -0.25, -0.9, 0.35, 0.0, 0.9)
      ..close();
    return path;
  }

  static Path _buildUnitBatPath() {
    final path = Path()
      ..moveTo(-1.0, 0.2)
      ..lineTo(-0.7, -0.1)
      ..lineTo(-0.4, 0.15)
      ..lineTo(-0.2, -0.05)
      ..lineTo(0.0, -0.25)
      ..lineTo(0.2, -0.05)
      ..lineTo(0.4, 0.15)
      ..lineTo(0.7, -0.1)
      ..lineTo(1.0, 0.2)
      ..lineTo(0.6, 0.55)
      ..lineTo(0.25, 0.35)
      ..lineTo(0.0, 0.65)
      ..lineTo(-0.25, 0.35)
      ..lineTo(-0.6, 0.55)
      ..close();
    return path;
  }

  static Path _buildUnitPumpkinPath() {
    final path = Path()
      ..addOval(const Rect.fromLTRB(-1.0, -0.8, 1.0, 0.9))
      ..addRect(const Rect.fromLTRB(-0.2, -1.05, 0.2, -0.65));
    return path;
  }

  static Path _buildUnitTrophyPath() {
    final path = Path()
      ..moveTo(-0.8, -0.6)
      ..lineTo(0.8, -0.6)
      ..lineTo(0.6, 0.0)
      ..lineTo(0.25, 0.0)
      ..lineTo(0.2, 0.35)
      ..lineTo(0.5, 0.35)
      ..lineTo(0.5, 0.7)
      ..lineTo(-0.5, 0.7)
      ..lineTo(-0.5, 0.35)
      ..lineTo(-0.2, 0.35)
      ..lineTo(-0.25, 0.0)
      ..lineTo(-0.6, 0.0)
      ..close();
    return path;
  }

  Offset _quadraticBezierPoint(
    Offset p0,
    Offset p1,
    Offset p2,
    double t,
  ) {
    final oneMinusT = 1.0 - t;
    final x = oneMinusT * oneMinusT * p0.dx +
        2 * oneMinusT * t * p1.dx +
        t * t * p2.dx;
    final y = oneMinusT * oneMinusT * p0.dy +
        2 * oneMinusT * t * p1.dy +
        t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant DecorPainter oldDelegate) {
    return oldDelegate.system != system ||
        oldDelegate.config != config ||
        oldDelegate.opacity != opacity ||
        oldDelegate.staticMode != staticMode ||
        oldDelegate.paintParticles != paintParticles ||
        oldDelegate.showBackdrop != showBackdrop;
  }
}
