import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  runApp(const SeasonalDecorExampleApp());
}

enum PresetOption {
  none,
  ramadan,
  ramadanHangingLanterns,
  eidFitr,
  eidAdha,
  christmas,
  newYear,
  valentine,
  halloween,
  football,
}

extension PresetOptionX on PresetOption {
  String get label {
    switch (this) {
      case PresetOption.ramadan:
        return 'Ramadan';
      case PresetOption.ramadanHangingLanterns:
        return 'Ramadan Lights';
      case PresetOption.eidFitr:
        return 'Eid al-Fitr';
      case PresetOption.eidAdha:
        return 'Eid al-Adha';
      case PresetOption.none:
        return 'None';
      case PresetOption.christmas:
        return 'Christmas';
      case PresetOption.newYear:
        return 'New Year';
      case PresetOption.valentine:
        return 'Valentine';
      case PresetOption.halloween:
        return 'Halloween';
      case PresetOption.football:
        return 'Football Celebration';
    }
  }
}

class SeasonalDecorExampleApp extends StatefulWidget {
  const SeasonalDecorExampleApp({super.key});

  @override
  State<SeasonalDecorExampleApp> createState() =>
      _SeasonalDecorExampleAppState();
}

class _SeasonalDecorExampleAppState extends State<SeasonalDecorExampleApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  static const TextTheme _textTheme = TextTheme(
    headlineMedium: TextStyle(
      fontFamily: 'Georgia',
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Georgia',
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Trebuchet MS',
    ),
  );

  void _toggleThemeMode() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1BB8A3),
          brightness: Brightness.light,
        ),
        textTheme: _textTheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1BB8A3),
          brightness: Brightness.dark,
        ),
        textTheme: _textTheme,
      ),
      themeMode: _themeMode,
      home: HomePage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleThemeMode: _toggleThemeMode,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleThemeMode;

  const HomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleThemeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PresetOption _presetOption = PresetOption.ramadan;
  DecorIntensity _intensity = DecorIntensity.max;
  bool _enabled = true;
  bool _pauseWhenInactive = true;
  bool _ignorePointer = true;
  bool _respectReduceMotion = false;
  bool _simulateReduceMotion = false;
  double _opacity = 1.0;
  bool _showBackdrop = true;
  bool _showBackdropWhenDisabled = true;
  bool _showBackgroundBackdrops = true;
  bool _showDecorativeBackdrops = true;
  double _particleSpeedMultiplier = 2.0;
  double _particleSizeMultiplier = 2.0;
  double _decorativeBackdropDensityMultiplier = 1.0;
  int _ramadanBuntingRows = 3;
  bool _showText = true;
  String _customOverlayText = '';
  double _textOpacity = 0.5;
  double _textSize = 34.0;
  double _textDisplaySeconds = 1.8;
  double _textAnimationMilliseconds = 550.0;
  double _textAlignX = 0.0;
  double _textAlignY = -1.0;
  double _textPaddingHorizontal = 20.0;
  double _textPaddingTop = 56.0;
  double _textSlideX = 0.0;
  double _textSlideY = -0.2;
  bool _useCustomBackgroundBackdrop = false;
  double _customBackgroundX = 0.85;
  double _customBackgroundY = -0.7;
  double _customBackgroundSize = 180.0;
  double _customBackgroundOpacity = 0.35;
  bool _adaptColorsToTheme = true;
  double _playDurationSeconds = 10.0;
  bool _settleOnDisable = true;
  bool _autoRepeatEnabled = false;
  double _repeatMinutes = 1.0;
  bool _usePresetOverrides = false;
  double _backdropAnchorX = 0.82;
  double _backdropAnchorY = 0.22;
  double _backdropSizeFactor = 0.55;
  BackdropType _backdropType = BackdropType.mosque;

  SeasonalPreset _buildPreset() {
    SeasonalPreset preset;
    switch (_presetOption) {
      case PresetOption.none:
        return SeasonalPreset.none();
      case PresetOption.ramadan:
        preset = SeasonalPreset.ramadan();
        break;
      case PresetOption.ramadanHangingLanterns:
        preset = SeasonalPreset.ramadan(
          variant: RamadanVariant.hangingLanterns,
        );
        break;
      case PresetOption.eidFitr:
        preset = SeasonalPreset.eid(variant: EidVariant.fitr);
        break;
      case PresetOption.eidAdha:
        preset = SeasonalPreset.eid(variant: EidVariant.adha);
        break;
      case PresetOption.christmas:
        preset = SeasonalPreset.christmas();
        break;
      case PresetOption.newYear:
        preset = SeasonalPreset.newYear();
        break;
      case PresetOption.valentine:
        preset = SeasonalPreset.valentine();
        break;
      case PresetOption.halloween:
        preset = SeasonalPreset.halloween();
        break;
      case PresetOption.football:
        preset = SeasonalPreset.football();
        break;
    }

    if (!_usePresetOverrides) {
      return preset;
    }

    final overrideShapes = _presetOption == PresetOption.football
        ? const [ParticleShape.ball]
        : _presetOption == PresetOption.eidAdha
            ? const [ParticleShape.sheep]
            : const [ParticleShape.balloon, ParticleShape.sheep];

    return preset.withOverrides(
      shapes: overrideShapes,
      backdropType: _backdropType,
      backdropAnchor: Offset(_backdropAnchorX, _backdropAnchorY),
      backdropSizeFactor: _backdropSizeFactor,
    );
  }

  Widget _buildCustomBackgroundBackdrop(Brightness brightness) {
    final icon = switch (_presetOption) {
      PresetOption.ramadan ||
      PresetOption.ramadanHangingLanterns ||
      PresetOption.eidFitr ||
      PresetOption.eidAdha =>
        Icons.nightlight_round,
      PresetOption.christmas => Icons.park,
      PresetOption.newYear => Icons.celebration,
      PresetOption.valentine => Icons.favorite,
      PresetOption.halloween => Icons.auto_awesome,
      PresetOption.football => Icons.emoji_events,
      PresetOption.none => Icons.auto_awesome,
    };

    final baseColor = brightness == Brightness.dark
        ? const Color(0xFFFFE2A6)
        : const Color(0xFF3D5A80);
    final color = baseColor.withValues(
      alpha: _customBackgroundOpacity.clamp(0.05, 1.0).toDouble(),
    );

    return Align(
      alignment: Alignment(
        _customBackgroundX.clamp(-1.0, 1.0).toDouble(),
        _customBackgroundY.clamp(-1.0, 1.0).toDouble(),
      ),
      child: Icon(
        icon,
        size: _customBackgroundSize.clamp(64.0, 360.0).toDouble(),
        color: color,
      ),
    );
  }

  BoxDecoration _buildBackground(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (_presetOption) {
      case PresetOption.none:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0F172A), Color(0xFF1E293B)]
                : const [Color(0xFFEAF2FF), Color(0xFFF8FAFC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.ramadan:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0F1B2B), Color(0xFF123744)]
                : const [Color(0xFFE8F0FF), Color(0xFFDDF0F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.ramadanHangingLanterns:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF23190F), Color(0xFF4A3119)]
                : const [Color(0xFFFFF3DB), Color(0xFFFFE9C7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.eidFitr:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0B1320), Color(0xFF1B2A4A)]
                : const [Color(0xFFE7EEFF), Color(0xFFF3F7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.eidAdha:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0B1C2B), Color(0xFF1C3B5A)]
                : const [Color(0xFFE5F3FF), Color(0xFFF2FAFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.christmas:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE7F1FF), Color(0xFFF9FBFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.newYear:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0B1120), Color(0xFF1F2A44)]
                : const [Color(0xFFE7EEFF), Color(0xFFF4F7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.valentine:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE4EC), Color(0xFFFFF5F9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.halloween:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF120F1A), Color(0xFF2A1F3D)]
                : const [Color(0xFFF3ECFF), Color(0xFFFFF5E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.football:
        return BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? const [Color(0xFF0C2D26), Color(0xFF165041)]
                : const [Color(0xFFE5F7EF), Color(0xFFF1FCF7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final media = MediaQuery.of(context);
    final resolvedMedia = media.copyWith(
      disableAnimations: _simulateReduceMotion || media.disableAnimations,
      platformBrightness: brightness,
    );
    final reduceMotionActive =
        _respectReduceMotion && resolvedMedia.disableAnimations;
    final preset = _buildPreset();

    return MediaQuery(
      data: resolvedMedia,
      child: Scaffold(
        body: Stack(
          children: [
            Container(decoration: _buildBackground(brightness)),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -0.6),
                      radius: 1.1,
                      colors: [
                        (brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _Header(
                  reduceMotionActive: reduceMotionActive,
                  isDarkMode: widget.isDarkMode,
                  onToggleThemeMode: widget.onToggleThemeMode,
                ),
              ),
            ),
            Positioned.fill(
              child: SeasonalDecor(
                preset: preset,
                intensity: _intensity,
                enabled: _enabled,
                opacity: _opacity,
                pauseWhenInactive: _pauseWhenInactive,
                ignorePointer: _ignorePointer,
                respectReduceMotion: _respectReduceMotion,
                showBackdrop: _showBackdrop,
                showBackdropWhenDisabled: _showBackdropWhenDisabled,
                showBackgroundBackdrops: _showBackgroundBackdrops,
                backgroundBackdrop: _useCustomBackgroundBackdrop
                    ? _buildCustomBackgroundBackdrop(brightness)
                    : null,
                showDecorativeBackdrops: _showDecorativeBackdrops,
                showText: _showText,
                text: _customOverlayText.trim().isEmpty
                    ? null
                    : _customOverlayText.trim(),
                textOpacity: _textOpacity,
                textStyle: TextStyle(
                  fontSize: _textSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
                textAlignment: Alignment(_textAlignX, _textAlignY),
                textPadding: EdgeInsets.fromLTRB(
                  _textPaddingHorizontal,
                  _textPaddingTop,
                  _textPaddingHorizontal,
                  0,
                ),
                textDisplayDuration: Duration(
                  milliseconds: (_textDisplaySeconds * 1000).round(),
                ),
                textAnimationDuration: Duration(
                  milliseconds: _textAnimationMilliseconds.round(),
                ),
                textSlideOffset: Offset(_textSlideX, _textSlideY),
                particleSpeedMultiplier: _particleSpeedMultiplier,
                particleSizeMultiplier: _particleSizeMultiplier,
                decorativeBackdropDensityMultiplier:
                    _decorativeBackdropDensityMultiplier,
                decorativeBackdropRows: _ramadanBuntingRows,
                ramadanBuntingRows: _ramadanBuntingRows,
                adaptColorsToTheme: _adaptColorsToTheme,
                playDuration: Duration(
                  milliseconds: (_playDurationSeconds * 1000).round(),
                ),
                settleOnDisable: _settleOnDisable,
                repeatEvery: _autoRepeatEnabled
                    ? Duration(
                        milliseconds: (_repeatMinutes * 60000).round(),
                      )
                    : null,
                child: const SizedBox.expand(),
              ),
            ),
            _ControlSheet(
              presetOption: _presetOption,
              intensity: _intensity,
              enabled: _enabled,
              pauseWhenInactive: _pauseWhenInactive,
              ignorePointer: _ignorePointer,
              respectReduceMotion: _respectReduceMotion,
              simulateReduceMotion: _simulateReduceMotion,
              opacity: _opacity,
              showBackdrop: _showBackdrop,
              showBackdropWhenDisabled: _showBackdropWhenDisabled,
              showBackgroundBackdrops: _showBackgroundBackdrops,
              useCustomBackgroundBackdrop: _useCustomBackgroundBackdrop,
              customBackgroundX: _customBackgroundX,
              customBackgroundY: _customBackgroundY,
              customBackgroundSize: _customBackgroundSize,
              customBackgroundOpacity: _customBackgroundOpacity,
              showDecorativeBackdrops: _showDecorativeBackdrops,
              showText: _showText,
              customOverlayText: _customOverlayText,
              textOpacity: _textOpacity,
              textSize: _textSize,
              textDisplaySeconds: _textDisplaySeconds,
              textAnimationMilliseconds: _textAnimationMilliseconds,
              textAlignX: _textAlignX,
              textAlignY: _textAlignY,
              textPaddingHorizontal: _textPaddingHorizontal,
              textPaddingTop: _textPaddingTop,
              textSlideX: _textSlideX,
              textSlideY: _textSlideY,
              particleSpeedMultiplier: _particleSpeedMultiplier,
              particleSizeMultiplier: _particleSizeMultiplier,
              decorativeBackdropDensityMultiplier:
                  _decorativeBackdropDensityMultiplier,
              ramadanBuntingRows: _ramadanBuntingRows,
              adaptColorsToTheme: _adaptColorsToTheme,
              playDurationSeconds: _playDurationSeconds,
              settleOnDisable: _settleOnDisable,
              autoRepeatEnabled: _autoRepeatEnabled,
              repeatMinutes: _repeatMinutes,
              usePresetOverrides: _usePresetOverrides,
              backdropAnchorX: _backdropAnchorX,
              backdropAnchorY: _backdropAnchorY,
              backdropSizeFactor: _backdropSizeFactor,
              backdropType: _backdropType,
              onPresetChanged: (value) => setState(() => _presetOption = value),
              onIntensityChanged: (value) => setState(() => _intensity = value),
              onEnabledChanged: (value) => setState(() => _enabled = value),
              onPauseWhenInactiveChanged: (value) =>
                  setState(() => _pauseWhenInactive = value),
              onIgnorePointerChanged: (value) =>
                  setState(() => _ignorePointer = value),
              onRespectReduceMotionChanged: (value) =>
                  setState(() => _respectReduceMotion = value),
              onSimulateReduceMotionChanged: (value) =>
                  setState(() => _simulateReduceMotion = value),
              onOpacityChanged: (value) => setState(() => _opacity = value),
              onShowBackdropChanged: (value) =>
                  setState(() => _showBackdrop = value),
              onShowBackdropWhenDisabledChanged: (value) =>
                  setState(() => _showBackdropWhenDisabled = value),
              onShowBackgroundBackdropsChanged: (value) =>
                  setState(() => _showBackgroundBackdrops = value),
              onUseCustomBackgroundBackdropChanged: (value) =>
                  setState(() => _useCustomBackgroundBackdrop = value),
              onCustomBackgroundXChanged: (value) =>
                  setState(() => _customBackgroundX = value),
              onCustomBackgroundYChanged: (value) =>
                  setState(() => _customBackgroundY = value),
              onCustomBackgroundSizeChanged: (value) =>
                  setState(() => _customBackgroundSize = value),
              onCustomBackgroundOpacityChanged: (value) =>
                  setState(() => _customBackgroundOpacity = value),
              onShowDecorativeBackdropsChanged: (value) =>
                  setState(() => _showDecorativeBackdrops = value),
              onShowTextChanged: (value) => setState(() => _showText = value),
              onCustomOverlayTextChanged: (value) =>
                  setState(() => _customOverlayText = value),
              onTextOpacityChanged: (value) =>
                  setState(() => _textOpacity = value),
              onTextSizeChanged: (value) => setState(() => _textSize = value),
              onTextDisplaySecondsChanged: (value) =>
                  setState(() => _textDisplaySeconds = value),
              onTextAnimationMillisecondsChanged: (value) =>
                  setState(() => _textAnimationMilliseconds = value),
              onTextAlignXChanged: (value) =>
                  setState(() => _textAlignX = value),
              onTextAlignYChanged: (value) =>
                  setState(() => _textAlignY = value),
              onTextPaddingHorizontalChanged: (value) =>
                  setState(() => _textPaddingHorizontal = value),
              onTextPaddingTopChanged: (value) =>
                  setState(() => _textPaddingTop = value),
              onTextSlideXChanged: (value) =>
                  setState(() => _textSlideX = value),
              onTextSlideYChanged: (value) =>
                  setState(() => _textSlideY = value),
              onParticleSpeedMultiplierChanged: (value) =>
                  setState(() => _particleSpeedMultiplier = value),
              onParticleSizeMultiplierChanged: (value) =>
                  setState(() => _particleSizeMultiplier = value),
              onDecorativeBackdropDensityMultiplierChanged: (value) =>
                  setState(() => _decorativeBackdropDensityMultiplier = value),
              onRamadanBuntingRowsChanged: (value) => setState(
                () => _ramadanBuntingRows = (value.round().clamp(1, 6)).toInt(),
              ),
              onAdaptColorsToThemeChanged: (value) =>
                  setState(() => _adaptColorsToTheme = value),
              onPlayDurationChanged: (value) =>
                  setState(() => _playDurationSeconds = value),
              onSettleOnDisableChanged: (value) =>
                  setState(() => _settleOnDisable = value),
              onAutoRepeatChanged: (value) =>
                  setState(() => _autoRepeatEnabled = value),
              onRepeatMinutesChanged: (value) =>
                  setState(() => _repeatMinutes = value),
              onUsePresetOverridesChanged: (value) =>
                  setState(() => _usePresetOverrides = value),
              onBackdropAnchorXChanged: (value) =>
                  setState(() => _backdropAnchorX = value),
              onBackdropAnchorYChanged: (value) =>
                  setState(() => _backdropAnchorY = value),
              onBackdropSizeFactorChanged: (value) =>
                  setState(() => _backdropSizeFactor = value),
              onBackdropTypeChanged: (value) =>
                  setState(() => _backdropType = value),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool reduceMotionActive;
  final bool isDarkMode;
  final VoidCallback onToggleThemeMode;

  const _Header({
    required this.reduceMotionActive,
    required this.isDarkMode,
    required this.onToggleThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final subtitleColor = isDarkTheme
        ? Colors.white.withValues(alpha: 0.82)
        : Colors.black.withValues(alpha: 0.72);
    final pillColor = isDarkTheme
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.06);
    final pillBorderColor = isDarkTheme
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.black.withValues(alpha: 0.08);

    final statusColor = reduceMotionActive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    final statusText = reduceMotionActive
        ? 'Animations paused (Reduce Motion enabled)'
        : 'Animations running';

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 430;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (compact)
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Seasonal Decor',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onToggleThemeMode,
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      size: 18,
                    ),
                    label: Text(isDarkMode ? 'Light' : 'Dark'),
                  ),
                ],
              )
            else
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Seasonal Decor',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: onToggleThemeMode,
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      size: 18,
                    ),
                    label: Text(isDarkMode ? 'Light' : 'Dark'),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Text(
              'Drop-in overlays with pooled particles.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: subtitleColor,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: pillColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: pillBorderColor,
                ),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    reduceMotionActive ? Icons.pause_circle : Icons.play_circle,
                    color: statusColor,
                    size: 18,
                  ),
                  Text(
                    statusText,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: statusColor),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ControlSheet extends StatelessWidget {
  final PresetOption presetOption;
  final DecorIntensity intensity;
  final bool enabled;
  final bool pauseWhenInactive;
  final bool ignorePointer;
  final bool respectReduceMotion;
  final bool simulateReduceMotion;
  final double opacity;
  final bool showBackdrop;
  final bool showBackdropWhenDisabled;
  final bool showBackgroundBackdrops;
  final bool useCustomBackgroundBackdrop;
  final double customBackgroundX;
  final double customBackgroundY;
  final double customBackgroundSize;
  final double customBackgroundOpacity;
  final bool showDecorativeBackdrops;
  final bool showText;
  final String customOverlayText;
  final double textOpacity;
  final double textSize;
  final double textDisplaySeconds;
  final double textAnimationMilliseconds;
  final double textAlignX;
  final double textAlignY;
  final double textPaddingHorizontal;
  final double textPaddingTop;
  final double textSlideX;
  final double textSlideY;
  final double particleSpeedMultiplier;
  final double particleSizeMultiplier;
  final double decorativeBackdropDensityMultiplier;
  final int ramadanBuntingRows;
  final bool adaptColorsToTheme;
  final double playDurationSeconds;
  final bool settleOnDisable;
  final bool autoRepeatEnabled;
  final double repeatMinutes;
  final bool usePresetOverrides;
  final double backdropAnchorX;
  final double backdropAnchorY;
  final double backdropSizeFactor;
  final BackdropType backdropType;
  final ValueChanged<PresetOption> onPresetChanged;
  final ValueChanged<DecorIntensity> onIntensityChanged;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onPauseWhenInactiveChanged;
  final ValueChanged<bool> onIgnorePointerChanged;
  final ValueChanged<bool> onRespectReduceMotionChanged;
  final ValueChanged<bool> onSimulateReduceMotionChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<bool> onShowBackdropChanged;
  final ValueChanged<bool> onShowBackdropWhenDisabledChanged;
  final ValueChanged<bool> onShowBackgroundBackdropsChanged;
  final ValueChanged<bool> onUseCustomBackgroundBackdropChanged;
  final ValueChanged<double> onCustomBackgroundXChanged;
  final ValueChanged<double> onCustomBackgroundYChanged;
  final ValueChanged<double> onCustomBackgroundSizeChanged;
  final ValueChanged<double> onCustomBackgroundOpacityChanged;
  final ValueChanged<bool> onShowDecorativeBackdropsChanged;
  final ValueChanged<bool> onShowTextChanged;
  final ValueChanged<String> onCustomOverlayTextChanged;
  final ValueChanged<double> onTextOpacityChanged;
  final ValueChanged<double> onTextSizeChanged;
  final ValueChanged<double> onTextDisplaySecondsChanged;
  final ValueChanged<double> onTextAnimationMillisecondsChanged;
  final ValueChanged<double> onTextAlignXChanged;
  final ValueChanged<double> onTextAlignYChanged;
  final ValueChanged<double> onTextPaddingHorizontalChanged;
  final ValueChanged<double> onTextPaddingTopChanged;
  final ValueChanged<double> onTextSlideXChanged;
  final ValueChanged<double> onTextSlideYChanged;
  final ValueChanged<double> onParticleSpeedMultiplierChanged;
  final ValueChanged<double> onParticleSizeMultiplierChanged;
  final ValueChanged<double> onDecorativeBackdropDensityMultiplierChanged;
  final ValueChanged<double> onRamadanBuntingRowsChanged;
  final ValueChanged<bool> onAdaptColorsToThemeChanged;
  final ValueChanged<double> onPlayDurationChanged;
  final ValueChanged<bool> onSettleOnDisableChanged;
  final ValueChanged<bool> onAutoRepeatChanged;
  final ValueChanged<double> onRepeatMinutesChanged;
  final ValueChanged<bool> onUsePresetOverridesChanged;
  final ValueChanged<double> onBackdropAnchorXChanged;
  final ValueChanged<double> onBackdropAnchorYChanged;
  final ValueChanged<double> onBackdropSizeFactorChanged;
  final ValueChanged<BackdropType> onBackdropTypeChanged;

  const _ControlSheet({
    required this.presetOption,
    required this.intensity,
    required this.enabled,
    required this.pauseWhenInactive,
    required this.ignorePointer,
    required this.respectReduceMotion,
    required this.simulateReduceMotion,
    required this.opacity,
    required this.showBackdrop,
    required this.showBackdropWhenDisabled,
    required this.showBackgroundBackdrops,
    required this.useCustomBackgroundBackdrop,
    required this.customBackgroundX,
    required this.customBackgroundY,
    required this.customBackgroundSize,
    required this.customBackgroundOpacity,
    required this.showDecorativeBackdrops,
    required this.showText,
    required this.customOverlayText,
    required this.textOpacity,
    required this.textSize,
    required this.textDisplaySeconds,
    required this.textAnimationMilliseconds,
    required this.textAlignX,
    required this.textAlignY,
    required this.textPaddingHorizontal,
    required this.textPaddingTop,
    required this.textSlideX,
    required this.textSlideY,
    required this.particleSpeedMultiplier,
    required this.particleSizeMultiplier,
    required this.decorativeBackdropDensityMultiplier,
    required this.ramadanBuntingRows,
    required this.adaptColorsToTheme,
    required this.playDurationSeconds,
    required this.settleOnDisable,
    required this.autoRepeatEnabled,
    required this.repeatMinutes,
    required this.usePresetOverrides,
    required this.backdropAnchorX,
    required this.backdropAnchorY,
    required this.backdropSizeFactor,
    required this.backdropType,
    required this.onPresetChanged,
    required this.onIntensityChanged,
    required this.onEnabledChanged,
    required this.onPauseWhenInactiveChanged,
    required this.onIgnorePointerChanged,
    required this.onRespectReduceMotionChanged,
    required this.onSimulateReduceMotionChanged,
    required this.onOpacityChanged,
    required this.onShowBackdropChanged,
    required this.onShowBackdropWhenDisabledChanged,
    required this.onShowBackgroundBackdropsChanged,
    required this.onUseCustomBackgroundBackdropChanged,
    required this.onCustomBackgroundXChanged,
    required this.onCustomBackgroundYChanged,
    required this.onCustomBackgroundSizeChanged,
    required this.onCustomBackgroundOpacityChanged,
    required this.onShowDecorativeBackdropsChanged,
    required this.onShowTextChanged,
    required this.onCustomOverlayTextChanged,
    required this.onTextOpacityChanged,
    required this.onTextSizeChanged,
    required this.onTextDisplaySecondsChanged,
    required this.onTextAnimationMillisecondsChanged,
    required this.onTextAlignXChanged,
    required this.onTextAlignYChanged,
    required this.onTextPaddingHorizontalChanged,
    required this.onTextPaddingTopChanged,
    required this.onTextSlideXChanged,
    required this.onTextSlideYChanged,
    required this.onParticleSpeedMultiplierChanged,
    required this.onParticleSizeMultiplierChanged,
    required this.onDecorativeBackdropDensityMultiplierChanged,
    required this.onRamadanBuntingRowsChanged,
    required this.onAdaptColorsToThemeChanged,
    required this.onPlayDurationChanged,
    required this.onSettleOnDisableChanged,
    required this.onAutoRepeatChanged,
    required this.onRepeatMinutesChanged,
    required this.onUsePresetOverridesChanged,
    required this.onBackdropAnchorXChanged,
    required this.onBackdropAnchorYChanged,
    required this.onBackdropSizeFactorChanged,
    required this.onBackdropTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth < 560 ? 8.0 : 16.0;
    final maxPanelWidth = screenWidth >= 1000 ? 560.0 : double.infinity;
    final canTuneDecorRows = showBackdrop && showDecorativeBackdrops;

    String backdropLabel(BackdropType type) {
      switch (type) {
        case BackdropType.crescent:
          return 'Crescent';
        case BackdropType.tree:
          return 'Tree';
        case BackdropType.garland:
          return 'Garland';
        case BackdropType.bunting:
          return 'Bunting';
        case BackdropType.mosque:
          return 'Mosque';
        case BackdropType.trophy:
          return 'Trophy';
        case BackdropType.football:
          return 'Football';
        case BackdropType.candyGarland:
          return 'Candy Garland';
        case BackdropType.lantern:
          return 'Lantern';
        case BackdropType.pumpkin:
          return 'Pumpkin';
        case BackdropType.ramadanLights:
          return 'Ramadan Lights';
        case BackdropType.ramadanBunting:
          return 'Ramadan Bunting';
      }
    }

    return DraggableScrollableSheet(
      minChildSize: 0.22,
      maxChildSize: 0.86,
      initialChildSize: 0.44,
      builder: (context, controller) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              0,
              horizontalPadding,
              16,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxPanelWidth),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 0.94),
                        Theme.of(context)
                            .colorScheme
                            .surface
                            .withValues(alpha: 0.86),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.08),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x26000000),
                        blurRadius: 20,
                        offset: Offset(0, -8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                      children: [
                        Center(
                          child: Container(
                            width: 44,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _SectionTitle(
                          title: 'Preset',
                          subtitle: 'Choose the seasonal scene',
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: PresetOption.values
                              .map(
                                (preset) => ChoiceChip(
                                  label: Text(preset.label),
                                  selected: preset == presetOption,
                                  onSelected: (_) => onPresetChanged(preset),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 18),
                        _SectionTitle(
                          title: 'Intensity',
                          subtitle: 'Particle density and speed',
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: DecorIntensity.values
                              .map(
                                (value) => ChoiceChip(
                                  label: Text(value.name),
                                  selected: value == intensity,
                                  onSelected: (_) => onIntensityChanged(value),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 18),
                        _SectionTitle(
                          title: 'Overrides',
                          subtitle: 'Custom shapes + backdrop',
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Use Preset Overrides'),
                          subtitle: const Text('Balloon + sheep + mosque'),
                          value: usePresetOverrides,
                          onChanged: onUsePresetOverridesChanged,
                        ),
                        if (usePresetOverrides) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Backdrop Type',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: BackdropType.values
                                .map(
                                  (type) => ChoiceChip(
                                    label: Text(backdropLabel(type)),
                                    selected: type == backdropType,
                                    onSelected: (_) =>
                                        onBackdropTypeChanged(type),
                                  ),
                                )
                                .toList(),
                          ),
                          Text(
                            'Backdrop X (${backdropAnchorX.toStringAsFixed(2)})',
                          ),
                          Slider(
                            value: backdropAnchorX,
                            min: 0.0,
                            max: 1.0,
                            onChanged: onBackdropAnchorXChanged,
                          ),
                          Text(
                            'Backdrop Y (${backdropAnchorY.toStringAsFixed(2)})',
                          ),
                          Slider(
                            value: backdropAnchorY,
                            min: 0.0,
                            max: 1.0,
                            onChanged: onBackdropAnchorYChanged,
                          ),
                          Text(
                            'Backdrop Size (${backdropSizeFactor.toStringAsFixed(2)})',
                          ),
                          Slider(
                            value: backdropSizeFactor,
                            min: 0.2,
                            max: 0.8,
                            onChanged: onBackdropSizeFactorChanged,
                          ),
                        ],
                        const SizedBox(height: 18),
                        _SectionTitle(
                          title: 'Playback',
                          subtitle: 'Duration and repeating behavior',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Animation duration (${playDurationSeconds.toStringAsFixed(1)}s)',
                        ),
                        Text(
                          playDurationSeconds == 0
                              ? '0 = continuous'
                              : 'Plays then settles',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Slider(
                          value: playDurationSeconds,
                          min: 0,
                          max: 10,
                          divisions: 20,
                          label: playDurationSeconds.toStringAsFixed(1),
                          onChanged: onPlayDurationChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Settle On Disable'),
                          subtitle:
                              const Text('Let particles finish naturally'),
                          value: settleOnDisable,
                          onChanged: onSettleOnDisableChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Auto Repeat'),
                          subtitle: const Text('Restart after a period'),
                          value: autoRepeatEnabled,
                          onChanged: onAutoRepeatChanged,
                        ),
                        Text(
                            'Repeat every (${repeatMinutes.toStringAsFixed(1)} min)'),
                        Slider(
                          value: repeatMinutes,
                          min: 0.5,
                          max: 10,
                          divisions: 19,
                          label: repeatMinutes.toStringAsFixed(1),
                          onChanged:
                              autoRepeatEnabled ? onRepeatMinutesChanged : null,
                        ),
                        const SizedBox(height: 18),
                        _SectionTitle(
                          title: 'Appearance',
                          subtitle: 'Backdrop and opacity',
                        ),
                        const SizedBox(height: 10),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Show Backdrop'),
                          subtitle: const Text('Render crescent/tree/garland'),
                          value: showBackdrop,
                          onChanged: onShowBackdropChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Keep Backdrop When Disabled'),
                          subtitle:
                              const Text('Show backdrop after animation stops'),
                          value: showBackdropWhenDisabled,
                          onChanged: onShowBackdropWhenDisabledChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Background Backdrops'),
                          subtitle: const Text('Moon, mosque, and base scene'),
                          value: showBackgroundBackdrops,
                          onChanged: showBackdrop
                              ? onShowBackgroundBackdropsChanged
                              : null,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Custom Background Widget'),
                          subtitle: const Text(
                            'Replace built-in background backdrops',
                          ),
                          value: useCustomBackgroundBackdrop,
                          onChanged: showBackdrop
                              ? onUseCustomBackgroundBackdropChanged
                              : null,
                        ),
                        if (showBackdrop && useCustomBackgroundBackdrop) ...[
                          Text(
                            'Background X (${customBackgroundX.toStringAsFixed(2)})',
                          ),
                          Slider(
                            value: customBackgroundX,
                            min: -1.0,
                            max: 1.0,
                            divisions: 40,
                            onChanged: onCustomBackgroundXChanged,
                          ),
                          Text(
                            'Background Y (${customBackgroundY.toStringAsFixed(2)})',
                          ),
                          Slider(
                            value: customBackgroundY,
                            min: -1.0,
                            max: 1.0,
                            divisions: 40,
                            onChanged: onCustomBackgroundYChanged,
                          ),
                          Text(
                            'Background Size (${customBackgroundSize.toStringAsFixed(0)})',
                          ),
                          Slider(
                            value: customBackgroundSize,
                            min: 64,
                            max: 360,
                            divisions: 37,
                            onChanged: onCustomBackgroundSizeChanged,
                          ),
                          Text(
                            'Background Opacity (${customBackgroundOpacity.toStringAsFixed(2)})',
                          ),
                          Slider(
                            value: customBackgroundOpacity,
                            min: 0.05,
                            max: 1.0,
                            divisions: 19,
                            onChanged: onCustomBackgroundOpacityChanged,
                          ),
                        ],
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Decorative Backdrops'),
                          subtitle: const Text('Zina elements like bunting'),
                          value: showDecorativeBackdrops,
                          onChanged: showBackdrop
                              ? onShowDecorativeBackdropsChanged
                              : null,
                        ),
                        const SizedBox(height: 10),
                        _SectionTitle(
                          title: 'Greeting Text',
                          subtitle: 'Animated seasonal message',
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Show Text'),
                          subtitle: const Text('Display animated greeting'),
                          value: showText,
                          onChanged: onShowTextChanged,
                        ),
                        TextFormField(
                          initialValue: customOverlayText,
                          onChanged: onCustomOverlayTextChanged,
                          decoration: const InputDecoration(
                            labelText: 'Custom Text (optional)',
                            hintText: 'Leave empty for preset default',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Text Opacity (${textOpacity.toStringAsFixed(2)})'),
                        Slider(
                          value: textOpacity,
                          min: 0.1,
                          max: 1.0,
                          divisions: 18,
                          onChanged: showText ? onTextOpacityChanged : null,
                        ),
                        Text('Text Size (${textSize.toStringAsFixed(0)})'),
                        Slider(
                          value: textSize,
                          min: 18,
                          max: 56,
                          divisions: 19,
                          onChanged: showText ? onTextSizeChanged : null,
                        ),
                        Text(
                          'Text Display (${textDisplaySeconds.toStringAsFixed(1)}s)',
                        ),
                        Slider(
                          value: textDisplaySeconds,
                          min: 0.4,
                          max: 4.0,
                          divisions: 18,
                          onChanged:
                              showText ? onTextDisplaySecondsChanged : null,
                        ),
                        Text(
                          'Text Animation (${textAnimationMilliseconds.toStringAsFixed(0)}ms)',
                        ),
                        Slider(
                          value: textAnimationMilliseconds,
                          min: 120,
                          max: 1200,
                          divisions: 18,
                          onChanged: showText
                              ? onTextAnimationMillisecondsChanged
                              : null,
                        ),
                        Text('Text Align X (${textAlignX.toStringAsFixed(2)})'),
                        Slider(
                          value: textAlignX,
                          min: -1.0,
                          max: 1.0,
                          divisions: 40,
                          onChanged: showText ? onTextAlignXChanged : null,
                        ),
                        Text('Text Align Y (${textAlignY.toStringAsFixed(2)})'),
                        Slider(
                          value: textAlignY,
                          min: -1.0,
                          max: 1.0,
                          divisions: 40,
                          onChanged: showText ? onTextAlignYChanged : null,
                        ),
                        Text(
                          'Text Horizontal Padding (${textPaddingHorizontal.toStringAsFixed(0)})',
                        ),
                        Slider(
                          value: textPaddingHorizontal,
                          min: 0,
                          max: 80,
                          divisions: 20,
                          onChanged:
                              showText ? onTextPaddingHorizontalChanged : null,
                        ),
                        Text(
                            'Text Top Padding (${textPaddingTop.toStringAsFixed(0)})'),
                        Slider(
                          value: textPaddingTop,
                          min: 0,
                          max: 180,
                          divisions: 18,
                          onChanged: showText ? onTextPaddingTopChanged : null,
                        ),
                        Text('Text Slide X (${textSlideX.toStringAsFixed(2)})'),
                        Slider(
                          value: textSlideX,
                          min: -1.0,
                          max: 1.0,
                          divisions: 40,
                          onChanged: showText ? onTextSlideXChanged : null,
                        ),
                        Text('Text Slide Y (${textSlideY.toStringAsFixed(2)})'),
                        Slider(
                          value: textSlideY,
                          min: -1.0,
                          max: 1.0,
                          divisions: 40,
                          onChanged: showText ? onTextSlideYChanged : null,
                        ),
                        Text(
                          'Decorative Density '
                          '(${decorativeBackdropDensityMultiplier.toStringAsFixed(2)}x)',
                        ),
                        Slider(
                          value: decorativeBackdropDensityMultiplier,
                          min: 0.4,
                          max: 1.8,
                          divisions: 14,
                          onChanged: showBackdrop && showDecorativeBackdrops
                              ? onDecorativeBackdropDensityMultiplierChanged
                              : null,
                        ),
                        Text('Decor Rows ($ramadanBuntingRows)'),
                        Slider(
                          value: ramadanBuntingRows.toDouble(),
                          min: 1,
                          max: 6,
                          divisions: 5,
                          label: '$ramadanBuntingRows',
                          onChanged: canTuneDecorRows
                              ? onRamadanBuntingRowsChanged
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text('Opacity (${opacity.toStringAsFixed(2)})'),
                        Slider(
                          value: opacity,
                          min: 0.2,
                          max: 1.0,
                          onChanged: onOpacityChanged,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Speed (${particleSpeedMultiplier.toStringAsFixed(2)}x)',
                        ),
                        Slider(
                          value: particleSpeedMultiplier,
                          min: 0.4,
                          max: 2.6,
                          divisions: 22,
                          onChanged: onParticleSpeedMultiplierChanged,
                        ),
                        Text(
                          'Size (${particleSizeMultiplier.toStringAsFixed(2)}x)',
                        ),
                        Slider(
                          value: particleSizeMultiplier,
                          min: 0.5,
                          max: 2.4,
                          divisions: 19,
                          onChanged: onParticleSizeMultiplierChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Adapt Colors To Theme'),
                          subtitle:
                              const Text('Improve contrast in light/dark mode'),
                          value: adaptColorsToTheme,
                          onChanged: onAdaptColorsToThemeChanged,
                        ),
                        const SizedBox(height: 18),
                        _SectionTitle(
                          title: 'Controls',
                          subtitle: 'Global playback switches',
                        ),
                        const SizedBox(height: 6),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Enabled'),
                          value: enabled,
                          onChanged: onEnabledChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Pause When Inactive'),
                          value: pauseWhenInactive,
                          onChanged: onPauseWhenInactiveChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Ignore Pointer'),
                          subtitle:
                              const Text('Let taps pass through the overlay'),
                          value: ignorePointer,
                          onChanged: onIgnorePointerChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Respect Reduce Motion'),
                          subtitle:
                              const Text('Uses MediaQuery.disableAnimations'),
                          value: respectReduceMotion,
                          onChanged: onRespectReduceMotionChanged,
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Simulate Reduce Motion'),
                          value: simulateReduceMotion,
                          onChanged: onSimulateReduceMotionChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final subtitleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: subtitleStyle),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(subtitle, style: subtitleStyle),
          ],
        );
      },
    );
  }
}
