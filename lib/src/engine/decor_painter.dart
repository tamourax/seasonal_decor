import 'dart:math' as math;
import 'dart:ui' as ui;

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

  /// Density multiplier for decorative backdrop details.
  final double decorativeBackdropDensityMultiplier;

  /// Optional row override for decorative string backdrops.
  final int? decorativeBackdropRows;

  /// Optional row override for Ramadan bunting backdrop.
  final int? ramadanBuntingRows;

  final Paint _paint = Paint()..isAntiAlias = true;
  final Path _treePath = Path();
  final Path _garlandPath = Path();
  final Path _buntingPath = Path();
  final Path _trianglePath = Path();
  final Path _diamondPath = Path();
  final Path _seamPath = Path();

  static const int _maxBackdropCacheEntries = 24;
  static final Map<_BackdropCacheKey, ui.Picture> _backdropPictureCache = {};
  static final List<_BackdropCacheKey> _backdropCacheOrder = [];

  static final Path _unitStarPath = _buildUnitStarPath();
  static final Path _unitCrescentPath = _buildUnitCrescentPath();
  static final Path _unitLanternBodyPath = _buildUnitLanternBodyPath();
  static final Path _unitLanternWindowPath = _buildUnitLanternWindowPath();
  static final Path _unitBalloonPath = _buildUnitBalloonPath();
  static final Path _unitHeartPath = _buildUnitHeartPath();
  static final Path _unitBatPath = _buildUnitBatPath();
  static final Path _unitPumpkinPath = _buildUnitPumpkinPath();
  static final Path _unitTrophyPath = _buildUnitTrophyPath();
  static final Path _unitPentagonPath = _buildUnitPentagonPath();
  static const Rect _unitRect = Rect.fromLTRB(-0.5, -0.5, 0.5, 0.5);
  static const Rect _giftBoxRect = Rect.fromLTRB(-0.6, -0.2, 0.6, 0.6);
  static const Rect _giftLidRect = Rect.fromLTRB(-0.68, -0.45, 0.68, -0.2);
  static const Rect _giftBowLeft = Rect.fromLTRB(-0.38, -0.6, -0.06, -0.3);
  static const Rect _giftBowRight = Rect.fromLTRB(0.06, -0.6, 0.38, -0.3);
  static const Rect _ornamentCapRect = Rect.fromLTRB(-0.18, -0.78, 0.18, -0.62);
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
    required this.decorativeBackdropDensityMultiplier,
    required this.decorativeBackdropRows,
    required this.ramadanBuntingRows,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clampedOpacity = opacity.clamp(0.0, 1.0).toDouble();
    if (showBackdrop) {
      if (!paintParticles) {
        final key = _BackdropCacheKey(
          width: size.width,
          height: size.height,
          opacity: clampedOpacity,
          density: decorativeBackdropDensityMultiplier,
          rows: decorativeBackdropRows ?? -1,
          ramadanRows: ramadanBuntingRows ?? -1,
          staticMode: staticMode,
          configHash: _backdropConfigHash(config),
        );
        final cached = _backdropPictureCache[key];
        if (cached != null) {
          canvas.drawPicture(cached);
        } else {
          final recorder = ui.PictureRecorder();
          final backdropCanvas = Canvas(recorder);
          _paintBackdrop(backdropCanvas, size, clampedOpacity);
          final picture = recorder.endRecording();
          _storeBackdropCache(key, picture);
          canvas.drawPicture(picture);
        }
      } else {
        _paintBackdrop(canvas, size, clampedOpacity);
      }
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
      case BackdropType.football:
        _paintFootballBackdrop(canvas, size, opacity, backdrop);
        break;
      case BackdropType.lantern:
        _paintLanternBackdrop(canvas, size, opacity, backdrop);
        break;
      case BackdropType.pumpkin:
        _paintPumpkinBackdrop(canvas, size, opacity, backdrop);
        break;
      case BackdropType.ramadanLights:
        _paintRamadanLights(canvas, size, opacity, backdrop);
        break;
      case BackdropType.ramadanBunting:
        _paintRamadanBunting(canvas, size, opacity, backdrop);
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
    final density =
        decorativeBackdropDensityMultiplier.clamp(0.35, 2.5).toDouble();
    final width = size.width;
    final y = size.height * backdrop.anchor.dy;
    final amplitude = _resolveDecorativeAmplitude(size, backdrop);
    final rowCount = decorativeBackdropRows?.clamp(1, 6) ?? 1;
    final rowGap = (amplitude * 1.55).clamp(12.0, size.height * 0.12);
    const widthPattern = <double>[1.0, 0.86, 0.93, 0.78, 0.88, 0.74];
    const offsetPattern = <double>[0.0, -0.04, 0.03, -0.06, 0.04, -0.02];

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
    final ropeColor = backdrop.color.withValues(alpha: combinedAlpha);
    final bulbPalette = [
      for (final color in _garlandBulbColors)
        color.withValues(
            alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0).toDouble()),
    ];

    for (var row = 0; row < rowCount; row += 1) {
      final rowY = y + row * rowGap;
      final rowSpan = (width * widthPattern[row % widthPattern.length])
          .clamp(width * 0.6, width * 1.02)
          .toDouble();
      final rowCenterX =
          width * (0.5 + offsetPattern[row % offsetPattern.length]);
      final leftX = rowCenterX - rowSpan * 0.5;
      final rightX = rowCenterX + rowSpan * 0.5;
      final rowAmplitude = (amplitude * (0.84 + (row % 3) * 0.11))
          .clamp(6.0, size.height * 0.14)
          .toDouble();

      _garlandPath
        ..reset()
        ..moveTo(leftX, rowY)
        ..quadraticBezierTo(rowCenterX, rowY + rowAmplitude, rightX, rowY);

      _paint
        ..color = ropeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, rowAmplitude * 0.12)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_garlandPath, _paint);

      final bulbCount = math.max(4, ((rowSpan / 72) * density).round());
      final bulbSpacing = rowSpan / bulbCount;
      final bulbRadius = math.min(
        math.max(2.0, rowAmplitude * 0.18 + 1.0),
        bulbSpacing * 0.28,
      );
      for (var i = 0; i <= bulbCount; i += 1) {
        final t = i / bulbCount;
        final point = _quadraticBezierPoint(
          Offset(leftX, rowY),
          Offset(rowCenterX, rowY + rowAmplitude),
          Offset(rightX, rowY),
          t,
        );
        final color = bulbPalette[(i + row) % bulbPalette.length];
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(point, bulbRadius, _paint);
      }
    }
  }

  void _paintCandyGarland(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final density =
        decorativeBackdropDensityMultiplier.clamp(0.35, 2.5).toDouble();
    final width = size.width;
    final y = size.height * backdrop.anchor.dy;
    final amplitude = _resolveDecorativeAmplitude(size, backdrop);
    final rowCount = decorativeBackdropRows?.clamp(1, 6) ?? 1;
    final rowGap = (amplitude * 1.6).clamp(12.0, size.height * 0.12);
    const widthPattern = <double>[1.0, 0.86, 0.93, 0.78, 0.88, 0.74];
    const offsetPattern = <double>[0.0, -0.04, 0.03, -0.06, 0.04, -0.02];

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
    final ropeColor = backdrop.color.withValues(alpha: combinedAlpha);

    for (var row = 0; row < rowCount; row += 1) {
      final rowY = y + row * rowGap;
      final rowSpan = (width * widthPattern[row % widthPattern.length])
          .clamp(width * 0.6, width * 1.02)
          .toDouble();
      final rowCenterX =
          width * (0.5 + offsetPattern[row % offsetPattern.length]);
      final leftX = rowCenterX - rowSpan * 0.5;
      final rightX = rowCenterX + rowSpan * 0.5;
      final rowAmplitude = (amplitude * (0.82 + (row % 3) * 0.11))
          .clamp(6.0, size.height * 0.14)
          .toDouble();

      _garlandPath
        ..reset()
        ..moveTo(leftX, rowY)
        ..quadraticBezierTo(rowCenterX, rowY + rowAmplitude, rightX, rowY);

      _paint
        ..color = ropeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, rowAmplitude * 0.1)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_garlandPath, _paint);

      final itemCount = math.max(4, ((rowSpan / 70) * density).round());
      final itemSpacing = rowSpan / itemCount;
      final candySize = math.min(
        math.max(8.0, rowAmplitude * 0.28),
        itemSpacing * 0.3,
      );
      final ballSize = math.min(
        math.max(4.0, rowAmplitude * 0.2),
        itemSpacing * 0.22,
      );
      for (var i = 0; i <= itemCount; i += 1) {
        final t = i / itemCount;
        final point = _quadraticBezierPoint(
          Offset(leftX, rowY),
          Offset(rowCenterX, rowY + rowAmplitude),
          Offset(rightX, rowY),
          t,
        );

        if ((i + row).isEven) {
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
          canvas.drawLine(
            const Offset(0, 0.45),
            const Offset(0, -0.2),
            _paint,
          );
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
  }

  void _paintBunting(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final density =
        decorativeBackdropDensityMultiplier.clamp(0.35, 2.5).toDouble();
    final width = size.width;
    final y = size.height * backdrop.anchor.dy;
    final amplitude = _resolveDecorativeAmplitude(size, backdrop);
    final rowCount = decorativeBackdropRows?.clamp(1, 6) ?? 1;
    final rowGap = (amplitude * 1.6).clamp(12.0, size.height * 0.12);
    const widthPattern = <double>[1.0, 0.86, 0.93, 0.78, 0.88, 0.74];
    const offsetPattern = <double>[0.0, -0.04, 0.03, -0.06, 0.04, -0.02];

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
    final ropeColor = backdrop.color.withValues(alpha: combinedAlpha);
    final buntingPalette = [
      for (final color in _buntingColors)
        color.withValues(
            alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0).toDouble()),
    ];

    for (var row = 0; row < rowCount; row += 1) {
      final rowY = y + row * rowGap;
      final rowSpan = (width * widthPattern[row % widthPattern.length])
          .clamp(width * 0.6, width * 1.02)
          .toDouble();
      final rowCenterX =
          width * (0.5 + offsetPattern[row % offsetPattern.length]);
      final leftX = rowCenterX - rowSpan * 0.5;
      final rightX = rowCenterX + rowSpan * 0.5;
      final rowAmplitude = (amplitude * (0.86 + (row % 3) * 0.1))
          .clamp(6.0, size.height * 0.14)
          .toDouble();

      _buntingPath
        ..reset()
        ..moveTo(leftX, rowY)
        ..quadraticBezierTo(rowCenterX, rowY + rowAmplitude, rightX, rowY);

      _paint
        ..color = ropeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, rowAmplitude * 0.08)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_buntingPath, _paint);

      final flagCount = math.max(4, ((rowSpan / 88) * density).round());
      final flagSpacing = rowSpan / flagCount;
      final flagHeight = math.min(
        math.max(9.0, rowAmplitude * 1.15),
        flagSpacing * 0.9,
      );
      final flagWidth = math.min(flagHeight * 0.86, flagSpacing * 0.82);
      for (var i = 0; i < flagCount; i += 1) {
        final t = (i + 0.5) / flagCount;
        final point = _quadraticBezierPoint(
          Offset(leftX, rowY),
          Offset(rowCenterX, rowY + rowAmplitude),
          Offset(rightX, rowY),
          t,
        );
        _trianglePath
          ..reset()
          ..moveTo(point.dx - flagWidth * 0.5, point.dy)
          ..lineTo(point.dx + flagWidth * 0.5, point.dy)
          ..lineTo(point.dx, point.dy + flagHeight)
          ..close();
        final color = buntingPalette[(i + row) % buntingPalette.length];
        _paint
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawPath(_trianglePath, _paint);
      }
    }
  }

  void _paintRamadanBunting(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    const fabricColors = <Color>[
      Color(0xFFD63A2E),
      Color(0xFFE65A2D),
      Color(0xFF1C4FA3),
      Color(0xFFF2E7D1),
      Color(0xFF2E7D5A),
    ];
    const accentColors = <Color>[
      Color(0xFFF4D03F),
      Color(0xFFFFFFFF),
      Color(0xFFCF2F24),
      Color(0xFF2E5EB8),
    ];
    const tasselColors = <Color>[
      Color(0xFF0F172A),
      Color(0xFFD63A2E),
      Color(0xFF1D4ED8),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
    ];

    final density =
        decorativeBackdropDensityMultiplier.clamp(0.45, 2.5).toDouble();
    final width = size.width;
    final shortest = math.min(size.width, size.height);
    final startY = size.height * backdrop.anchor.dy;
    final baseAmplitude = _resolveDecorativeAmplitude(size, backdrop);
    final autoStrandCount = density > 2.0
        ? 5
        : density > 1.35
            ? 4
            : 3;
    final strandCount = ramadanBuntingRows?.clamp(1, 6) ??
        decorativeBackdropRows?.clamp(1, 6) ??
        autoStrandCount;
    final baseStrandGap =
        (shortest * backdrop.sizeFactor * 1.65).clamp(14.0, 36.0).toDouble();
    var strandGap = baseStrandGap;
    if (strandCount > 1) {
      final maxGapByViewport =
          ((size.height * 0.62) - startY) / (strandCount - 1);
      strandGap = math.min(
        baseStrandGap,
        maxGapByViewport.clamp(12.0, 38.0).toDouble(),
      );
    }

    const widthPattern = <double>[1.06, 0.82, 0.94, 0.72, 0.86, 0.68];
    const offsetPattern = <double>[0.0, -0.05, 0.04, -0.08, 0.06, -0.03];
    const sagPattern = <double>[0.92, 1.18, 0.86, 1.12, 0.95, 1.04];

    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();
    final ropeColor = Color.lerp(backdrop.color, const Color(0xFFECD9A0), 0.55)!
        .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));

    for (var strand = 0; strand < strandCount; strand += 1) {
      final y =
          startY + strand * strandGap + (strand.isOdd ? shortest * 0.004 : 0);
      final amplitude = (baseAmplitude * sagPattern[strand % sagPattern.length])
          .clamp(8.0, size.height * 0.16)
          .toDouble();
      final span = (width * widthPattern[strand % widthPattern.length])
          .clamp(width * 0.56, width * 1.12)
          .toDouble();
      final centerX =
          width * (0.5 + offsetPattern[strand % offsetPattern.length]);
      final leftX = centerX - span * 0.5;
      final rightX = centerX + span * 0.5;
      final controlY = y + amplitude;

      _buntingPath
        ..reset()
        ..moveTo(leftX, y)
        ..quadraticBezierTo(centerX, controlY, rightX, y);
      _paint
        ..color = ropeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.2, shortest * 0.003)
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(_buntingPath, _paint);

      final flagCount =
          math.max(3, ((span / (108 - strand * 7)) * density).round());
      final flagHeightBase =
          (shortest * backdrop.sizeFactor * 1.6).clamp(13.0, 32.0).toDouble();

      for (var i = 0; i < flagCount; i += 1) {
        final t = (i + 0.5) / flagCount;
        final top = _quadraticBezierPoint(
          Offset(leftX, y),
          Offset(centerX, controlY),
          Offset(rightX, y),
          t,
        ).translate(
          0,
          ((i % 3) - 1) * shortest * 0.0022,
        );
        final flagHeight = flagHeightBase * (0.88 + ((i + strand) % 3) * 0.1);
        final slotWidth = span / flagCount;
        final flagWidth = math.min(
          flagHeight * 0.82,
          slotWidth * 0.92,
        );

        final fabric = fabricColors[(i + strand) % fabricColors.length]
            .withValues(alpha: (combinedAlpha * 0.97).clamp(0.0, 1.0));
        final accent = accentColors[(i * 2 + strand) % accentColors.length]
            .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));
        final outline = Color.lerp(fabric, const Color(0xFF4C2B1A), 0.42)!
            .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));

        _trianglePath
          ..reset()
          ..moveTo(top.dx - flagWidth * 0.5, top.dy)
          ..lineTo(top.dx + flagWidth * 0.5, top.dy)
          ..lineTo(top.dx, top.dy + flagHeight)
          ..close();
        _paint
          ..color = fabric
          ..style = PaintingStyle.fill;
        canvas.drawPath(_trianglePath, _paint);

        _diamondPath
          ..reset()
          ..moveTo(top.dx, top.dy + flagHeight * 0.18)
          ..lineTo(top.dx + flagWidth * 0.18, top.dy + flagHeight * 0.36)
          ..lineTo(top.dx, top.dy + flagHeight * 0.54)
          ..lineTo(top.dx - flagWidth * 0.18, top.dy + flagHeight * 0.36)
          ..close();
        _paint.color = accent;
        canvas.drawPath(_diamondPath, _paint);

        _paint
          ..color = accent.withValues(
            alpha: (combinedAlpha * 0.76).clamp(0.0, 1.0),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.9, flagWidth * 0.035)
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(top.dx - flagWidth * 0.35, top.dy + flagHeight * 0.22),
          Offset(top.dx + flagWidth * 0.35, top.dy + flagHeight * 0.5),
          _paint,
        );
        canvas.drawLine(
          Offset(top.dx + flagWidth * 0.35, top.dy + flagHeight * 0.22),
          Offset(top.dx - flagWidth * 0.35, top.dy + flagHeight * 0.5),
          _paint,
        );
        canvas.drawLine(
          Offset(top.dx - flagWidth * 0.28, top.dy + flagHeight * 0.12),
          Offset(top.dx + flagWidth * 0.28, top.dy + flagHeight * 0.12),
          _paint,
        );

        _paint
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.8, flagWidth * 0.03);
        canvas.drawPath(_trianglePath, _paint);

        _paint
          ..color =
              accent.withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(top.dx, top.dy + flagHeight * 0.36);
        canvas.scale(flagWidth * 0.08, flagWidth * 0.08);
        canvas.drawPath(_unitStarPath, _paint);
        canvas.restore();

        final tasselCount = 3;
        for (var tIdx = 0; tIdx < tasselCount; tIdx += 1) {
          final tt = tasselCount == 1 ? 0.5 : tIdx / (tasselCount - 1);
          final tasselX = top.dx - flagWidth * 0.36 + tt * flagWidth * 0.72;
          final tasselTopY = top.dy + flagHeight * 0.88;
          final tasselEndY = tasselTopY + flagHeight * (0.08 + tIdx * 0.018);
          _paint
            ..color = outline.withValues(
                alpha: (combinedAlpha * 0.82).clamp(0.0, 1.0))
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(0.8, flagWidth * 0.02)
            ..strokeCap = StrokeCap.round;
          canvas.drawLine(
            Offset(tasselX, tasselTopY),
            Offset(tasselX, tasselEndY),
            _paint,
          );
          _paint
            ..color = tasselColors[(i + tIdx + strand) % tasselColors.length]
                .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0))
            ..style = PaintingStyle.fill;
          canvas.drawCircle(
            Offset(tasselX, tasselEndY + flagHeight * 0.03),
            (flagWidth * 0.05).clamp(1.2, 2.4).toDouble(),
            _paint,
          );
        }
      }
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

  void _paintLanternBackdrop(
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
    final bodyColor = backdrop.color.withValues(alpha: combinedAlpha);
    final frameColor = Color.lerp(bodyColor, const Color(0xFF0D121C), 0.36)!
        .withValues(alpha: combinedAlpha);
    final rimColor = Color.lerp(bodyColor, const Color(0xFF3A455A), 0.55)!
        .withValues(alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0));
    final glowAlpha = (combinedAlpha * 0.5).clamp(0.0, 1.0).toDouble();

    _paint
      ..color = const Color(0xFFFF8A4C).withValues(alpha: glowAlpha)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, scale * 0.95, _paint);
    _paint.color = const Color(0xFFFFC06A)
        .withValues(alpha: (glowAlpha * 0.66).clamp(0.0, 1.0));
    canvas.drawCircle(center, scale * 0.62, _paint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale, scale);

    _paint
      ..color = frameColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(_unitLanternBodyPath, _paint);

    final windowColor = const Color(0xFFFF8A4C)
        .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));
    final innerGlow = const Color(0xFFFFC977).withValues(
      alpha: (combinedAlpha * 0.82).clamp(0.0, 1.0),
    );
    _paint
      ..color = windowColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(_unitLanternWindowPath, _paint);
    _paint.color = innerGlow;
    canvas.save();
    canvas.translate(0, 0.06);
    canvas.scale(0.62, 0.62);
    canvas.drawPath(_unitLanternWindowPath, _paint);
    canvas.restore();

    final frameStroke = Color.lerp(bodyColor, const Color(0xFF0B1017), 0.5)!
        .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));
    _paint
      ..color = frameStroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.07
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(-0.22, -0.34),
      const Offset(-0.16, 0.42),
      _paint,
    );
    canvas.drawLine(const Offset(0, -0.36), const Offset(0, 0.44), _paint);
    canvas.drawLine(
      const Offset(0.22, -0.34),
      const Offset(0.16, 0.42),
      _paint,
    );

    _paint
      ..color = rimColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.06
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(-0.42, -0.9),
      const Offset(0.42, -0.9),
      _paint,
    );
    for (var i = 0; i < 8; i += 1) {
      final x = -0.34 + i * 0.097;
      canvas.drawLine(
        Offset(x, -0.9),
        Offset(x, -0.78),
        _paint,
      );
    }

    // Perforated dome effect.
    _paint
      ..color = const Color(0xFFFFA86D).withValues(
        alpha: (combinedAlpha * 0.56).clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.fill;
    for (var i = 0; i < 7; i += 1) {
      final theta = math.pi + (i / 6) * math.pi;
      final p = Offset(math.cos(theta) * 0.28, -0.98 + math.sin(theta) * 0.18);
      canvas.drawCircle(p, 0.035, _paint);
    }

    _paint
      ..color = rimColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.055;
    canvas.drawPath(_unitLanternBodyPath, _paint);

    canvas.restore();
  }

  void _paintPumpkinBackdrop(
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
    final pumpkinBase =
        Color.lerp(backdrop.color, const Color(0xFFFF8C1A), 0.4)!
            .withValues(alpha: combinedAlpha);
    final pumpkinRib =
        Color.lerp(backdrop.color, const Color(0xFF8D3F0A), 0.42)!
            .withValues(alpha: (combinedAlpha * 0.9).clamp(0.0, 1.0));
    final stemColor = const Color(0xFF4B2E1F).withValues(
      alpha: (combinedAlpha * 0.95).clamp(0.0, 1.0),
    );
    final cutoutDark = const Color(0xFF1B0D07).withValues(
      alpha: (combinedAlpha * 0.62).clamp(0.0, 1.0),
    );
    final cutoutGlow = const Color(0xFFFFD27A).withValues(
      alpha: (combinedAlpha * 0.72).clamp(0.0, 1.0),
    );

    _paint
      ..color = const Color(0xFFFFA246).withValues(
        alpha: (combinedAlpha * 0.24).clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center.translate(0, scale * 0.08), scale * 1.18, _paint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale, scale);

    final bodyRect = Rect.fromCenter(
        center: const Offset(0, 0.08), width: 1.9, height: 1.45);
    _paint
      ..color = pumpkinBase
      ..style = PaintingStyle.fill;
    canvas.drawOval(bodyRect, _paint);

    for (var i = 0; i < 5; i += 1) {
      final ribX = -0.52 + i * 0.26;
      final ribWidth = i == 2 ? 0.66 : 0.56;
      final ribRect = Rect.fromCenter(
          center: Offset(ribX, 0.12), width: ribWidth, height: 1.34);
      _paint
        ..color = pumpkinRib.withValues(
          alpha: (combinedAlpha * (i == 2 ? 0.35 : 0.5)).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.08;
      canvas.drawOval(ribRect, _paint);
    }

    final stemPath = Path()
      ..moveTo(-0.14, -0.62)
      ..quadraticBezierTo(-0.06, -0.9, 0.08, -0.86)
      ..quadraticBezierTo(0.2, -0.84, 0.14, -0.58)
      ..lineTo(0.05, -0.48)
      ..lineTo(-0.1, -0.48)
      ..close();
    _paint
      ..color = stemColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(stemPath, _paint);

    final leftEye = Path()
      ..moveTo(-0.45, -0.02)
      ..lineTo(-0.17, -0.04)
      ..lineTo(-0.31, -0.27)
      ..close();
    final rightEye = Path()
      ..moveTo(0.45, -0.02)
      ..lineTo(0.17, -0.04)
      ..lineTo(0.31, -0.27)
      ..close();
    final nose = Path()
      ..moveTo(0, 0.02)
      ..lineTo(0.12, 0.2)
      ..lineTo(-0.12, 0.2)
      ..close();
    final mouth = Path()
      ..moveTo(-0.56, 0.3)
      ..lineTo(-0.44, 0.44)
      ..lineTo(-0.3, 0.34)
      ..lineTo(-0.14, 0.5)
      ..lineTo(0.0, 0.33)
      ..lineTo(0.14, 0.5)
      ..lineTo(0.3, 0.34)
      ..lineTo(0.44, 0.44)
      ..lineTo(0.56, 0.3)
      ..quadraticBezierTo(0.38, 0.68, 0.0, 0.72)
      ..quadraticBezierTo(-0.38, 0.68, -0.56, 0.3)
      ..close();

    _paint
      ..color = cutoutDark
      ..style = PaintingStyle.fill;
    canvas.drawPath(leftEye, _paint);
    canvas.drawPath(rightEye, _paint);
    canvas.drawPath(nose, _paint);
    canvas.drawPath(mouth, _paint);

    _paint
      ..color = cutoutGlow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.06
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(leftEye, _paint);
    canvas.drawPath(rightEye, _paint);
    canvas.drawPath(nose, _paint);
    canvas.drawPath(mouth, _paint);

    canvas.restore();
  }

  void _paintRamadanLights(
    Canvas canvas,
    Size size,
    double opacity,
    DecorBackdrop backdrop,
  ) {
    final density =
        decorativeBackdropDensityMultiplier.clamp(0.35, 2.5).toDouble();
    final shortest = math.min(size.width, size.height);
    final topY = size.height * backdrop.anchor.dy;
    final dropBase =
        (shortest * backdrop.sizeFactor * 2.3).clamp(56.0, size.height * 0.48);
    final rowCount = decorativeBackdropRows?.clamp(1, 4) ?? 1;
    final rowGap = (shortest * backdrop.sizeFactor * 0.9).clamp(22.0, 52.0);
    const widthPattern = <double>[1.06, 0.88, 0.76, 0.66];
    const offsetPattern = <double>[0.0, -0.05, 0.05, -0.02];
    final baseAlpha = backdrop.color.a;
    final combinedAlpha =
        (baseAlpha * backdrop.opacity * opacity).clamp(0.0, 1.0).toDouble();

    final wireColor = Color.lerp(backdrop.color, const Color(0xFFFFFFFF), 0.18)!
        .withValues(alpha: (combinedAlpha * 0.84).clamp(0.0, 1.0));
    final bulbCore = const Color(0xFFFFE6A3).withValues(
      alpha: (combinedAlpha * 0.88).clamp(0.0, 1.0),
    );
    final bulbGlow = const Color(0xFFFFF3CF).withValues(
      alpha: (combinedAlpha * 0.42).clamp(0.0, 1.0),
    );
    final ornamentColor =
        Color.lerp(backdrop.color, const Color(0xFFFFD166), 0.45)!
            .withValues(alpha: (combinedAlpha * 0.96).clamp(0.0, 1.0));

    final bulbSpacing = (16.0 / density).clamp(9.0, 22.0);

    for (var row = 0; row < rowCount; row += 1) {
      final rowY = topY + row * rowGap;
      final rowSpan = (size.width * widthPattern[row % widthPattern.length])
          .clamp(size.width * 0.55, size.width * 1.08)
          .toDouble();
      final rowCenterX =
          size.width * (0.5 + offsetPattern[row % offsetPattern.length]);
      final leftX = rowCenterX - rowSpan * 0.5;
      final rightX = rowCenterX + rowSpan * 0.5;
      final rowDropBase = (dropBase * (1.0 - row * 0.15))
          .clamp(30.0, size.height * 0.46)
          .toDouble();
      final strandCount =
          math.max(3, ((rowSpan / 84) * density * (1.0 - row * 0.08)).round());
      final strandSpacing = strandCount > 1 ? rowSpan / (strandCount - 1) : 0.0;

      _paint
        ..color = wireColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(1.0, shortest * 0.0032)
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(leftX, rowY), Offset(rightX, rowY), _paint);

      for (var i = 0; i < strandCount; i += 1) {
        final x = leftX + i * strandSpacing;
        final sway = math.sin((i + row * 2) * 0.95) * strandSpacing * 0.14;
        final start = Offset(x + sway * 0.2, rowY);
        final drop = rowDropBase * (0.56 + ((i + row) % 5) * 0.09);
        final end = Offset(x + sway, rowY + drop);

        _paint
          ..color = wireColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(1.0, shortest * 0.0028)
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(start, end, _paint);

        final bulbCount = math.max(2, (drop / bulbSpacing).floor() - 1);
        for (var j = 1; j <= bulbCount; j += 1) {
          final t = j / (bulbCount + 1);
          final bulbPosition = Offset(
            start.dx + (end.dx - start.dx) * t,
            start.dy + (end.dy - start.dy) * t,
          );
          final bulbRadius = (shortest * 0.0062).clamp(1.3, 2.8).toDouble();
          _paint
            ..color = bulbGlow
            ..style = PaintingStyle.fill;
          canvas.drawCircle(bulbPosition, bulbRadius * 2.2, _paint);
          _paint.color = bulbCore;
          canvas.drawCircle(bulbPosition, bulbRadius, _paint);
        }

        final ornamentScale =
            (shortest * (0.032 + ((i + row) % 3) * 0.006)).clamp(10.0, 26.0);
        _paint
          ..color = ornamentColor
          ..style = PaintingStyle.fill;

        switch ((i + row) % 3) {
          case 0:
            canvas.save();
            canvas.translate(end.dx, end.dy);
            canvas.scale(ornamentScale, ornamentScale);
            canvas.drawPath(_unitStarPath, _paint);
            canvas.restore();
            break;
          case 1:
            canvas.save();
            canvas.translate(end.dx, end.dy);
            canvas.scale(ornamentScale, ornamentScale);
            canvas.drawPath(_unitCrescentPath, _paint);
            canvas.restore();
            break;
          default:
            final lanternTint = const Color(0xFF1F2534).withValues(
              alpha: ornamentColor.a,
            );
            canvas.save();
            canvas.translate(end.dx, end.dy + ornamentScale * 0.06);
            canvas.scale(ornamentScale, ornamentScale);
            _paint.color = lanternTint;
            canvas.drawPath(_unitLanternBodyPath, _paint);
            _paint.color = const Color(0xFFFF8A4C).withValues(
              alpha: (combinedAlpha * 0.88).clamp(0.0, 1.0),
            );
            canvas.drawPath(_unitLanternWindowPath, _paint);
            _paint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.06
              ..strokeCap = StrokeCap.round
              ..color = const Color(0xFF0F131B).withValues(
                alpha: (combinedAlpha * 0.85).clamp(0.0, 1.0),
              );
            canvas.drawPath(_unitLanternBodyPath, _paint);
            canvas.restore();
            break;
        }
      }
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

  void _paintFootballBackdrop(
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
    _paintSoccerBall(
      canvas,
      center: center,
      radius: radius,
      alpha: combinedAlpha,
      rotation: -0.08,
      withBackdropShadow: true,
    );
  }

  void _paintSoccerBall(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double alpha,
    required double rotation,
    required bool withBackdropShadow,
  }) {
    if (radius <= 0 || alpha <= 0) {
      return;
    }

    final combinedAlpha = alpha.clamp(0.0, 1.0).toDouble();
    final shellRect = Rect.fromCircle(center: center, radius: radius);
    final seamColor = const Color(0xFF1C1C1C).withValues(
      alpha: (combinedAlpha * 0.76).clamp(0.0, 1.0),
    );
    final patchEdge = const Color(0xFF050505).withValues(
      alpha: (combinedAlpha * 0.92).clamp(0.0, 1.0),
    );

    if (withBackdropShadow) {
      _paint
        ..shader = null
        ..color = const Color(0xFF000000).withValues(
          alpha: (combinedAlpha * 0.16).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        center.translate(radius * 0.06, radius * 0.14),
        radius * 1.08,
        _paint,
      );
    }

    _paint
      ..shader = RadialGradient(
        center: const Alignment(-0.32, -0.34),
        radius: 1.12,
        colors: [
          const Color(0xFFFFFFFF).withValues(alpha: combinedAlpha),
          const Color(0xFFF4F4F4).withValues(alpha: combinedAlpha),
          const Color(0xFFD8D8D8).withValues(alpha: combinedAlpha),
        ],
        stops: const [0.0, 0.56, 1.0],
      ).createShader(shellRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, _paint);

    _paint
      ..shader = null
      ..color = seamColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, radius * 0.055);
    canvas.drawCircle(center, radius, _paint);

    const patchCenters = <Offset>[
      Offset(0.0, -0.02),
      Offset(0.0, -0.59),
      Offset(-0.57, -0.2),
      Offset(0.57, -0.2),
      Offset(-0.35, 0.5),
      Offset(0.35, 0.5),
    ];
    const patchScales = <double>[0.28, 0.2, 0.2, 0.2, 0.2, 0.2];
    const patchRotations = <double>[0.0, 0.26, -0.18, 0.18, -0.32, 0.32];

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: radius)),
    );

    for (var i = 0; i < patchCenters.length; i += 1) {
      final patchCenter = patchCenters[i];
      final patchScale = patchScales[i];
      canvas.save();
      canvas.translate(patchCenter.dx * radius, patchCenter.dy * radius);
      canvas.rotate(patchRotations[i]);
      canvas.scale(radius * patchScale, radius * patchScale * 0.98);
      _paint
        ..shader = const RadialGradient(
          center: Alignment(-0.18, -0.2),
          radius: 1.15,
          colors: [
            Color(0xFF2B2B2B),
            Color(0xFF0B0B0B),
          ],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 1.15))
        ..style = PaintingStyle.fill;
      canvas.drawPath(_unitPentagonPath, _paint);
      _paint
        ..shader = null
        ..color = patchEdge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.09;
      canvas.drawPath(_unitPentagonPath, _paint);
      canvas.restore();
    }

    _paint
      ..shader = null
      ..color = seamColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.7, radius * 0.045)
      ..strokeCap = StrokeCap.round;
    for (var i = 1; i < patchCenters.length; i += 1) {
      final target = patchCenters[i];
      _seamPath
        ..reset()
        ..moveTo(0, 0)
        ..quadraticBezierTo(
          target.dx * radius * 0.36,
          target.dy * radius * 0.36 - radius * 0.03,
          target.dx * radius * 0.72,
          target.dy * radius * 0.72,
        );
      canvas.drawPath(_seamPath, _paint);
    }

    _paint
      ..color = const Color(0xFFFFFFFF).withValues(
        alpha: (combinedAlpha * 0.12).clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.5, radius * 0.02);
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(radius * 0.16, radius * 0.08),
        radius: radius * 0.62,
      ),
      math.pi * 0.22,
      math.pi * 1.02,
      false,
      _paint,
    );

    canvas.restore();

    _paint
      ..shader = RadialGradient(
        center: const Alignment(0.56, 0.56),
        radius: 1.0,
        colors: [
          const Color(0x00000000),
          const Color(0xFF000000).withValues(
            alpha: (combinedAlpha * 0.16).clamp(0.0, 1.0),
          ),
        ],
        stops: const [0.62, 1.0],
      ).createShader(shellRect)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, _paint);

    _paint
      ..shader = null
      ..color = const Color(0xFFFFFFFF).withValues(
        alpha: (combinedAlpha * 0.28).clamp(0.0, 1.0),
      )
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      center.translate(-radius * 0.26, -radius * 0.3),
      radius * 0.24,
      _paint,
    );
  }

  void _paintSoccerBallFast(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required double alpha,
    required double rotation,
  }) {
    if (radius <= 0 || alpha <= 0) {
      return;
    }
    final combinedAlpha = alpha.clamp(0.0, 1.0).toDouble();
    final shellColor = const Color(0xFFFFFFFF).withValues(alpha: combinedAlpha);
    final seamColor = const Color(0xFF111111).withValues(
      alpha: (combinedAlpha * 0.86).clamp(0.0, 1.0),
    );
    final patchColor = const Color(0xFF050505).withValues(
      alpha: (combinedAlpha * 0.94).clamp(0.0, 1.0),
    );

    _paint
      ..shader = null
      ..style = PaintingStyle.fill
      ..color = shellColor;
    canvas.drawCircle(center, radius, _paint);

    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.9, radius * 0.16)
      ..strokeCap = StrokeCap.round
      ..color = seamColor;
    canvas.drawCircle(center, radius, _paint);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    _paint
      ..style = PaintingStyle.fill
      ..color = patchColor;
    canvas.save();
    canvas.scale(radius * 0.4, radius * 0.4);
    canvas.drawPath(_unitPentagonPath, _paint);
    canvas.restore();

    const patchCount = 5;
    final ringRadius = radius * 0.56;
    for (var i = 0; i < patchCount; i += 1) {
      final angle = (math.pi * 2 * i) / patchCount - math.pi / 2;
      final dx = math.cos(angle) * ringRadius;
      final dy = math.sin(angle) * ringRadius;
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(angle * 0.5);
      canvas.scale(radius * 0.24, radius * 0.24);
      canvas.drawPath(_unitPentagonPath, _paint);
      canvas.restore();
    }

    _paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.7, radius * 0.08)
      ..strokeCap = StrokeCap.round
      ..color = seamColor;
    for (var i = 0; i < patchCount; i += 1) {
      final angle = (math.pi * 2 * i) / patchCount - math.pi / 2;
      final dx = math.cos(angle) * ringRadius * 0.74;
      final dy = math.sin(angle) * ringRadius * 0.74;
      canvas.drawLine(Offset.zero, Offset(dx, dy), _paint);
    }

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
        final windowColor = Color.lerp(color, const Color(0xFFFFF1C2), 0.6)!
            .withValues(alpha: (combinedAlpha * 0.7).clamp(0.0, 1.0));
        _paint
          ..color = windowColor
          ..style = PaintingStyle.fill;
        canvas.drawPath(_unitLanternWindowPath, _paint);
        final frameStroke = Color.lerp(color, const Color(0xFF8C6B1F), 0.46)!
            .withValues(alpha: (combinedAlpha * 0.85).clamp(0.0, 1.0));
        _paint
          ..color = frameStroke
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.07
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          const Offset(-0.22, -0.34),
          const Offset(-0.16, 0.42),
          _paint,
        );
        canvas.drawLine(const Offset(0, -0.36), const Offset(0, 0.44), _paint);
        canvas.drawLine(
          const Offset(0.22, -0.34),
          const Offset(0.16, 0.42),
          _paint,
        );
        _paint
          ..color = const Color(0xFFF8E7A7)
              .withValues(alpha: (combinedAlpha * 0.82).clamp(0.0, 1.0))
          ..style = PaintingStyle.fill;
        canvas.save();
        canvas.translate(0, 0.06);
        canvas.scale(0.18, 0.18);
        canvas.drawPath(_unitCrescentPath, _paint);
        canvas.restore();
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

        final faceColor = Color.lerp(color, const Color(0xFF2B2B2B), 0.6)!
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
        _paintSoccerBallFast(
          canvas,
          center: particle.position,
          radius: particle.size,
          alpha: combinedAlpha,
          rotation: particle.rotation,
        );
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
      ..addRect(const Rect.fromLTRB(-0.05, -1.18, 0.05, -1.04))
      ..addOval(Rect.fromCircle(center: Offset(0, -1.2), radius: 0.08))
      ..moveTo(-0.32, -1.04)
      ..lineTo(0.32, -1.04)
      ..lineTo(0.24, -0.94)
      ..lineTo(-0.24, -0.94)
      ..close()
      ..moveTo(-0.46, -0.94)
      ..lineTo(0.46, -0.94)
      ..lineTo(0.38, -0.84)
      ..lineTo(-0.38, -0.84)
      ..close()
      ..moveTo(-0.62, -0.84)
      ..lineTo(0.62, -0.84)
      ..lineTo(0.5, -0.68)
      ..lineTo(-0.5, -0.68)
      ..close()
      ..moveTo(-0.75, -0.68)
      ..lineTo(0.75, -0.68)
      ..lineTo(0.62, -0.54)
      ..lineTo(-0.62, -0.54)
      ..close()
      ..moveTo(-0.62, -0.54)
      ..lineTo(0.62, -0.54)
      ..lineTo(0.52, 0.56)
      ..lineTo(-0.52, 0.56)
      ..close()
      ..moveTo(-0.7, 0.56)
      ..lineTo(0.7, 0.56)
      ..lineTo(0.84, 0.78)
      ..lineTo(-0.84, 0.78)
      ..close()
      ..moveTo(-0.58, 0.78)
      ..lineTo(0.58, 0.78)
      ..lineTo(0.72, 1.0)
      ..lineTo(-0.72, 1.0)
      ..close()
      ..addOval(Rect.fromCircle(center: Offset(0, 1.1), radius: 0.09));
    return path;
  }

  static Path _buildUnitLanternWindowPath() {
    final path = Path()
      ..moveTo(-0.4, -0.42)
      ..quadraticBezierTo(0, -0.56, 0.4, -0.42)
      ..lineTo(0.28, 0.46)
      ..lineTo(-0.28, 0.46)
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

  static Path _buildUnitPentagonPath() {
    final path = Path();
    for (var i = 0; i < 5; i += 1) {
      final angle = -math.pi / 2 + i * (2 * math.pi / 5);
      final point = Offset(math.cos(angle), math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
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

  static int _backdropConfigHash(DecorConfig config) {
    final backdrops = config.backdrops.isNotEmpty
        ? config.backdrops
        : (config.backdrop == null
            ? const <DecorBackdrop>[]
            : [config.backdrop!]);
    return Object.hash(
      backdrops.length,
      Object.hashAll(
        backdrops.map(
          (item) => Object.hash(
            item.type,
            item.layer,
            item.color.toARGB32(),
            item.opacity,
            item.anchor.dx,
            item.anchor.dy,
            item.sizeFactor,
          ),
        ),
      ),
    );
  }

  static void _storeBackdropCache(_BackdropCacheKey key, ui.Picture picture) {
    if (_backdropPictureCache.containsKey(key)) {
      _backdropPictureCache[key] = picture;
      return;
    }
    _backdropPictureCache[key] = picture;
    _backdropCacheOrder.add(key);
    if (_backdropCacheOrder.length <= _maxBackdropCacheEntries) {
      return;
    }
    final evictedKey = _backdropCacheOrder.removeAt(0);
    _backdropPictureCache.remove(evictedKey);
  }

  @override
  bool shouldRepaint(covariant DecorPainter oldDelegate) {
    return oldDelegate.system != system ||
        oldDelegate.config != config ||
        oldDelegate.opacity != opacity ||
        oldDelegate.staticMode != staticMode ||
        oldDelegate.paintParticles != paintParticles ||
        oldDelegate.showBackdrop != showBackdrop ||
        oldDelegate.decorativeBackdropRows != decorativeBackdropRows ||
        oldDelegate.ramadanBuntingRows != ramadanBuntingRows ||
        oldDelegate.decorativeBackdropDensityMultiplier !=
            decorativeBackdropDensityMultiplier;
  }
}

@immutable
class _BackdropCacheKey {
  final int widthBucket;
  final int heightBucket;
  final int opacityBucket;
  final int densityBucket;
  final int configHash;
  final int rows;
  final int ramadanRows;
  final bool staticMode;

  _BackdropCacheKey({
    required double width,
    required double height,
    required double opacity,
    required double density,
    required this.rows,
    required this.ramadanRows,
    required this.staticMode,
    required this.configHash,
  })  : widthBucket = (width * 10).round(),
        heightBucket = (height * 10).round(),
        opacityBucket = (opacity * 1000).round(),
        densityBucket = (density * 1000).round();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is _BackdropCacheKey &&
            other.widthBucket == widthBucket &&
            other.heightBucket == heightBucket &&
            other.opacityBucket == opacityBucket &&
            other.densityBucket == densityBucket &&
            other.configHash == configHash &&
            other.rows == rows &&
            other.ramadanRows == ramadanRows &&
            other.staticMode == staticMode;
  }

  @override
  int get hashCode => Object.hash(
        widthBucket,
        heightBucket,
        opacityBucket,
        densityBucket,
        configHash,
        rows,
        ramadanRows,
        staticMode,
      );
}
