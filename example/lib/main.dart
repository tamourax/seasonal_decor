import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  runApp(const SimpleSeasonalDecorApp());
}

class SimpleSeasonalDecorApp extends StatefulWidget {
  const SimpleSeasonalDecorApp({super.key});

  @override
  State<SimpleSeasonalDecorApp> createState() => _SimpleSeasonalDecorAppState();
}

class _SimpleSeasonalDecorAppState extends State<SimpleSeasonalDecorApp> {
  final SeasonalDecorController _controller = SeasonalDecorController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'seasonal_decor simple example',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16A085)),
      ),
      home: SeasonalDecor(
        controller: _controller,
        preset: SeasonalPreset.ramadan(),
        intensity: DecorIntensity.medium,
        text: 'Ramadan Kareem',
        playDuration: const Duration(seconds: 8),
        repeatEvery: const Duration(seconds: 12),
        child: _SimpleHomePage(controller: _controller),
      ),
    );
  }
}

class _SimpleHomePage extends StatelessWidget {
  final SeasonalDecorController controller;

  const _SimpleHomePage({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('seasonal_decor 1.4.0')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Simple example\nSeasonal preset + Action Celebrations.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.tonal(
                    onPressed: () => controller.celebrate(
                      CelebrationPreset.paymentSuccess(),
                    ),
                    child: const Text('Payment Success'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => controller.celebrate(
                      CelebrationPreset.bookingCompleted(),
                    ),
                    child: const Text('Booking Confirmed'),
                  ),
                  FilledButton.tonal(
                    onPressed: () => controller.celebrate(
                      CelebrationPreset.achievementUnlocked(),
                    ),
                    child: const Text('Achievement Unlocked'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
