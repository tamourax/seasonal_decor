import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:seasonal_decor/src/config/decor_config.dart';
import 'package:seasonal_decor/src/engine/particle.dart';
import 'package:seasonal_decor/src/engine/particle_system.dart';

void main() {
  test('particle system updates particle positions', () {
    const config = DecorConfig(
      particleCount: 1,
      speedMultiplier: 1.0,
      spawnRate: 60,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.wrap,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 50,
          maxSpeed: 50,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(200, 200),
      random: math.Random(1),
    );

    final particle = system.particles.first;
    final startY = particle.position.dy;
    system.update(0.5);
    expect(particle.position.dy, greaterThan(startY));
  });

  test('particle system respawns out-of-bounds particles', () {
    const config = DecorConfig(
      particleCount: 1,
      speedMultiplier: 1.0,
      spawnRate: 120,
      spawnRateScale: 1.0,
      drift: 0,
      flow: ParticleFlow.falling,
      wrapMode: DecorWrapMode.respawn,
      styles: [
        ParticleStyle(
          shape: ParticleShape.circle,
          color: Color(0xFFFFFFFF),
          minSize: 2.0,
          maxSize: 2.0,
          minSpeed: 10,
          maxSpeed: 10,
          minRotationSpeed: 0,
          maxRotationSpeed: 0,
        ),
      ],
    );

    final system = ParticleSystem(
      config: config,
      size: const Size(100, 100),
      random: math.Random(2),
    );

    final particle = system.particles.first;
    particle.position = const Offset(50, 500);

    system.update(0.1);

    expect(particle.active, isTrue);
    expect(particle.position.dy, lessThanOrEqualTo(0));
  });
}
