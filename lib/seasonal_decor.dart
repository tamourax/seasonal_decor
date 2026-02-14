// ignore_for_file: unnecessary_library_name
/// Seasonal decor package public API.
library seasonal_decor;

export 'src/config/decor_config.dart'
    show BackdropLayer, BackdropType, DecorBackdrop, DecorConfig, ParticleStyle;
export 'src/config/intensity.dart';
export 'src/engine/particle.dart' show ParticleShape;
export 'src/presets/christmas.dart' show ChristmasVariant;
export 'src/presets/eid.dart' show EidVariant;
export 'src/presets/halloween.dart' show HalloweenVariant;
export 'src/presets/new_year.dart' show NewYearVariant;
export 'src/presets/ramadan.dart' show RamadanVariant;
export 'src/presets/football.dart' show SportEventVariant;
export 'src/presets/seasonal_preset.dart';
export 'src/presets/valentine.dart' show ValentineVariant;
export 'src/widgets/seasonal_decor.dart';
