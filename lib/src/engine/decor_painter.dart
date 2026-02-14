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
  final Path _buntingPath = Path();
  final Path _trianglePath = Path();

  static final Path _unitStarPath = _buildUnitStarPath();
  static final Path _unitCrescentPath = _buildUnitCrescentPath();
  static final Path _unitLanternBodyPath = _buildUnitLanternBodyPath();
  static final Path _unitLanternWindowPath = _buildUnitLanternWindowPath();
  static final Path _unitBalloonPath = _buildUnitBalloonPath();
  static final Path _unitHeartPath = _buildUnitHeartPath();
  static final Path _unitBatPath = _buildUnitBatPath();
  static final Path _unitPumpkinPath = _buildUnitPumpkinPath();
  static final Path _unitTrophyPath = _buildUnitTrophyPath();
  static const Rect _unitRect = Rect.fromLTRB(-0.5, -0.5, 0.5, 0.5);
  static const Rect _giftBoxRect = Rect.fromLTRB(-0.6, -0.2, 0.6, 0.6);
  static const Rect _giftLidRect = Rect.fromLTRB(-0.68, -0.45, 0.68, -0.2);
  static const Rect _giftBowLeft = Rect.fromLTRB(-0.38, -0.6, -0.06, -0.3);
  static const Rect _giftBowRight = Rect.fromLTRB(0.06, -0.6, 0.38, -0.3);
  static const Rect _ornamentCapRect =
      Rect.fromLTRB(-0.18, -0.78, 0.18, -0.62);
  static const List<Color> _garlandBulbColors = [
    Color(0xFFF9C74F),
    Color(0xFFF9844A),
    Color(0xFFF94144),
    Color(0xFF90BE6D),
    Color(0xFF43AA8B),
    Color(0xFF577590),
  ];
  static const List<Color> _buntingColors = [
    Color(0xFFE11D48),
    Color(0xFF2563EB),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF8B5CF6),
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

    final clampedOpacity = opacity.clamp(0.0, 1.0).toDouble();
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
      case BackdropType.candyGarland:
        _paintCandyGarland(canvas, size, opacity, backdrop);
        break;
      case BackdropType.bunting:
        _paintBunting(canvas, size, opacity, backdrop);
        break;
      case BackdropType.mosque:
        _paintMosque(canvas, size, opacity, backdrop);
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
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
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
    final width = height * 0.65;
    final base = Offset(
      size.width * backdrop.anchor.dx,
      size.height * backdrop.anchor.dy,
    );

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
    final treeColor = backdrop.color.withValues(alpha: combinedAlpha);
    final highlightColor = Color.lerp(
      treeColor,
      const Color(0xFF4ADE80),
      0.28,
    )!
        .withValues(alpha: combinedAlpha);
    final trunkColor = const Color(0xFF6D4C41)
        .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0).toDouble());

    for (var i = 0; i < 4; i += 1) {
      final t = i / 3;
      final layerTop = base.dy - height + i * height * 0.22;
      final layerHeight = height * (0.28 + i * 0.02);
      final layerWidth = width * (0.48 + i * 0.2);
      _treePath
        ..reset()
        ..moveTo(base.dx, layerTop)
        ..lineTo(base.dx - layerWidth, layerTop + layerHeight)
        ..lineTo(base.dx + layerWidth, layerTop + layerHeight)
        ..close();
      _paint
        ..color = Color.lerp(highlightColor, treeColor, t)!
        ..style = PaintingStyle.fill;
      canvas.drawPath(_treePath, _paint);
    }

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

    // Garland lines + red ornaments.
    final garlandColor = const Color(0xFFF5C542)
        .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0).toDouble());
    for (var i = 0; i < 2; i += 1) {
      final y = base.dy - height * (0.52 - i * 0.18);
      final amplitude = width * (0.12 + i * 0.03);
      _garlandPath
        ..reset()
        ..moveTo(base.dx - width * 0.45, y)
        ..quadraticBezierTo(
          base.dx,
          y + amplitude,
          base.dx + width * 0.45,
          y,
        );
      _paint
        ..color = garlandColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, width * 0.02)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_garlandPath, _paint);

      for (var j = 0; j <= 5; j += 1) {
        final t = j / 5;
        final point = _quadraticBezierPoint(
          Offset(base.dx - width * 0.45, y),
          Offset(base.dx, y + amplitude),
          Offset(base.dx + width * 0.45, y),
          t,
        );
        _paint
          ..color = const Color(0xFFD72638).withValues(
            alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.fill;
        canvas.drawCircle(point, width * 0.045, _paint);
      }
    }

    // Star topper.
    _paint
      ..color = const Color(0xFFF5C542).withValues(
        alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(base.dx, base.dy - height * 1.03);
    canvas.scale(width * 0.12, width * 0.12);
    canvas.drawPath(_unitStarPath, _paint);
    canvas.restore();

    if (!staticMode) {
      final ornamentAlpha = (combinedAlpha * 0.9).clamp(0.0, 1.0).toDouble();
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
    final amplitude = _resolveDecorativeAmplitude(size, backdrop);

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();

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

    final bulbCount = math.max(5, (width / 72).round());
    final bulbSpacing = width / bulbCount;
    final bulbRadius = math.min(
      math.max(2.0, amplitude * 0.18 + 1.0),
      bulbSpacing * 0.28,
    );
    for (var i = 0; i <= bulbCount; i += 1) {
      final t = i / bulbCount;
      final point = _quadraticBezierPoint(
        Offset(0, y),
        Offset(width * 0.5, y + amplitude),
        Offset(width, y),
        t,
      );
      final color = _garlandBulbColors[i % _garlandBulbColors.length]
          .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0).toDouble());
      _paint
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawCircle(point, bulbRadius, _paint);
    }
  }

  void _paintCandyGarland(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final width = size.width;
    final y = size.height * backdrop.anchor.dy;
    final amplitude = _resolveDecorativeAmplitude(size, backdrop);

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();

    _garlandPath
      ..reset()
      ..moveTo(0, y)
      ..quadraticBezierTo(width * 0.5, y + amplitude, width, y);

    _paint
      ..color = backdrop.color.withValues(alpha: combinedAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, amplitude * 0.1)
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_garlandPath, _paint);

    final itemCount = math.max(6, (width / 70).round());
    final itemSpacing = width / itemCount;
    final candySize = math.min(
      math.max(8.0, amplitude * 0.28),
      itemSpacing * 0.3,
    );
    final ballSize = math.min(
      math.max(4.0, amplitude * 0.2),
      itemSpacing * 0.22,
    );
    for (var i = 0; i <= itemCount; i += 1) {
      final t = i / itemCount;
      final point = _quadraticBezierPoint(
        Offset(0, y),
        Offset(width * 0.5, y + amplitude),
        Offset(width, y),
        t,
      );

      if (i.isEven) {
        // Candy cane.
        canvas.save();
        canvas.translate(point.dx, point.dy + ballSize * 0.35);
        canvas.scale(candySize, candySize);
        _paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.12
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFFFFFFFF)
              .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0));
        canvas.drawLine(const Offset(0, 0.45), const Offset(0, -0.2), _paint);
        canvas.drawArc(
           Rect.fromCircle(center: Offset(0.2, -0.2), radius: 0.2),
          math.pi,
          math.pi,
          false,
          _paint,
        );
        _paint
          ..strokeWidth = 0.08
          ..color = const Color(0xFFE63946)
              .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));
        canvas.drawLine(
          const Offset(0.06, 0.32),
          const Offset(-0.06, 0.22),
          _paint,
        );
        canvas.drawLine(
          const Offset(0.06, 0.14),
          const Offset(-0.06, 0.04),
          _paint,
        );
        canvas.drawLine(
          const Offset(0.06, -0.04),
          const Offset(-0.06, -0.14),
          _paint,
        );
        canvas.restore();
      } else {
        // Red ornament ball.
        _paint
          ..color = const Color(0xFFD72638)
              .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.drawCircle(point, ballSize * 0.55, _paint);
        _paint
          ..color = const Color(0xFFFFFFFF).withValues(
            alpha: (combinedAlpha * 0.35).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          point.translate(-ballSize * 0.15, -ballSize * 0.15),
          ballSize * 0.18,
          _paint,
        );
      }
    }
  }

  void _paintBunting(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final width = size.width;
    final y = size.height * backdrop.anchor.dy;
    final amplitude = _resolveDecorativeAmplitude(size, backdrop);

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();

    _buntingPath
      ..reset()
      ..moveTo(0, y)
      ..quadraticBezierTo(width * 0.5, y + amplitude, width, y);

    _paint
      ..color = backdrop.color.withValues(alpha: combinedAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.2, amplitude * 0.08)
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(_buntingPath, _paint);

    final flagCount = math.max(6, (width / 88).round());
    final flagSpacing = width / flagCount;
    final flagHeight = math.min(
      math.max(9.0, amplitude * 1.15),
      flagSpacing * 0.9,
    );
    final flagWidth = math.min(flagHeight * 0.86, flagSpacing * 0.82);
    for (var i = 0; i < flagCount; i += 1) {
      final t = (i + 0.5) / flagCount;
      final point = _quadraticBezierPoint(
        Offset(0, y),
        Offset(width * 0.5, y + amplitude),
        Offset(width, y),
        t,
      );
      _trianglePath
        ..reset()
        ..moveTo(point.dx - flagWidth * 0.5, point.dy)
        ..lineTo(point.dx + flagWidth * 0.5, point.dy)
        ..lineTo(point.dx, point.dy + flagHeight)
        ..close();
      final color = _buntingColors[i % _buntingColors.length]
          .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0).toDouble());
      _paint
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(_trianglePath, _paint);
    }
  }

  double _resolveDecorativeAmplitude(Size size, DecorBackdrop backdrop) {
    final shortest = math.min(size.width, size.height);
    final base = shortest * backdrop.sizeFactor;
    final maxByHeight = size.height * 0.14;
    return base.clamp(6.0, maxByHeight).toDouble();
  }

  void _paintMosque(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final shortest = math.min(size.width, size.height);
    final width = shortest * backdrop.sizeFactor;
    final height = width * 0.62;
    final center = Offset(
      size.width * backdrop.anchor.dx,
      size.height * backdrop.anchor.dy,
    );

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
    final primary = backdrop.color.withValues(alpha: combinedAlpha);
    final accent = const Color(0xFFF2C94C).withValues(alpha: combinedAlpha);
    final accentSoft = const Color(0xFFFFE6A3).withValues(
      alpha: (combinedAlpha * 0.75).clamp(0.0, 1.0),
    );

    _paint
      ..color = primary
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(center.dx, center.dy);

    final baseWidth = width * 0.92;
    final baseHeight = height * 0.44;
    final baseTop = height * 0.08;
    final baseRect = Rect.fromLTWH(
      -baseWidth * 0.5,
      baseTop,
      baseWidth,
      baseHeight,
    );
    final baseRRect = RRect.fromRectAndRadius(
      baseRect,
      Radius.circular(width * 0.04),
    );
    canvas.drawRRect(baseRRect, _paint);

    final platformRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        -width * 0.65,
        baseTop + baseHeight * 0.86,
        width * 1.3,
        height * 0.12,
      ),
      Radius.circular(width * 0.06),
    );
    canvas.drawRRect(platformRect, _paint);

    _paint.color = accent;
    final bandHeight = height * 0.04;
    canvas.drawRect(
      Rect.fromLTWH(
        -baseWidth * 0.5,
        baseTop + baseHeight * 0.14,
        baseWidth,
        bandHeight,
      ),
      _paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        -baseWidth * 0.5,
        baseTop + baseHeight * 0.5,
        baseWidth,
        bandHeight,
      ),
      _paint,
    );

    void drawOnionDome(Offset domeCenter, double radius) {
      final baseY = domeCenter.dy;
      final path = Path()
        ..moveTo(domeCenter.dx - radius, baseY)
        ..quadraticBezierTo(
          domeCenter.dx - radius * 0.65,
          baseY - radius * 0.9,
          domeCenter.dx,
          baseY - radius * 1.35,
        )
        ..quadraticBezierTo(
          domeCenter.dx + radius * 0.65,
          baseY - radius * 0.9,
          domeCenter.dx + radius,
          baseY,
        )
        ..lineTo(domeCenter.dx + radius, baseY + radius * 0.24)
        ..lineTo(domeCenter.dx - radius, baseY + radius * 0.24)
        ..close();
      _paint.color = primary;
      canvas.drawPath(path, _paint);
      _paint.color = accentSoft;
      canvas.drawCircle(
        Offset(domeCenter.dx - radius * 0.28, baseY - radius * 0.35),
        radius * 0.22,
        _paint,
      );
    }

    final mainDomeCenter = Offset(0, baseTop - height * 0.02);
    drawOnionDome(mainDomeCenter, width * 0.24);
    drawOnionDome(
      Offset(-width * 0.32, baseTop + height * 0.05),
      width * 0.15,
    );
    drawOnionDome(
      Offset(width * 0.32, baseTop + height * 0.05),
      width * 0.15,
    );

    void drawCrescent(Offset crescentCenter, double size) {
      _paint.color = accent;
      canvas.save();
      canvas.translate(crescentCenter.dx, crescentCenter.dy);
      canvas.scale(size, size);
      canvas.drawPath(_unitCrescentPath, _paint);
      canvas.restore();
    }

    drawCrescent(
      mainDomeCenter + Offset(0, -width * 0.32),
      width * 0.075,
    );
    drawCrescent(
      Offset(-width * 0.32, baseTop - height * 0.03),
      width * 0.05,
    );
    drawCrescent(
      Offset(width * 0.32, baseTop - height * 0.03),
      width * 0.05,
    );

    final doorWidth = baseWidth * 0.26;
    final doorHeight = baseHeight * 0.58;
    final doorTop = baseTop + baseHeight * 0.25;
    final doorRect = Rect.fromLTWH(
      -doorWidth * 0.5,
      doorTop,
      doorWidth,
      doorHeight,
    );
    final doorRadius = doorWidth * 0.5;
    final doorPath = Path()
      ..moveTo(doorRect.left, doorRect.bottom)
      ..lineTo(doorRect.left, doorRect.top + doorRadius)
      ..arcTo(
        Rect.fromCircle(
          center: Offset(0, doorRect.top + doorRadius),
          radius: doorRadius,
        ),
        math.pi,
        math.pi,
        false,
      )
      ..lineTo(doorRect.right, doorRect.bottom)
      ..close();
    _paint.color = accent;
    canvas.drawPath(doorPath, _paint);

    final windowWidth = baseWidth * 0.12;
    final windowHeight = baseHeight * 0.5;
    final windowTop = baseTop + baseHeight * 0.32;
    for (final dx in [-baseWidth * 0.28, baseWidth * 0.28]) {
      final rect = Rect.fromLTWH(
        dx - windowWidth * 0.5,
        windowTop,
        windowWidth,
        windowHeight,
      );
      final radius = windowWidth * 0.5;
      final path = Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top + radius)
        ..arcTo(
          Rect.fromCircle(
            center: Offset(dx, rect.top + radius),
            radius: radius,
          ),
          math.pi,
          math.pi,
          false,
        )
        ..lineTo(rect.right, rect.bottom)
        ..close();
      canvas.drawPath(path, _paint);
    }

    canvas.restore();
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
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
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
    final lifeFade =
        particle.kind == ParticleKind.spark ? particle.lifeProgress : 1.0;
    final combinedAlpha = (baseAlpha * particle.opacity * opacity * lifeFade)
        .clamp(0.0, 1.0)
        .toDouble();
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
      case ParticleShape.lantern:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitLanternBodyPath, _paint);
        final windowColor =
            Color.lerp(color, const Color(0xFFFFF1C2), 0.6)!
                .withValues(alpha: (combinedAlpha * 0.7).clamp(0.0, 1.0));
        _paint
          ..color = windowColor
          ..style = PaintingStyle.fill;
        canvas.drawPath(_unitLanternWindowPath, _paint);
        _paint
          ..color = windowColor.withValues(
            alpha: (combinedAlpha * 0.5).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.08;
        canvas.drawLine(const Offset(0, -0.32), const Offset(0, 0.32), _paint);
        canvas.drawLine(
          const Offset(-0.22, 0.02),
          const Offset(0.22, 0.02),
          _paint,
        );
        canvas.restore();
        break;
      case ParticleShape.balloon:
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        canvas.drawPath(_unitBalloonPath, _paint);
        final highlight = const Color(0xFFFFFFFF).withValues(
          alpha: (combinedAlpha * 0.45).clamp(0.0, 1.0),
        );
        _paint
          ..color = highlight
          ..style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(-0.18, -0.35), 0.12, _paint);
        _paint
          ..color = color.withValues(
            alpha: (combinedAlpha * 0.5).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.06;
        canvas.drawLine(const Offset(0, 0.72), const Offset(0, 1.45), _paint);
        canvas.restore();
        break;
      case ParticleShape.gift:
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        final baseColor = color;
        final stripeColor = const Color(0xFFFFFFFF)
            .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));
        final lidColor = Color.lerp(baseColor, const Color(0xFF000000), 0.12)!
            .withValues(alpha: combinedAlpha);

        _paint
          ..color = baseColor
          ..style = PaintingStyle.fill;
        canvas.drawRect(_giftBoxRect, _paint);

        // Diagonal stripes (body).
        canvas.save();
        canvas.clipRect(_giftBoxRect);
        canvas.rotate(math.pi / 4);
        _paint
          ..color = stripeColor
          ..style = PaintingStyle.fill;
        for (var x = -1.6; x <= 1.6; x += 0.28) {
          canvas.drawRect(Rect.fromLTWH(x, -2.0, 0.12, 4.0), _paint);
        }
        canvas.restore();

        _paint.color = lidColor;
        canvas.drawRect(_giftLidRect, _paint);

        // Diagonal stripes (lid).
        canvas.save();
        canvas.clipRect(_giftLidRect);
        canvas.rotate(math.pi / 4);
        _paint.color = stripeColor;
        for (var x = -1.6; x <= 1.6; x += 0.28) {
          canvas.drawRect(Rect.fromLTWH(x, -2.0, 0.12, 4.0), _paint);
        }
        canvas.restore();

        final ribbonColor = const Color(0xFFE11D48)
            .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0));
        _paint.color = ribbonColor;
        canvas.drawRect(const Rect.fromLTRB(-0.08, -0.45, 0.08, 0.6), _paint);
        canvas.drawRect(const Rect.fromLTRB(-0.6, 0.12, 0.6, 0.24), _paint);
        canvas.drawOval(_giftBowLeft, _paint);
        canvas.drawOval(_giftBowRight, _paint);
        canvas.drawCircle(const Offset(0, -0.36), 0.08, _paint);
        canvas.restore();
        break;
      case ParticleShape.ornament:
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset.zero, 0.55, _paint);
        _paint
          ..color = const Color(0xFFD4AF37)
              .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.drawRect(_ornamentCapRect, _paint);
        _paint
          ..color = const Color(0xFFFFFFFF).withValues(
            alpha: (combinedAlpha * 0.35).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(-0.2, -0.2), 0.16, _paint);
        _paint
          ..color = const Color(0xFFD4AF37)
              .withValues(alpha: (combinedAlpha * 0.7).clamp(0.0, 1.0))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.06
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(const Offset(0, -0.62), const Offset(0, -1.05), _paint);
        canvas.restore();
        break;
      case ParticleShape.sheep:
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.scale(particle.size, particle.size);

        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(0.0, 0.08), 0.62, _paint);
        canvas.drawCircle(const Offset(-0.42, -0.1), 0.34, _paint);
        canvas.drawCircle(const Offset(0.42, -0.1), 0.34, _paint);
        canvas.drawCircle(const Offset(0.0, -0.28), 0.38, _paint);
        canvas.drawCircle(const Offset(-0.18, 0.35), 0.28, _paint);
        canvas.drawCircle(const Offset(0.18, 0.35), 0.28, _paint);

        final faceColor =
            Color.lerp(color, const Color(0xFF2B2B2B), 0.6)!
                .withValues(alpha: combinedAlpha);
        _paint.color = faceColor;
        canvas.drawCircle(const Offset(0.72, 0.05), 0.26, _paint);
        canvas.drawCircle(const Offset(0.86, -0.05), 0.07, _paint);
        canvas.drawCircle(const Offset(0.86, 0.18), 0.07, _paint);

        _paint
          ..color = faceColor.withValues(
            alpha: (combinedAlpha * 0.8).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.fill;
        canvas.drawCircle(const Offset(0.8, 0.05), 0.04, _paint);

        _paint
          ..color = faceColor.withValues(
            alpha: (combinedAlpha * 0.7).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.fill;
        canvas.drawRect(const Rect.fromLTRB(-0.35, 0.68, -0.25, 0.95), _paint);
        canvas.drawRect(const Rect.fromLTRB(-0.05, 0.68, 0.05, 0.95), _paint);
        canvas.drawRect(const Rect.fromLTRB(0.25, 0.68, 0.35, 0.95), _paint);

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
    final outer = Path()
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: 1));
    final inner = Path()
      ..addOval(
        Rect.fromCircle(
          center: const Offset(0.4, 0),
          radius: 0.8,
        ),
      );
    return Path.combine(PathOperation.difference, outer, inner);
  }

  static Path _buildUnitLanternBodyPath() {
    final path = Path()
      ..addRect(const Rect.fromLTRB(-0.2, -1.0, 0.2, -0.86))
      ..moveTo(-0.45, -0.86)
      ..lineTo(0.45, -0.86)
      ..lineTo(0.3, -0.65)
      ..lineTo(-0.3, -0.65)
      ..close()
      ..moveTo(-0.7, -0.65)
      ..lineTo(0.7, -0.65)
      ..lineTo(0.55, 0.55)
      ..lineTo(-0.55, 0.55)
      ..close()
      ..addRect(const Rect.fromLTRB(-0.45, 0.55, 0.45, 0.75))
      ..addOval( Rect.fromCircle(center: Offset(0, 0.9), radius: 0.09));
    return path;
  }

  static Path _buildUnitLanternWindowPath() {
    final path = Path()
      ..moveTo(-0.38, -0.45)
      ..lineTo(0.38, -0.45)
      ..lineTo(0.3, 0.35)
      ..lineTo(-0.3, 0.35)
      ..close();
    return path;
  }

  static Path _buildUnitBalloonPath() {
    final path = Path()
      ..addOval(const Rect.fromLTRB(-0.55, -0.95, 0.55, 0.6))
      ..moveTo(-0.14, 0.55)
      ..lineTo(0.14, 0.55)
      ..lineTo(0.0, 0.78)
      ..close();
    return path;
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
