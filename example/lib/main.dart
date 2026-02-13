import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  runApp(const SeasonalDecorExampleApp());
}

enum PresetOption {
  ramadan,
  eid,
  christmas,
  newYear,
  valentine,
  halloween,
  sportEvent,
}

extension PresetOptionX on PresetOption {
  String get label {
    switch (this) {
      case PresetOption.ramadan:
        return 'Ramadan';
      case PresetOption.eid:
        return 'Eid';
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

class SeasonalDecorExampleApp extends StatelessWidget {
  const SeasonalDecorExampleApp({super.key});

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
        textTheme: const TextTheme(
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
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PresetOption _presetOption = PresetOption.sportEvent;
  DecorIntensity _intensity = DecorIntensity.high;
  bool _enabled = true;
  bool _pauseWhenInactive = true;
  bool _respectReduceMotion = false;
  bool _simulateReduceMotion = false;
  double _opacity = 1.0;
  bool _useTeamColors = false;
  bool _showBackdrop = true;
  bool _showBackdropWhenDisabled = true;
  double _playDurationSeconds = 0.0;
  bool _autoRepeatEnabled = false;
  double _repeatMinutes = 1.0;

  static const List<Color> _teamColors = [
    Color(0xFF1D4ED8),
    Color(0xFFDC2626),
    Color(0xFFFFFFFF),
  ];

  SeasonalPreset _buildPreset() {
    switch (_presetOption) {
      case PresetOption.ramadan:
        return SeasonalPreset.ramadan();
      case PresetOption.eid:
        return SeasonalPreset.eid();
      case PresetOption.christmas:
        return SeasonalPreset.christmas();
      case PresetOption.newYear:
        return SeasonalPreset.newYear();
      case PresetOption.valentine:
        return SeasonalPreset.valentine();
      case PresetOption.halloween:
        return SeasonalPreset.halloween();
      case PresetOption.sportEvent:
        return SeasonalPreset.sportEvent(
          variant: _useTeamColors
              ? SportEventVariant.teamColors
              : SportEventVariant.worldCup,
          teamColors: _useTeamColors ? _teamColors : null,
        );
    }
  }

  BoxDecoration _buildBackground() {
    switch (_presetOption) {
      case PresetOption.ramadan:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F1B2B), Color(0xFF123744)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.eid:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1320), Color(0xFF1B2A4A)],
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
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1120), Color(0xFF1F2A44)],
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
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF120F1A), Color(0xFF2A1F3D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
      case PresetOption.sportEvent:
        return const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0C2D26), Color(0xFF165041)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final resolvedMedia = media.copyWith(
      disableAnimations: _simulateReduceMotion || media.disableAnimations,
    );
    final reduceMotionActive =
        _respectReduceMotion && resolvedMedia.disableAnimations;

    return MediaQuery(
      data: resolvedMedia,
      child: Scaffold(
        body: Stack(
          children: [
            Container(decoration: _buildBackground()),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0.0, -0.6),
                      radius: 1.1,
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
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
                child: _Header(reduceMotionActive: reduceMotionActive),
              ),
            ),
            Positioned.fill(
              child: SeasonalDecor(
                preset: _buildPreset(),
                intensity: _intensity,
                enabled: _enabled,
                opacity: _opacity,
                pauseWhenInactive: _pauseWhenInactive,
                respectReduceMotion: _respectReduceMotion,
                showBackdrop: _showBackdrop,
                showBackdropWhenDisabled: _showBackdropWhenDisabled,
                playDuration: Duration(
                  milliseconds: (_playDurationSeconds * 1000).round(),
                ),
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
              respectReduceMotion: _respectReduceMotion,
              simulateReduceMotion: _simulateReduceMotion,
              opacity: _opacity,
              showBackdrop: _showBackdrop,
              showBackdropWhenDisabled: _showBackdropWhenDisabled,
              playDurationSeconds: _playDurationSeconds,
              autoRepeatEnabled: _autoRepeatEnabled,
              repeatMinutes: _repeatMinutes,
              useTeamColors: _useTeamColors,
              onPresetChanged: (value) => setState(() => _presetOption = value),
              onIntensityChanged: (value) =>
                  setState(() => _intensity = value),
              onEnabledChanged: (value) => setState(() => _enabled = value),
              onPauseWhenInactiveChanged: (value) =>
                  setState(() => _pauseWhenInactive = value),
              onRespectReduceMotionChanged: (value) =>
                  setState(() => _respectReduceMotion = value),
              onSimulateReduceMotionChanged: (value) =>
                  setState(() => _simulateReduceMotion = value),
              onOpacityChanged: (value) => setState(() => _opacity = value),
              onShowBackdropChanged: (value) =>
                  setState(() => _showBackdrop = value),
              onShowBackdropWhenDisabledChanged: (value) =>
                  setState(() => _showBackdropWhenDisabled = value),
              onPlayDurationChanged: (value) =>
                  setState(() => _playDurationSeconds = value),
              onAutoRepeatChanged: (value) =>
                  setState(() => _autoRepeatEnabled = value),
              onRepeatMinutesChanged: (value) =>
                  setState(() => _repeatMinutes = value),
              onUseTeamColorsChanged: (value) =>
                  setState(() => _useTeamColors = value),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool reduceMotionActive;

  const _Header({
    required this.reduceMotionActive,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = reduceMotionActive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.primary;
    final statusText = reduceMotionActive
        ? 'Animations paused (Reduce Motion enabled)'
        : 'Animations running';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seasonal Decor',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Drop-in overlays with pooled particles.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                reduceMotionActive ? Icons.pause_circle : Icons.play_circle,
                color: statusColor,
                size: 18,
              ),
              const SizedBox(width: 8),
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
  }
}

class _ControlSheet extends StatelessWidget {
  final PresetOption presetOption;
  final DecorIntensity intensity;
  final bool enabled;
  final bool pauseWhenInactive;
  final bool respectReduceMotion;
  final bool simulateReduceMotion;
  final double opacity;
  final bool showBackdrop;
  final bool showBackdropWhenDisabled;
  final double playDurationSeconds;
  final bool autoRepeatEnabled;
  final double repeatMinutes;
  final bool useTeamColors;
  final ValueChanged<PresetOption> onPresetChanged;
  final ValueChanged<DecorIntensity> onIntensityChanged;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onPauseWhenInactiveChanged;
  final ValueChanged<bool> onRespectReduceMotionChanged;
  final ValueChanged<bool> onSimulateReduceMotionChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<bool> onShowBackdropChanged;
  final ValueChanged<bool> onShowBackdropWhenDisabledChanged;
  final ValueChanged<double> onPlayDurationChanged;
  final ValueChanged<bool> onAutoRepeatChanged;
  final ValueChanged<double> onRepeatMinutesChanged;
  final ValueChanged<bool> onUseTeamColorsChanged;

  const _ControlSheet({
    required this.presetOption,
    required this.intensity,
    required this.enabled,
    required this.pauseWhenInactive,
    required this.respectReduceMotion,
    required this.simulateReduceMotion,
    required this.opacity,
    required this.showBackdrop,
    required this.showBackdropWhenDisabled,
    required this.playDurationSeconds,
    required this.autoRepeatEnabled,
    required this.repeatMinutes,
    required this.useTeamColors,
    required this.onPresetChanged,
    required this.onIntensityChanged,
    required this.onEnabledChanged,
    required this.onPauseWhenInactiveChanged,
    required this.onRespectReduceMotionChanged,
    required this.onSimulateReduceMotionChanged,
    required this.onOpacityChanged,
    required this.onShowBackdropChanged,
    required this.onShowBackdropWhenDisabledChanged,
    required this.onPlayDurationChanged,
    required this.onAutoRepeatChanged,
    required this.onRepeatMinutesChanged,
    required this.onUseTeamColorsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.22,
      maxChildSize: 0.86,
      initialChildSize: 0.44,
      builder: (context, controller) {
        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.94),
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.86),
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
                  SegmentedButton<DecorIntensity>(
                    segments: DecorIntensity.values
                        .map(
                          (intensity) => ButtonSegment<DecorIntensity>(
                            value: intensity,
                            label: Text(intensity.name),
                          ),
                        )
                        .toList(),
                    selected: {intensity},
                    onSelectionChanged: (selection) =>
                        onIntensityChanged(selection.first),
                  ),
                  if (presetOption == PresetOption.sportEvent) ...[
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Use Team Colors'),
                      subtitle: const Text('Applies a custom palette'),
                      value: useTeamColors,
                      onChanged: onUseTeamColorsChanged,
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
                    title: const Text('Auto Repeat'),
                    subtitle: const Text('Restart after a period'),
                    value: autoRepeatEnabled,
                    onChanged: onAutoRepeatChanged,
                  ),
                  Text('Repeat every (${repeatMinutes.toStringAsFixed(1)} min)'),
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
                    subtitle: const Text('Show backdrop after animation stops'),
                    value: showBackdropWhenDisabled,
                    onChanged: onShowBackdropWhenDisabledChanged,
                  ),
                  const SizedBox(height: 8),
                  Text('Opacity (${opacity.toStringAsFixed(2)})'),
                  Slider(
                    value: opacity,
                    min: 0.2,
                    max: 1.0,
                    onChanged: onOpacityChanged,
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
                    title: const Text('Respect Reduce Motion'),
                    subtitle: const Text('Uses MediaQuery.disableAnimations'),
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
                    .withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }
}
