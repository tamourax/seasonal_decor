import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';
import 'package:seasonal_decor/src/scene/scene_registry.dart';

void main() {
  test('seasonal decor controller publishes ordered events', () {
    final controller = SeasonalDecorController();
    controller.trigger(SeasonalMoment.greetingBurst);
    controller.trigger(
      SeasonalMoment.successBurst,
      options: const SeasonalMomentOptions(intensity: 0.6),
    );

    final allEvents = controller.eventsSince(-1);
    expect(allEvents, hasLength(2));
    expect(allEvents.first.id, lessThan(allEvents.last.id));
    expect(allEvents.first.moment, SeasonalMoment.greetingBurst);
    expect(allEvents.last.options.intensity, closeTo(0.6, 0.0001));
  });

  test('scene registry resolves dedicated presets', () {
    expect(SceneRegistry.resolve(SeasonalPreset.ramadan()).id, 'ramadan');
    expect(SceneRegistry.resolve(SeasonalPreset.christmas()).id, 'christmas');
    expect(SceneRegistry.resolve(SeasonalPreset.newYear()).id, 'new_year');
  });

  testWidgets('seasonal decor accepts mode and external controller',
      (tester) async {
    final controller = SeasonalDecorController();
    await tester.pumpWidget(
      MaterialApp(
        home: SeasonalDecor(
          preset: SeasonalPreset.newYear(),
          mode: SeasonalMode.festive,
          controller: controller,
          child: const SizedBox.expand(),
        ),
      ),
    );

    controller.trigger(SeasonalMoment.fireworksBurst);
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));

    expect(find.byType(SeasonalDecor), findsOneWidget);
  });
}
