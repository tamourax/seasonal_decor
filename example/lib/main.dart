import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  runApp(const SimpleSeasonalDecorApp());
}

class SimpleSeasonalDecorApp extends StatelessWidget {
  const SimpleSeasonalDecorApp({super.key});

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
        preset: SeasonalPreset.ramadan(),
        intensity: DecorIntensity.medium,
        text: 'Ramadan Kareem',
        playDuration: const Duration(seconds: 8),
        repeatEvery: const Duration(seconds: 12),
        child: const _SimpleHomePage(),
      ),
    );
  }
}

class _SimpleHomePage extends StatelessWidget {
  const _SimpleHomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('seasonal_decor')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Simple example\nWrap any page with SeasonalDecor.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
