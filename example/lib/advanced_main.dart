import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  runApp(const SeasonalDecorAdvancedApp());
}

enum PresetOption {
  none,
  ramadan,
  eidFitr,
  eidAdha,
  christmas,
  newYear,
  valentine,
  halloween,
  sportEvent,
}

extension PresetOptionX on PresetOption {
  String get label {
    switch (this) {
      case PresetOption.none:
        return 'None';
      case PresetOption.ramadan:
        return 'Ramadan';
      case PresetOption.eidFitr:
        return 'Eid al-Fitr';
      case PresetOption.eidAdha:
        return 'Eid al-Adha';
      case PresetOption.christmas:
        return 'Christmas';
      case PresetOption.newYear:
        return 'New Year';
      case PresetOption.valentine:
        return 'Valentine';
      case PresetOption.halloween:
        return 'Halloween';
      case PresetOption.sportEvent:
        return 'Sport Event';
    }
  }
}

extension BackdropTypeLabelX on BackdropType {
  String get label {
    switch (this) {
      case BackdropType.crescent:
        return 'Crescent';
      case BackdropType.tree:
        return 'Tree';
      case BackdropType.garland:
        return 'Garland';
      case BackdropType.candyGarland:
        return 'Candy Garland';
      case BackdropType.bunting:
        return 'Bunting';
      case BackdropType.mosque:
        return 'Mosque';
      case BackdropType.trophy:
        return 'Trophy';
    }
  }
}

class SeasonalDecorAdvancedApp extends StatefulWidget {
  const SeasonalDecorAdvancedApp({super.key});

  @override
  State<SeasonalDecorAdvancedApp> createState() =>
      _SeasonalDecorAdvancedAppState();
}

class _SeasonalDecorAdvancedAppState extends State<SeasonalDecorAdvancedApp> {
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
    bodyMedium: TextStyle(fontFamily: 'Trebuchet MS'),
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
  final SeasonalDecorController _decorController = SeasonalDecorController();

  PresetOption _preset = PresetOption.ramadan;
  SeasonalMode _mode = SeasonalMode.ambient;
  DecorIntensity _intensity = DecorIntensity.high;

  bool _enabled = true;
  bool _respectReduceMotion = false;
  bool _simulateReduceMotion = false;
  bool _pauseWhenInactive = true;
  bool _ignorePointer = true;
  bool _showBackdrop = true;
  bool _showBackdropWhenDisabled = true;
  bool _settleOnDisable = true;
  bool _autoRepeat = false;
  bool _adaptColorsToTheme = true;
  bool _useTeamColors = false;
  bool _usePresetOverrides = false;

  double _opacity = 1.0;
  double _particleSpeed = 1.2;
  double _playDurationSeconds = 8.0;
  double _repeatMinutes = 1.0;
  BackdropType _backdropType = BackdropType.mosque;
  double _backdropAnchorX = 0.82;
  double _backdropAnchorY = 0.22;
  double _backdropSizeFactor = 0.55;

  static const List<Color> _teamColors = [
    Color(0xFF1D4ED8),
    Color(0xFFDC2626),
    Color(0xFFFFFFFF),
  ];

  @override
  void dispose() {
    _decorController.dispose();
    super.dispose();
  }

  SeasonalPreset _buildPreset() {
    SeasonalPreset base;
    switch (_preset) {
      case PresetOption.none:
        return SeasonalPreset.none();
      case PresetOption.ramadan:
        base = SeasonalPreset.ramadan();
        break;
      case PresetOption.eidFitr:
        base = SeasonalPreset.eid(variant: EidVariant.fitr);
        break;
      case PresetOption.eidAdha:
        base = SeasonalPreset.eid(variant: EidVariant.adha);
        break;
      case PresetOption.christmas:
        base = SeasonalPreset.christmas();
        break;
      case PresetOption.newYear:
        base = SeasonalPreset.newYear();
        break;
      case PresetOption.valentine:
        base = SeasonalPreset.valentine();
        break;
      case PresetOption.halloween:
        base = SeasonalPreset.halloween();
        break;
      case PresetOption.sportEvent:
        base = SeasonalPreset.sportEvent(
          variant: _useTeamColors
              ? SportEventVariant.teamColors
              : SportEventVariant.worldCup,
          teamColors: _useTeamColors ? _teamColors : null,
        );
        break;
    }

    if (!_usePresetOverrides) {
      return base;
    }

    return base.withOverrides(
      shapes: const [ParticleShape.balloon, ParticleShape.sheep],
      backdropType: _backdropType,
      backdropAnchor: Offset(_backdropAnchorX, _backdropAnchorY),
      backdropSizeFactor: _backdropSizeFactor,
    );
  }

  List<Color> _background(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    switch (_preset) {
      case PresetOption.none:
        return isDark
            ? const [Color(0xFF060D1A), Color(0xFF132340)]
            : const [Color(0xFFEAF2FF), Color(0xFFF9FBFF)];
      case PresetOption.ramadan:
        return isDark
            ? const [Color(0xFF081124), Color(0xFF123744)]
            : const [Color(0xFFE2EEFF), Color(0xFFDDF0F6)];
      case PresetOption.eidFitr:
        return isDark
            ? const [Color(0xFF0A1325), Color(0xFF1B2A4A)]
            : const [Color(0xFFE5EEFF), Color(0xFFF3F7FF)];
      case PresetOption.eidAdha:
        return isDark
            ? const [Color(0xFF0B1728), Color(0xFF1C3B5A)]
            : const [Color(0xFFE3F2FF), Color(0xFFF2FAFF)];
      case PresetOption.christmas:
        return isDark
            ? const [Color(0xFF08170F), Color(0xFF14331F)]
            : const [Color(0xFFEAF4FF), Color(0xFFF9FBFF)];
      case PresetOption.newYear:
        return isDark
            ? const [Color(0xFF060E22), Color(0xFF1A2D57)]
            : const [Color(0xFFE7EEFF), Color(0xFFF4F7FF)];
      case PresetOption.valentine:
        return isDark
            ? const [Color(0xFF2A0F2A), Color(0xFF53204A)]
            : const [Color(0xFFFFE4EC), Color(0xFFFFF5F9)];
      case PresetOption.halloween:
        return isDark
            ? const [Color(0xFF100D19), Color(0xFF2A1F3D)]
            : const [Color(0xFFF3ECFF), Color(0xFFFFF5E8)];
      case PresetOption.sportEvent:
        return isDark
            ? const [Color(0xFF052018), Color(0xFF0D4437)]
            : const [Color(0xFFE5F7EF), Color(0xFFF1FCF7)];
    }
  }

  void _triggerMoment(SeasonalMoment moment) {
    _decorController.trigger(moment);
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
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _background(brightness),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const SizedBox.expand(),
            ),
            const Positioned.fill(child: _BackgroundAura()),
            Positioned.fill(
              child: SeasonalDecor(
                preset: preset,
                mode: _mode,
                controller: _decorController,
                intensity: _intensity,
                enabled: _enabled,
                respectReduceMotion: _respectReduceMotion,
                pauseWhenInactive: _pauseWhenInactive,
                ignorePointer: _ignorePointer,
                showBackdrop: _showBackdrop,
                showBackdropWhenDisabled: _showBackdropWhenDisabled,
                settleOnDisable: _settleOnDisable,
                repeatEvery: _autoRepeat
                    ? Duration(
                        milliseconds: (_repeatMinutes * 60000).round(),
                      )
                    : null,
                opacity: _opacity,
                particleSpeedMultiplier: _particleSpeed,
                adaptColorsToTheme: _adaptColorsToTheme,
                playDuration: Duration(
                  milliseconds: (_playDurationSeconds * 1000).round(),
                ),
                child: const SizedBox.expand(),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _HeroHeader(
                  isDarkMode: widget.isDarkMode,
                  reduceMotionActive: reduceMotionActive,
                  presetLabel: _preset.label,
                  mode: _mode,
                  onToggleThemeMode: widget.onToggleThemeMode,
                  onGreetingTap: () =>
                      _triggerMoment(SeasonalMoment.greetingBurst),
                  onFireworksTap: () =>
                      _triggerMoment(SeasonalMoment.fireworksBurst),
                ),
              ),
            ),
            _ControlPanel(
              preset: _preset,
              mode: _mode,
              intensity: _intensity,
              enabled: _enabled,
              respectReduceMotion: _respectReduceMotion,
              simulateReduceMotion: _simulateReduceMotion,
              pauseWhenInactive: _pauseWhenInactive,
              ignorePointer: _ignorePointer,
              showBackdrop: _showBackdrop,
              showBackdropWhenDisabled: _showBackdropWhenDisabled,
              settleOnDisable: _settleOnDisable,
              autoRepeat: _autoRepeat,
              adaptColorsToTheme: _adaptColorsToTheme,
              useTeamColors: _useTeamColors,
              usePresetOverrides: _usePresetOverrides,
              backdropType: _backdropType,
              backdropAnchorX: _backdropAnchorX,
              backdropAnchorY: _backdropAnchorY,
              backdropSizeFactor: _backdropSizeFactor,
              opacity: _opacity,
              particleSpeed: _particleSpeed,
              playDurationSeconds: _playDurationSeconds,
              repeatMinutes: _repeatMinutes,
              onPresetChanged: (value) => setState(() => _preset = value),
              onModeChanged: (value) => setState(() => _mode = value),
              onIntensityChanged: (value) => setState(() => _intensity = value),
              onEnabledChanged: (value) => setState(() => _enabled = value),
              onRespectReduceMotionChanged: (value) =>
                  setState(() => _respectReduceMotion = value),
              onSimulateReduceMotionChanged: (value) =>
                  setState(() => _simulateReduceMotion = value),
              onPauseWhenInactiveChanged: (value) =>
                  setState(() => _pauseWhenInactive = value),
              onIgnorePointerChanged: (value) =>
                  setState(() => _ignorePointer = value),
              onShowBackdropChanged: (value) =>
                  setState(() => _showBackdrop = value),
              onShowBackdropWhenDisabledChanged: (value) =>
                  setState(() => _showBackdropWhenDisabled = value),
              onSettleOnDisableChanged: (value) =>
                  setState(() => _settleOnDisable = value),
              onAutoRepeatChanged: (value) =>
                  setState(() => _autoRepeat = value),
              onAdaptColorsToThemeChanged: (value) =>
                  setState(() => _adaptColorsToTheme = value),
              onUseTeamColorsChanged: (value) =>
                  setState(() => _useTeamColors = value),
              onUsePresetOverridesChanged: (value) =>
                  setState(() => _usePresetOverrides = value),
              onBackdropTypeChanged: (value) =>
                  setState(() => _backdropType = value),
              onBackdropAnchorXChanged: (value) =>
                  setState(() => _backdropAnchorX = value),
              onBackdropAnchorYChanged: (value) =>
                  setState(() => _backdropAnchorY = value),
              onBackdropSizeFactorChanged: (value) =>
                  setState(() => _backdropSizeFactor = value),
              onOpacityChanged: (value) => setState(() => _opacity = value),
              onParticleSpeedChanged: (value) =>
                  setState(() => _particleSpeed = value),
              onPlayDurationChanged: (value) =>
                  setState(() => _playDurationSeconds = value),
              onRepeatMinutesChanged: (value) =>
                  setState(() => _repeatMinutes = value),
              onMomentTriggered: _triggerMoment,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final bool reduceMotionActive;
  final bool isDarkMode;
  final String presetLabel;
  final SeasonalMode mode;
  final VoidCallback onToggleThemeMode;
  final VoidCallback onGreetingTap;
  final VoidCallback onFireworksTap;

  const _HeroHeader({
    required this.reduceMotionActive,
    required this.isDarkMode,
    required this.presetLabel,
    required this.mode,
    required this.onToggleThemeMode,
    required this.onGreetingTap,
    required this.onFireworksTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkTheme
        ? Colors.white.withValues(alpha: 0.92)
        : Colors.black.withValues(alpha: 0.84);
    final softText = isDarkTheme
        ? Colors.white.withValues(alpha: 0.65)
        : Colors.black.withValues(alpha: 0.62);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: textColor,
                      ),
                  children: [
                    const TextSpan(text: 'Seasonal Decor\n'),
                    TextSpan(
                      text: '$presetLabel Atmosphere',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: softText,
                            fontFamily: 'Trebuchet MS',
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: onToggleThemeMode,
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              label: Text(isDarkMode ? 'Light' : 'Dark'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            _StatusPill(
              icon: reduceMotionActive
                  ? Icons.motion_photos_paused
                  : Icons.motion_photos_on,
              text: reduceMotionActive
                  ? 'Reduce Motion Active'
                  : 'Animations Active',
              color: reduceMotionActive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            _StatusPill(
              icon: mode == SeasonalMode.ambient
                  ? Icons.waves
                  : Icons.celebration_outlined,
              text: 'Mode: ${mode.name}',
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: onGreetingTap,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Greeting Burst'),
            ),
            OutlinedButton.icon(
              onPressed: onFireworksTap,
              icon: const Icon(Icons.celebration),
              label: const Text('Fireworks Burst'),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _StatusPill({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _BackgroundAura extends StatelessWidget {
  const _BackgroundAura();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.62, -0.72),
            radius: 0.6,
            colors: [
              (isDark ? const Color(0xFF58DEC8) : const Color(0xFF42CDBA))
                  .withValues(alpha: 0.16),
              const Color(0x00000000),
            ],
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.78, -0.45),
              radius: 0.5,
              colors: [
                (isDark ? const Color(0xFFFFD37B) : const Color(0xFFFFBE57))
                    .withValues(alpha: 0.14),
                const Color(0x00000000),
              ],
            ),
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _ControlPanel extends StatelessWidget {
  final PresetOption preset;
  final SeasonalMode mode;
  final DecorIntensity intensity;
  final bool enabled;
  final bool respectReduceMotion;
  final bool simulateReduceMotion;
  final bool pauseWhenInactive;
  final bool ignorePointer;
  final bool showBackdrop;
  final bool showBackdropWhenDisabled;
  final bool settleOnDisable;
  final bool autoRepeat;
  final bool adaptColorsToTheme;
  final bool useTeamColors;
  final bool usePresetOverrides;
  final double opacity;
  final double particleSpeed;
  final double playDurationSeconds;
  final double repeatMinutes;
  final BackdropType backdropType;
  final double backdropAnchorX;
  final double backdropAnchorY;
  final double backdropSizeFactor;

  final ValueChanged<PresetOption> onPresetChanged;
  final ValueChanged<SeasonalMode> onModeChanged;
  final ValueChanged<DecorIntensity> onIntensityChanged;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onRespectReduceMotionChanged;
  final ValueChanged<bool> onSimulateReduceMotionChanged;
  final ValueChanged<bool> onPauseWhenInactiveChanged;
  final ValueChanged<bool> onIgnorePointerChanged;
  final ValueChanged<bool> onShowBackdropChanged;
  final ValueChanged<bool> onShowBackdropWhenDisabledChanged;
  final ValueChanged<bool> onSettleOnDisableChanged;
  final ValueChanged<bool> onAutoRepeatChanged;
  final ValueChanged<bool> onAdaptColorsToThemeChanged;
  final ValueChanged<bool> onUseTeamColorsChanged;
  final ValueChanged<bool> onUsePresetOverridesChanged;
  final ValueChanged<BackdropType> onBackdropTypeChanged;
  final ValueChanged<double> onBackdropAnchorXChanged;
  final ValueChanged<double> onBackdropAnchorYChanged;
  final ValueChanged<double> onBackdropSizeFactorChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<double> onParticleSpeedChanged;
  final ValueChanged<double> onPlayDurationChanged;
  final ValueChanged<double> onRepeatMinutesChanged;
  final ValueChanged<SeasonalMoment> onMomentTriggered;

  const _ControlPanel({
    required this.preset,
    required this.mode,
    required this.intensity,
    required this.enabled,
    required this.respectReduceMotion,
    required this.simulateReduceMotion,
    required this.pauseWhenInactive,
    required this.ignorePointer,
    required this.showBackdrop,
    required this.showBackdropWhenDisabled,
    required this.settleOnDisable,
    required this.autoRepeat,
    required this.adaptColorsToTheme,
    required this.useTeamColors,
    required this.usePresetOverrides,
    required this.backdropType,
    required this.backdropAnchorX,
    required this.backdropAnchorY,
    required this.backdropSizeFactor,
    required this.opacity,
    required this.particleSpeed,
    required this.playDurationSeconds,
    required this.repeatMinutes,
    required this.onPresetChanged,
    required this.onModeChanged,
    required this.onIntensityChanged,
    required this.onEnabledChanged,
    required this.onRespectReduceMotionChanged,
    required this.onSimulateReduceMotionChanged,
    required this.onPauseWhenInactiveChanged,
    required this.onIgnorePointerChanged,
    required this.onShowBackdropChanged,
    required this.onShowBackdropWhenDisabledChanged,
    required this.onSettleOnDisableChanged,
    required this.onAutoRepeatChanged,
    required this.onAdaptColorsToThemeChanged,
    required this.onUseTeamColorsChanged,
    required this.onUsePresetOverridesChanged,
    required this.onBackdropTypeChanged,
    required this.onBackdropAnchorXChanged,
    required this.onBackdropAnchorYChanged,
    required this.onBackdropSizeFactorChanged,
    required this.onOpacityChanged,
    required this.onParticleSpeedChanged,
    required this.onPlayDurationChanged,
    required this.onRepeatMinutesChanged,
    required this.onMomentTriggered,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;
    return DraggableScrollableSheet(
      minChildSize: compact ? 0.24 : 0.2,
      maxChildSize: 0.9,
      initialChildSize: compact ? 0.44 : 0.36,
      builder: (context, controller) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: compact ? double.infinity : 640),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.14),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.88),
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.78),
                          ],
                        ),
                      ),
                      child: ListView(
                        controller: controller,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
                        children: [
                          Center(
                            child: Container(
                              width: 42,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.24),
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _SectionTitle(
                              title: 'Experience',
                              subtitle: 'Preset, mode, moments'),
                          const SizedBox(height: 10),
                          _dropdownTile<PresetOption>(
                            context: context,
                            label: 'Preset',
                            value: preset,
                            items: [
                              for (final item in PresetOption.values)
                                DropdownMenuItem(
                                  value: item,
                                  child: Text(item.label),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                onPresetChanged(value);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          Text('Mode',
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(height: 8),
                          SegmentedButton<SeasonalMode>(
                            segments: const [
                              ButtonSegment(
                                value: SeasonalMode.ambient,
                                icon: Icon(Icons.waves),
                                label: Text('Ambient'),
                              ),
                              ButtonSegment(
                                value: SeasonalMode.festive,
                                icon: Icon(Icons.celebration),
                                label: Text('Festive'),
                              ),
                            ],
                            selected: {mode},
                            onSelectionChanged: (values) =>
                                onModeChanged(values.first),
                          ),
                          const SizedBox(height: 12),
                          Text('Intensity (${intensity.name})'),
                          Slider(
                            value: intensity.index.toDouble(),
                            min: 0,
                            max: (DecorIntensity.values.length - 1).toDouble(),
                            divisions: DecorIntensity.values.length - 1,
                            label: intensity.name,
                            onChanged: (value) {
                              final index = value
                                  .round()
                                  .clamp(0, DecorIntensity.values.length - 1);
                              onIntensityChanged(DecorIntensity.values[index]);
                            },
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              FilledButton.tonal(
                                onPressed: () => onMomentTriggered(
                                    SeasonalMoment.greetingBurst),
                                child: const Text('Greeting'),
                              ),
                              FilledButton.tonal(
                                onPressed: () => onMomentTriggered(
                                    SeasonalMoment.successBurst),
                                child: const Text('Success'),
                              ),
                              FilledButton(
                                onPressed: () => onMomentTriggered(
                                    SeasonalMoment.fireworksBurst),
                                child: const Text('Fireworks'),
                              ),
                              OutlinedButton(
                                onPressed: () => onMomentTriggered(
                                    SeasonalMoment.subtleSparkle),
                                child: const Text('Subtle Sparkle'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _SectionTitle(
                              title: 'Controls',
                              subtitle: 'Playback and behavior'),
                          const SizedBox(height: 8),
                          Text(
                              'Overlay Opacity (${opacity.toStringAsFixed(2)})'),
                          Slider(
                              value: opacity,
                              min: 0.2,
                              max: 1.0,
                              onChanged: onOpacityChanged),
                          Text('Speed (${particleSpeed.toStringAsFixed(2)}x)'),
                          Slider(
                            value: particleSpeed,
                            min: 0.4,
                            max: 2.8,
                            divisions: 24,
                            onChanged: onParticleSpeedChanged,
                          ),
                          Text(
                              'Duration (${playDurationSeconds.toStringAsFixed(1)}s)'),
                          Slider(
                            value: playDurationSeconds,
                            min: 0,
                            max: 12,
                            divisions: 24,
                            onChanged: onPlayDurationChanged,
                          ),
                          Text(
                              'Repeat every (${repeatMinutes.toStringAsFixed(1)} min)'),
                          Slider(
                            value: repeatMinutes,
                            min: 0.5,
                            max: 10,
                            divisions: 19,
                            onChanged:
                                autoRepeat ? onRepeatMinutesChanged : null,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Enabled'),
                            value: enabled,
                            onChanged: onEnabledChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Respect Reduce Motion'),
                            value: respectReduceMotion,
                            onChanged: onRespectReduceMotionChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Simulate Reduce Motion'),
                            value: simulateReduceMotion,
                            onChanged: onSimulateReduceMotionChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Show Backdrop'),
                            value: showBackdrop,
                            onChanged: onShowBackdropChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Keep Backdrop When Disabled'),
                            value: showBackdropWhenDisabled,
                            onChanged: onShowBackdropWhenDisabledChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Auto Repeat'),
                            value: autoRepeat,
                            onChanged: onAutoRepeatChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Settle On Disable'),
                            value: settleOnDisable,
                            onChanged: onSettleOnDisableChanged,
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
                            value: ignorePointer,
                            onChanged: onIgnorePointerChanged,
                          ),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Adapt Colors To Theme'),
                            value: adaptColorsToTheme,
                            onChanged: onAdaptColorsToThemeChanged,
                          ),
                          if (preset == PresetOption.sportEvent)
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Use Team Colors'),
                              value: useTeamColors,
                              onChanged: onUseTeamColorsChanged,
                            ),
                          ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,
                            title: const Text('Preset Overrides'),
                            subtitle: const Text(
                              'Custom shapes and backdrop placement',
                            ),
                            children: [
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Use Preset Overrides'),
                                value: usePresetOverrides,
                                onChanged: onUsePresetOverridesChanged,
                              ),
                              if (usePresetOverrides) ...[
                                _dropdownTile<BackdropType>(
                                  context: context,
                                  label: 'Backdrop Type',
                                  value: backdropType,
                                  items: [
                                    for (final item in BackdropType.values)
                                      DropdownMenuItem(
                                        value: item,
                                        child: Text(item.label),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) {
                                      onBackdropTypeChanged(value);
                                    }
                                  },
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Backdrop X (${backdropAnchorX.toStringAsFixed(2)})',
                                ),
                                Slider(
                                  value: backdropAnchorX,
                                  min: 0,
                                  max: 1,
                                  onChanged: onBackdropAnchorXChanged,
                                ),
                                Text(
                                  'Backdrop Y (${backdropAnchorY.toStringAsFixed(2)})',
                                ),
                                Slider(
                                  value: backdropAnchorY,
                                  min: 0,
                                  max: 1,
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
                            ],
                          ),
                        ],
                      ),
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

  Widget _dropdownTile<T>({
    required BuildContext context,
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
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
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.62),
              ),
        ),
      ],
    );
  }
}
