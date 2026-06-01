import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';
import 'package:seasonal_decor/src/engine/decor_painter.dart';

void main() {
  Set<ParticleShape> shapeSet(CelebrationPreset preset) {
    return preset.resolve().styles.map((style) => style.shape).toSet();
  }

  test('all action presets have particles and no backdrops', () {
    final presets = <CelebrationPreset>[
      CelebrationPreset.paymentSuccess(),
      CelebrationPreset.moneyTransferSuccess(),
      CelebrationPreset.purchaseSuccess(),
      CelebrationPreset.bookingCompleted(),
      CelebrationPreset.appointmentConfirmed(),
      CelebrationPreset.accountCreated(),
      CelebrationPreset.rewardClaimed(),
      CelebrationPreset.achievementUnlocked(),
      CelebrationPreset.goalReached(),
      CelebrationPreset.milestoneReached(),
    ];

    for (final preset in presets) {
      final config = preset.resolve();
      expect(config.styles, isNotEmpty);
      expect(config.backdrop, isNull);
      expect(config.backdrops, isEmpty);
    }
  });

  test('every action preset has a distinct shape-set identity', () {
    final sets = <Set<ParticleShape>>[
      shapeSet(CelebrationPreset.paymentSuccess()),
      shapeSet(CelebrationPreset.moneyTransferSuccess()),
      shapeSet(CelebrationPreset.purchaseSuccess()),
      shapeSet(CelebrationPreset.bookingCompleted()),
      shapeSet(CelebrationPreset.appointmentConfirmed()),
      shapeSet(CelebrationPreset.accountCreated()),
      shapeSet(CelebrationPreset.rewardClaimed()),
      shapeSet(CelebrationPreset.achievementUnlocked()),
      shapeSet(CelebrationPreset.goalReached()),
      shapeSet(CelebrationPreset.milestoneReached()),
    ];

    for (var i = 0; i < sets.length; i += 1) {
      for (var j = i + 1; j < sets.length; j += 1) {
        expect(sets[i], isNot(equals(sets[j])));
      }
    }
  });

  test('required action shape mappings are present', () {
    expect(
      shapeSet(CelebrationPreset.paymentSuccess()),
      containsAll(<ParticleShape>[ParticleShape.check, ParticleShape.coin]),
    );
    expect(
      shapeSet(CelebrationPreset.moneyTransferSuccess()),
      containsAll(<ParticleShape>[ParticleShape.money, ParticleShape.coin]),
    );
    expect(
      shapeSet(CelebrationPreset.bookingCompleted()),
      containsAll(<ParticleShape>[ParticleShape.calendar, ParticleShape.check]),
    );
    expect(
      shapeSet(CelebrationPreset.achievementUnlocked()),
      containsAll(<ParticleShape>[ParticleShape.trophy, ParticleShape.medal]),
    );
    expect(
      shapeSet(CelebrationPreset.goalReached()),
      contains(ParticleShape.target),
    );
    expect(
      shapeSet(CelebrationPreset.rewardClaimed()),
      anyOf(
        contains(ParticleShape.gift),
        contains(ParticleShape.medal),
      ),
    );
  });

  test('existing seasonal preset API remains functional', () {
    final config = SeasonalPreset.ramadan().resolve(DecorIntensity.medium);
    expect(config.styles, isNotEmpty);
  });

  testWidgets('SeasonalDecor with Ramadan preset still works', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.ramadan(),
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(find.byType(SeasonalDecor), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('controller can trigger payment success celebration',
      (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          controller: controller,
          preset: SeasonalPreset.none(),
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.paymentSuccess(
        playDuration: const Duration(milliseconds: 120),
      ),
    );
    await tester.pump();

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsCelebrationActive() as bool, isTrue);
    expect(find.text('Payment successful'), findsOneWidget);
  });

  testWidgets('celebration restores previous seasonal state after finishing',
      (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          controller: controller,
          preset: SeasonalPreset.ramadan(),
          showText: true,
          textDisplayDuration: const Duration(milliseconds: 50),
          textAnimationDuration: const Duration(milliseconds: 1),
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.paymentSuccess(
        playDuration: const Duration(milliseconds: 100),
      ),
    );
    await tester.pump();

    expect(find.text('Payment successful'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 170));

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsCelebrationActive() as bool, isFalse);
    expect(find.text('Payment successful'), findsNothing);
    expect(find.text('Ramadan Kareem'), findsOneWidget);
  });

  testWidgets('celebration works when base preset is none', (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          controller: controller,
          particleSpeedMultiplier: 6.0,
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.bookingCompleted(
        playDuration: const Duration(milliseconds: 120),
      ),
    );
    await tester.pump();

    expect(find.text('Booking confirmed'), findsOneWidget);
  });

  testWidgets('custom text overrides default celebration text', (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          controller: controller,
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.paymentSuccess(
        text: 'Paid!',
        playDuration: const Duration(milliseconds: 120),
      ),
    );
    await tester.pump();

    expect(find.text('Paid!'), findsOneWidget);
    expect(find.text('Payment successful'), findsNothing);
  });

  testWidgets('respectReduceMotion is honored during celebration',
      (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          home: SeasonalDecor(
            controller: controller,
            respectReduceMotion: true,
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.rewardClaimed(
        playDuration: const Duration(milliseconds: 120),
      ),
    );
    await tester.pump();

    final painter = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((widget) => widget.painter)
        .whereType<DecorPainter>()
        .first;
    expect(painter.staticMode, isTrue);
  });

  testWidgets('latest celebration replaces active celebration', (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          controller: controller,
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.paymentSuccess(
        text: 'First',
        playDuration: const Duration(seconds: 1),
      ),
    );
    controller.celebrate(
      CelebrationPreset.rewardClaimed(
        text: 'Second',
        playDuration: const Duration(milliseconds: 140),
      ),
    );
    await tester.pump();

    expect(find.text('Second'), findsOneWidget);
    expect(find.text('First'), findsNothing);
  });

  testWidgets('celebration does not repeat by default', (tester) async {
    final controller = SeasonalDecorController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          controller: controller,
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.celebrate(
      CelebrationPreset.paymentSuccess(
        playDuration: const Duration(milliseconds: 80),
      ),
    );
    await tester.pump();

    final dynamic state = tester.state(find.byType(SeasonalDecor));
    expect(state.debugIsCelebrationActive() as bool, isTrue);
    expect(find.text('Payment successful'), findsOneWidget);

    // Ensure the one-shot celebration does not re-trigger after its first text
    // cycle completes.
    await tester.pump(const Duration(milliseconds: 3000));
    expect(state.debugIsTextVisible() as bool, isFalse);
    expect(state.debugIsRepeatTimerActive() as bool, isFalse);

    await tester.pump(const Duration(seconds: 2));
    expect(state.debugIsTextVisible() as bool, isFalse);
    expect(state.debugIsRepeatTimerActive() as bool, isFalse);
  });
}
