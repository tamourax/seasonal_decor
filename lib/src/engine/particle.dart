import 'dart:ui';

/// Supported particle shapes.
enum ParticleShape {
  circle,
  star,
  crescent,
  lantern,
  balloon,
  sheep,
  gift,
  ornament,
  line,
  heart,
  bat,
  pumpkin,
  confettiRect,
  sparkle,
  ball,
}

/// Distinguishes particle behavior in the system.
enum ParticleKind {
  /// Standard decorative particle.
  normal,

  /// Firework rocket.
  rocket,

  /// Firework spark.
  spark,
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

  /// Behavior type for the particle.
  ParticleKind kind;

  /// Remaining life in seconds.
  double life;

  /// Maximum life in seconds. Zero means infinite.
  double maxLife;

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
    required this.kind,
    required this.life,
    required this.maxLife,
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
        shape = ParticleShape.circle,
        kind = ParticleKind.normal,
        life = 0,
        maxLife = 0;

  /// Returns the remaining life fraction (0..1).
  double get lifeProgress {
    if (maxLife <= 0) {
      return 1.0;
    }
    final value = life / maxLife;
    return value.clamp(0.0, 1.0).toDouble();
  }

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
    required ParticleKind kind,
    required double life,
    required double maxLife,
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
    this.kind = kind;
    this.life = life;
    this.maxLife = maxLife;
  }

  /// Advances the particle by [dt] seconds.
  void update(double dt) {
    if (!active) {
      return;
    }
    position = position + Offset(velocity.dx * dt, velocity.dy * dt);
    rotation += rotationSpeed * dt;
    if (maxLife > 0) {
      life -= dt;
      if (life <= 0) {
        life = 0;
        active = false;
      }
    }
  }
}
