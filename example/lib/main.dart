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
        colorSchemeSeed: const Color(0xFF1BB8A3),
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
    final controlsHeight =
        (media.size.height * 0.48).clamp(260.0, 420.0).toDouble();

    return MediaQuery(
      data: resolvedMedia,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seasonal Decor'),
        ),
        body: Stack(
          children: [
            Container(
              decoration: _buildBackground(),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: _ControlsSheet(
                height: controlsHeight,
                child: _buildControls(context, reduceMotionActive),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, bool reduceMotionActive) {
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
          'Overlay Controls',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              reduceMotionActive ? Icons.pause_circle : Icons.play_circle,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                statusText,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: statusColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Preset'),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton<PresetOption>(
                value: _presetOption,
                isExpanded: true,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _presetOption = value);
                },
                items: PresetOption.values
                    .map(
                      (preset) => DropdownMenuItem(
                        value: preset,
                        child: Text(preset.label),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text('Intensity'),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButton<DecorIntensity>(
                value: _intensity,
                isExpanded: true,
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _intensity = value);
                },
                items: DecorIntensity.values
                    .map(
                      (intensity) => DropdownMenuItem(
                        value: intensity,
                        child: Text(intensity.name),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
        if (_presetOption == PresetOption.sportEvent)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use Team Colors'),
            subtitle: const Text('Applies a custom palette'),
            value: _useTeamColors,
            onChanged: (value) => setState(() => _useTeamColors = value),
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Backdrop'),
          subtitle: const Text('Render crescent/tree/garland'),
          value: _showBackdrop,
          onChanged: (value) => setState(() => _showBackdrop = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Keep Backdrop When Disabled'),
          subtitle: const Text('Show backdrop after animation stops'),
          value: _showBackdropWhenDisabled,
          onChanged: (value) =>
              setState(() => _showBackdropWhenDisabled = value),
        ),
        const SizedBox(height: 12),
        Text('Animation duration (${_playDurationSeconds.toStringAsFixed(1)}s)'),
        Text(
          _playDurationSeconds == 0
              ? '0 = continuous'
              : 'Plays then settles',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Slider(
          value: _playDurationSeconds,
          min: 0,
          max: 10,
          divisions: 20,
          label: _playDurationSeconds.toStringAsFixed(1),
          onChanged: (value) {
            setState(() => _playDurationSeconds = value);
          },
        ),
        const SizedBox(height: 4),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Auto Repeat'),
          subtitle: const Text('Restart after a period'),
          value: _autoRepeatEnabled,
          onChanged: (value) => setState(() => _autoRepeatEnabled = value),
        ),
        Text('Repeat every (${_repeatMinutes.toStringAsFixed(1)} min)'),
        Slider(
          value: _repeatMinutes,
          min: 0.5,
          max: 10,
          divisions: 19,
          label: _repeatMinutes.toStringAsFixed(1),
          onChanged: _autoRepeatEnabled
              ? (value) => setState(() => _repeatMinutes = value)
              : null,
        ),
        const SizedBox(height: 4),
        Text('Opacity (${_opacity.toStringAsFixed(2)})'),
        Slider(
          value: _opacity,
          min: 0.2,
          max: 1.0,
          onChanged: (value) {
            setState(() => _opacity = value);
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Enabled'),
          value: _enabled,
          onChanged: (value) => setState(() => _enabled = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Pause When Inactive'),
          value: _pauseWhenInactive,
          onChanged: (value) => setState(() => _pauseWhenInactive = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Respect Reduce Motion'),
          subtitle: const Text('Uses MediaQuery.disableAnimations'),
          value: _respectReduceMotion,
          onChanged: (value) => setState(() => _respectReduceMotion = value),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Simulate Reduce Motion'),
          value: _simulateReduceMotion,
          onChanged: (value) => setState(() => _simulateReduceMotion = value),
        ),
      ],
    );
  }
}

class _ControlsSheet extends StatelessWidget {
  final double height;
  final Widget child;

  const _ControlsSheet({
    required this.height,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        height: height,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 18,
              offset: Offset(0, -6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
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
                const SizedBox(height: 12),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
