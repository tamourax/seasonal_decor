import 'dart:ui';

/// Supported particle shapes.
enum ParticleShape {
  circle,
  star,
  crescent,
}

/// A single particle in the overlay.
class Particle {
  /// Whether the particle is active and should be updated and painted.
  bool active;

  /// Current position in logical pixels.
  Offset position;

  /// Current velocity in logical pixels per second.
  Offset velocity;

  /// Visual size in logical pixels.
  double size;

  /// Rotation in radians.
  double rotation;

  /// Rotation speed in radians per second.
  double rotationSpeed;

  /// Base color (opacity applied in painter).
  Color color;

  /// Additional opacity multiplier for this particle.
  double opacity;

  /// Shape used by the painter.
  ParticleShape shape;

  Particle({
    required this.active,
    required this.position,
    required this.velocity,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.opacity,
    required this.shape,
  });

  /// Creates an inactive particle ready to be reused.
  Particle.inactive()
      : active = false,
        position = Offset.zero,
        velocity = Offset.zero,
        size = 0,
        rotation = 0,
        rotationSpeed = 0,
        color = const Color(0x00000000),
        opacity = 1,
        shape = ParticleShape.circle;

  /// Resets the particle state for reuse.
  void reset({
    required Offset position,
    required Offset velocity,
    required double size,
    required double rotation,
    required double rotationSpeed,
    required Color color,
    required double opacity,
    required ParticleShape shape,
  }) {
    active = true;
    this.position = position;
    this.velocity = velocity;
    this.size = size;
    this.rotation = rotation;
    this.rotationSpeed = rotationSpeed;
    this.color = color;
    this.opacity = opacity;
    this.shape = shape;
  }

  /// Advances the particle by [dt] seconds.
  void update(double dt) {
    position = position + Offset(velocity.dx * dt, velocity.dy * dt);
    rotation += rotationSpeed * dt;
  }
}
