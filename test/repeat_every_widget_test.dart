import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';
import 'package:seasonal_decor/src/engine/decor_painter.dart';

void main() {
  testWidgets('widget-level preset overrides are accepted', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          presetShapes: const [
            ParticleShape.lantern,
            ParticleShape.crescent,
          ],
          presetShapeSpeedMultipliers: const {
            ParticleShape.lantern: 1.2,
          },
          presetBackdropType: BackdropType.crescent,
          presetBackdropAnchor: const Offset(0.78, 0.22),
          presetBackdropSizeFactor: 0.28,
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.byType(SeasonalDecor), findsOneWidget);
  });

  testWidgets('repeatEvery restarts after playDuration', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          playDuration: const Duration(milliseconds: 200),
          repeatEvery: const Duration(milliseconds: 400),
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.byType(SeasonalDecor), findsOneWidget);
    final dynamic state = tester.state(find.byType(SeasonalDecor));

    expect(state.widget.playDuration, const Duration(milliseconds: 200));
    expect(state.debugIsPlaying() as bool, isTrue);

    state.debugStopPlayingForTest();
    expect(state.debugIsPlaying() as bool, isFalse);
    expect(state.debugIsRepeatTimerActive() as bool, isTrue);
  });

  testWidgets('backdrop layer toggles can hide decorative but keep background',
      (tester) async {
    final preset = SeasonalPreset.ramadan().withOverrides(
      backdrops: const [
        DecorBackdrop.crescent(
          layer: BackdropLayer.background,
          color: Color(0x66FFE2A6),
          opacity: 0.3,
          anchor: Offset(0.84, 0.2),
          sizeFactor: 0.2,
        ),
        DecorBackdrop.bunting(
          layer: BackdropLayer.decorative,
          color: Color(0x55F2D8A5),
          opacity: 0.22,
          anchor: Offset(0.5, 0.11),
          sizeFactor: 0.04,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: preset,
          showBackgroundBackdrops: true,
          showDecorativeBackdrops: false,
          child: const SizedBox.expand(),
        ),
      ),
    );

    final customPaint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((widget) => widget.painter is DecorPainter);
    final painter = customPaint.painter! as DecorPainter;

    expect(painter.config.backdrops, hasLength(1));
    expect(painter.config.backdrops.first.layer, BackdropLayer.background);
    expect(painter.config.backdrops.first.type, BackdropType.crescent);
  });

  testWidgets('particleSizeMultiplier scales particle style sizes',
      (tester) async {
    final preset = SeasonalPreset.ramadan();
    final baseConfig = preset.resolve(DecorIntensity.medium);
    final baseStyle = baseConfig.styles.first;

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: preset,
          intensity: DecorIntensity.medium,
          particleSizeMultiplier: 1.5,
          child: const SizedBox.expand(),
        ),
      ),
    );

    final customPaint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((widget) => widget.painter is DecorPainter);
    final painter = customPaint.painter! as DecorPainter;
    final scaledStyle = painter.config.styles.first;

    expect(scaledStyle.minSize, closeTo(baseStyle.minSize * 1.5, 0.0001));
    expect(scaledStyle.maxSize, closeTo(baseStyle.maxSize * 1.5, 0.0001));
  });

  testWidgets('showText renders default seasonal greeting for preset',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          showText: true,
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.text('Ramadan Kareem'), findsOneWidget);
  });

  testWidgets('custom text is shown and auto-hides after display duration',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.eid(variant: EidVariant.fitr),
          showText: true,
          text: 'Eid Celebration',
          textDisplayDuration: const Duration(milliseconds: 80),
          textAnimationDuration: const Duration(milliseconds: 1),
          child: const SizedBox.expand(),
        ),
      ),
    );

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsTextVisible() as bool, isTrue);
    expect(find.text('Eid Celebration'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 100));
    expect(state.debugIsTextVisible() as bool, isFalse);
  });

  testWidgets('custom text does not show when showText is false',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.eid(variant: EidVariant.fitr),
          showText: false,
          text: 'Eid Celebration',
          child: const SizedBox.expand(),
        ),
      ),
    );

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsTextVisible() as bool, isFalse);
    expect(find.text('Eid Celebration'), findsNothing);
  });

  testWidgets('custom text shows when showText is omitted', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.eid(variant: EidVariant.fitr),
          text: 'Eid Celebration',
          child: const SizedBox.expand(),
        ),
      ),
    );

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsTextVisible() as bool, isTrue);
    expect(find.text('Eid Celebration'), findsOneWidget);
  });

  testWidgets('default text does not show when showText is omitted',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          child: const SizedBox.expand(),
        ),
      ),
    );

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsTextVisible() as bool, isFalse);
    expect(find.text('Ramadan Kareem'), findsNothing);
  });

  testWidgets('text is shown once per repeat series when repeatEvery is set',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          showText: true,
          text: 'Ramadan Kareem',
          playDuration: const Duration(milliseconds: 60),
          repeatEvery: const Duration(milliseconds: 100),
          textDisplayDuration: const Duration(milliseconds: 25),
          textAnimationDuration: const Duration(milliseconds: 1),
          child: const SizedBox.expand(),
        ),
      ),
    );

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsTextVisible() as bool, isTrue);

    await tester.pump(const Duration(milliseconds: 40));
    expect(state.debugIsTextVisible() as bool, isFalse);

    // First cycle stops at 60ms, then repeats at 160ms.
    await tester.pump(const Duration(milliseconds: 130));
    expect(state.debugIsTextVisible() as bool, isFalse);
  });

  testWidgets('arabic text keeps zero letter spacing and no decoration',
      (tester) async {
    const arabicGreeting =
        '\u0631\u0645\u0636\u0627\u0646 \u0643\u0631\u064A\u0645';
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          showText: true,
          text: arabicGreeting,
          child: const SizedBox.expand(),
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.text(arabicGreeting));
    final textStyle = textWidget.style;

    expect(textStyle, isNotNull);
    expect(textStyle!.letterSpacing, 0.0);
    expect(textStyle.decoration, TextDecoration.none);
  });

  testWidgets('custom background backdrop replaces built-in background layer',
      (tester) async {
    const customBackdropKey = Key('custom-background-backdrop');
    final preset = SeasonalPreset.ramadan().withOverrides(
      backdrops: const [
        DecorBackdrop.crescent(
          layer: BackdropLayer.background,
          color: Color(0x66FFE2A6),
          opacity: 0.3,
          anchor: Offset(0.84, 0.2),
          sizeFactor: 0.2,
        ),
        DecorBackdrop.bunting(
          layer: BackdropLayer.decorative,
          color: Color(0x55F2D8A5),
          opacity: 0.22,
          anchor: Offset(0.5, 0.11),
          sizeFactor: 0.04,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: preset,
          backgroundBackdrop: const ColoredBox(
            key: customBackdropKey,
            color: Colors.transparent,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.byKey(customBackdropKey), findsOneWidget);

    final customPaint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((widget) => widget.painter is DecorPainter);
    final painter = customPaint.painter! as DecorPainter;

    expect(painter.config.backdrops, hasLength(1));
    expect(painter.config.backdrops.first.layer, BackdropLayer.decorative);
    expect(painter.config.backdrops.first.type, BackdropType.bunting);
  });

  testWidgets('decorativeBackdropDensityMultiplier is forwarded to painter',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          decorativeBackdropDensityMultiplier: 0.6,
          child: const SizedBox.expand(),
        ),
      ),
    );

    final customPaint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((widget) => widget.painter is DecorPainter);
    final painter = customPaint.painter! as DecorPainter;

    expect(painter.decorativeBackdropDensityMultiplier, closeTo(0.6, 0.0001));
  });

  testWidgets('ramadanBuntingRows is forwarded to painter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          ramadanBuntingRows: 5,
          child: const SizedBox.expand(),
        ),
      ),
    );

    final customPaint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((widget) => widget.painter is DecorPainter);
    final painter = customPaint.painter! as DecorPainter;

    expect(painter.ramadanBuntingRows, 5);
  });

  testWidgets('decorativeBackdropRows is forwarded to painter', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.christmas(),
          decorativeBackdropRows: 4,
          child: const SizedBox.expand(),
        ),
      ),
    );

    final customPaint = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .firstWhere((widget) => widget.painter is DecorPainter);
    final painter = customPaint.painter! as DecorPainter;

    expect(painter.decorativeBackdropRows, 4);
  });
}
