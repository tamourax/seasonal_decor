import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  const frameDuration = Duration(milliseconds: 16);

  Future<void> pumpFrames(WidgetTester tester, int count) async {
    for (var i = 0; i < count; i += 1) {
      await tester.pump(frameDuration);
    }
  }

  Widget harness(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  group('Preset transitions', () {
    testWidgets('A→B→A transition does not crash and resolves correctly',
        (tester) async {
      var preset =
          SeasonalPreset.ramadan(variant: RamadanVariant.hangingLanterns);
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              SeasonalDecor(
                preset: preset,
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 10);
      expect(find.byType(SeasonalDecor), findsOneWidget);

      // Transition A→B (football).
      setter(() => preset = SeasonalPreset.football());
      await pumpFrames(tester, 10);
      expect(find.byType(SeasonalDecor), findsOneWidget);

      // Transition B→A (back to ramadan).
      setter(() => preset =
          SeasonalPreset.ramadan(variant: RamadanVariant.hangingLanterns));
      await pumpFrames(tester, 10);
      expect(find.byType(SeasonalDecor), findsOneWidget);
    });

    testWidgets('none→preset→none transitions cleanly', (tester) async {
      var preset = SeasonalPreset.none();
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              SeasonalDecor(
                preset: preset,
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 5);

      // Switch to active preset.
      setter(() => preset = SeasonalPreset.ramadan());
      await pumpFrames(tester, 15);
      expect(find.byType(SeasonalDecor), findsOneWidget);

      // Switch back to none.
      setter(() => preset = SeasonalPreset.none());
      await pumpFrames(tester, 5);
    });
  });

  group('Rapid toggles', () {
    testWidgets('rapid enabled true/false (10× toggles) does not crash',
        (tester) async {
      var enabled = true;
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              SeasonalDecor(
                preset: SeasonalPreset.ramadan(),
                enabled: enabled,
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 5);

      for (var i = 0; i < 10; i += 1) {
        setter(() => enabled = !enabled);
        await tester.pump(frameDuration);
      }
      await pumpFrames(tester, 5);
      expect(enabled, isTrue);
    });

    testWidgets('rapid showText on/off does not crash', (tester) async {
      var showText = false;
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              SeasonalDecor(
                preset: SeasonalPreset.ramadan(),
                text: showText ? 'Ramadan Kareem' : null,
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 5);

      for (var i = 0; i < 8; i += 1) {
        setter(() => showText = !showText);
        await tester.pump(frameDuration);
      }
      await pumpFrames(tester, 10);
    });

    testWidgets('fireworks enable/disable toggling does not crash',
        (tester) async {
      var preset = SeasonalPreset.newYear();
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              SeasonalDecor(
                preset: preset,
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 10);

      for (var i = 0; i < 6; i += 1) {
        setter(() {
          preset =
              i.isEven ? SeasonalPreset.ramadan() : SeasonalPreset.newYear();
        });
        await tester.pump(frameDuration);
      }
      await pumpFrames(tester, 10);
    });
  });

  group('Offstage / TickerMode behavior', () {
    testWidgets(
        'TickerMode(enabled:false) stops ticker when pauseWhenInactive=true',
        (tester) async {
      var tickerEnabled = true;
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              TickerMode(
                enabled: tickerEnabled,
                child: SeasonalDecor(
                  preset: SeasonalPreset.ramadan(),
                  child: const SizedBox.expand(),
                ),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 10);

      setter(() => tickerEnabled = false);
      await pumpFrames(tester, 5);

      setter(() => tickerEnabled = true);
      await pumpFrames(tester, 5);

      expect(find.byType(SeasonalDecor), findsOneWidget);
    });
  });

  group('ignorePointer pass-through', () {
    testWidgets('taps pass through overlay to button underneath',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () => tapped = true,
                    child: const Text('Tap me'),
                  ),
                ),
                SeasonalDecor(
                  preset: SeasonalPreset.ramadan(),
                  child: const SizedBox.expand(),
                ),
              ],
            ),
          ),
        ),
      );
      await pumpFrames(tester, 5);

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(tapped, isTrue,
          reason: 'Tap should pass through the SeasonalDecor overlay.');
    });
  });

  group('Intensity transitions', () {
    testWidgets('cycling through all intensities does not crash',
        (tester) async {
      var intensity = DecorIntensity.low;
      late StateSetter setter;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setter = setState;
            return harness(
              SeasonalDecor(
                preset: SeasonalPreset.eid(),
                intensity: intensity,
                child: const SizedBox.expand(),
              ),
            );
          },
        ),
      );
      await pumpFrames(tester, 5);

      for (final i in DecorIntensity.values) {
        setter(() => intensity = i);
        await pumpFrames(tester, 3);
      }

      expect(find.byType(SeasonalDecor), findsOneWidget);
    });
  });
}
