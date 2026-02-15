import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/seasonal_decor.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';

void main() {
  group('ParticleStyle equality', () {
    test('same values are equal', () {
      final a = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      final b = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      expect(a, equals(b));
    });

    test('different shape → not equal', () {
      final a = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      final b = ParticleStyle(
        shape: ParticleShape.star,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      expect(a, isNot(equals(b)));
    });

    test('different color → not equal', () {
      final a = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      final b = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFF00FF00),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      expect(a, isNot(equals(b)));
    });

    test('different size → not equal', () {
      final a = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      final b = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 3,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent for equal objects', () {
      final a = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      final b = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('DecorBackdrop equality', () {
    test('same values are equal', () {
      final a = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      final b = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      expect(a, equals(b));
    });

    test('different type → not equal', () {
      final a = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      final b = DecorBackdrop(
        type: BackdropType.tree,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      expect(a, isNot(equals(b)));
    });

    test('different color → not equal', () {
      final a = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      final b = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFF00FF00),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      expect(a, isNot(equals(b)));
    });

    test('hashCode is consistent for equal objects', () {
      final a = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      final b = DecorBackdrop(
        type: BackdropType.crescent,
        color: const Color(0xFFFFD700),
        opacity: 0.3,
        anchor: const Offset(0.5, 0.2),
        sizeFactor: 0.4,
      );
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  group('DecorConfig equality', () {
    DecorConfig makeConfig(
        {int particleCount = 50, List<ParticleStyle>? styles}) {
      return DecorConfig(
        particleCount: particleCount,
        speedMultiplier: 1.0,
        spawnRate: 8.0,
        drift: 0.0,
        flow: ParticleFlow.falling,
        wrapMode: DecorWrapMode.respawn,
        spawnRateScale: 1.0,
        styles: styles ??
            [
              ParticleStyle(
                shape: ParticleShape.circle,
                color: const Color(0xFFFF0000),
                minSize: 2,
                maxSize: 6,
                minSpeed: 10,
                maxSpeed: 30,
                minRotationSpeed: 0.1,
                maxRotationSpeed: 0.5,
              ),
            ],
      );
    }

    test('same values are equal', () {
      expect(makeConfig(), equals(makeConfig()));
    });

    test('different particleCount → not equal', () {
      expect(makeConfig(particleCount: 50),
          isNot(equals(makeConfig(particleCount: 100))));
    });

    test('different styles list → not equal', () {
      final style1 = ParticleStyle(
        shape: ParticleShape.circle,
        color: const Color(0xFFFF0000),
        minSize: 2,
        maxSize: 6,
        minSpeed: 10,
        maxSpeed: 30,
        minRotationSpeed: 0.1,
        maxRotationSpeed: 0.5,
      );
      final style2 = ParticleStyle(
        shape: ParticleShape.star,
        color: const Color(0xFF00FF00),
        minSize: 3,
        maxSize: 7,
        minSpeed: 15,
        maxSpeed: 35,
        minRotationSpeed: 0.2,
        maxRotationSpeed: 0.6,
      );
      expect(
        makeConfig(styles: [style1]),
        isNot(equals(makeConfig(styles: [style2]))),
      );
    });

    test('hashCode is consistent for equal objects', () {
      final a = makeConfig();
      final b = makeConfig();
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
