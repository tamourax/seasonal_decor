import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
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
}
