import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'seasonal_mode.dart';

/// Resolved colors used by a scene.
class ScenePalette {
  final List<Color> gradient;
  final Color glow;
  final Color vignette;
  final List<Color> particleColors;
  final Color momentPrimary;
  final Color momentAccent;

  const ScenePalette({
    required this.gradient,
    required this.glow,
    required this.vignette,
    required this.particleColors,
    required this.momentPrimary,
    required this.momentAccent,
  });
}

/// Harmonizes scene anchor colors with the app primary color.
class PaletteHarmony {
  static final LinkedHashMap<String, ScenePalette> _cache =
      LinkedHashMap<String, ScenePalette>();
  static const int _maxCacheEntries = 40;

  static ScenePalette resolve({
    required List<Color> anchors,
    required Color primary,
    required Brightness brightness,
    required SeasonalMode mode,
    required bool reduceMotion,
  }) {
    final key = _cacheKey(
      anchors: anchors,
      primary: primary,
      brightness: brightness,
      mode: mode,
      reduceMotion: reduceMotion,
    );
    final cached = _cache.remove(key);
    if (cached != null) {
      _cache[key] = cached;
      return cached;
    }

    final blend = mode == SeasonalMode.ambient ? 0.16 : 0.26;
    final resolved = [
      for (final anchor in anchors)
        _harmonize(
          anchor: anchor,
          primary: primary,
          blend: reduceMotion ? blend * 0.75 : blend,
          brightness: brightness,
          mode: mode,
        ),
    ];

    final scenePalette = ScenePalette(
      gradient: resolved.take(3).toList(growable: false),
      glow: Color.lerp(resolved.first, resolved.last, 0.34)!,
      vignette: _vignetteFor(brightness, resolved.first),
      particleColors: resolved,
      momentPrimary: Color.lerp(resolved.first, primary, 0.5)!,
      momentAccent: Color.lerp(resolved.last, primary, 0.28)!,
    );

    _cache[key] = scenePalette;
    if (_cache.length > _maxCacheEntries) {
      _cache.remove(_cache.keys.first);
    }
    return scenePalette;
  }

  static String _cacheKey({
    required List<Color> anchors,
    required Color primary,
    required Brightness brightness,
    required SeasonalMode mode,
    required bool reduceMotion,
  }) {
    final anchorPart =
        anchors.map((c) => c.toARGB32().toRadixString(16)).join(',');
    return '$anchorPart:${primary.toARGB32()}:${brightness.name}:${mode.name}:$reduceMotion';
  }

  static Color _harmonize({
    required Color anchor,
    required Color primary,
    required double blend,
    required Brightness brightness,
    required SeasonalMode mode,
  }) {
    final mixed =
        Color.lerp(anchor, primary, blend.clamp(0.0, 1.0).toDouble())!;
    final anchorHsl = HSLColor.fromColor(anchor);
    var mixedHsl = HSLColor.fromColor(mixed);
    mixedHsl = _clampHueShift(anchorHsl, mixedHsl, 18.0);

    final satAdjust = mode == SeasonalMode.ambient ? -0.04 : 0.04;
    final lightAdjust = mode == SeasonalMode.ambient
        ? (brightness == Brightness.dark ? 0.02 : -0.01)
        : 0.03;

    final saturation =
        (mixedHsl.saturation + satAdjust).clamp(0.0, 1.0).toDouble();
    var lightness =
        (mixedHsl.lightness + lightAdjust).clamp(0.0, 1.0).toDouble();
    if (brightness == Brightness.light) {
      lightness = lightness.clamp(0.28, 0.86).toDouble();
    } else {
      lightness = lightness.clamp(0.18, 0.9).toDouble();
    }

    return mixedHsl
        .withSaturation(saturation)
        .withLightness(lightness)
        .toColor()
        .withValues(alpha: anchor.a);
  }

  static HSLColor _clampHueShift(
      HSLColor anchor, HSLColor candidate, double maxShift) {
    final delta = _shortestHueDelta(anchor.hue, candidate.hue);
    if (delta.abs() <= maxShift) {
      return candidate;
    }
    final direction = delta.isNegative ? -1.0 : 1.0;
    final nextHue = _normalizeHue(anchor.hue + direction * maxShift);
    return candidate.withHue(nextHue);
  }

  static double _shortestHueDelta(double from, double to) {
    var delta = (to - from) % 360.0;
    if (delta > 180.0) {
      delta -= 360.0;
    } else if (delta < -180.0) {
      delta += 360.0;
    }
    return delta;
  }

  static double _normalizeHue(double hue) {
    var value = hue % 360.0;
    if (value < 0) {
      value += 360.0;
    }
    return value;
  }

  static Color _vignetteFor(Brightness brightness, Color base) {
    final hsl = HSLColor.fromColor(base);
    final lightness = brightness == Brightness.dark ? 0.08 : 0.92;
    return hsl
        .withSaturation((hsl.saturation * 0.35).clamp(0.0, 1.0).toDouble())
        .withLightness(lightness)
        .toColor()
        .withValues(alpha: brightness == Brightness.dark ? 0.5 : 0.35);
  }
}
