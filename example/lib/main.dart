import 'package:flutter/material.dart';
import 'package:seasonal_decor/seasonal_decor.dart';

void main() {
  runApp(const SeasonalDecorSimpleApp());
}

class SeasonalDecorSimpleApp extends StatelessWidget {
  const SeasonalDecorSimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seasonal Decor',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1BB8A3),
          brightness: Brightness.light,
        ),
      ),
      home: const SimpleHome(),
    );
  }
}

class SimpleHome extends StatelessWidget {
  const SimpleHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SeasonalDecor(
      decorativeBackdropRows: 1,
      preset: SeasonalPreset.ramadan(variant: RamadanVariant.hangingLanterns),
      intensity: DecorIntensity.extraHigh,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Seasonal Decor'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Drop-in seasonal overlays',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text('Wrap any screen with SeasonalDecor.'),
            ],
          ),
        ),
      ),
    );
  }
}
