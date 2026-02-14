import 'package:flutter/foundation.dart';

import '../scene/seasonal_mode.dart';

/// A queued moment trigger event.
@immutable
class SeasonalMomentEvent {
  final int id;
  final SeasonalMoment moment;
  final SeasonalMomentOptions options;

  const SeasonalMomentEvent({
    required this.id,
    required this.moment,
    required this.options,
  });
}

/// Public controller used to trigger short-lived seasonal moments.
class SeasonalDecorController extends ChangeNotifier {
  final List<SeasonalMomentEvent> _events = <SeasonalMomentEvent>[];
  int _nextId = 0;
  static const int _maxEventHistory = 40;

  /// Enqueues a moment trigger for active [SeasonalDecor] widgets.
  void trigger(
    SeasonalMoment moment, {
    SeasonalMomentOptions options = const SeasonalMomentOptions(),
  }) {
    _events.add(
      SeasonalMomentEvent(
        id: _nextId,
        moment: moment,
        options: options.copyWith(
          intensity: options.intensity.clamp(0.0, 1.0).toDouble(),
        ),
      ),
    );
    _nextId += 1;
    if (_events.length > _maxEventHistory) {
      _events.removeAt(0);
    }
    notifyListeners();
  }

  /// Clears pending moment requests that were not consumed yet.
  void clearMoments() {
    if (_events.isEmpty) {
      return;
    }
    _events.clear();
    notifyListeners();
  }

  /// Returns true when there are queued moments.
  bool get hasPendingMoments => _events.isNotEmpty;

  /// Returns all events with `id > lastSeenId`.
  List<SeasonalMomentEvent> eventsSince(int lastSeenId) {
    if (_events.isEmpty) {
      return const [];
    }
    return _events
        .where((event) => event.id > lastSeenId)
        .toList(growable: false);
  }

  /// Latest moment event id, or `-1` if none.
  int get latestEventId => _events.isEmpty ? -1 : _events.last.id;

  /// Returns event by id if available.
  SeasonalMomentEvent? eventById(int id) {
    for (final event in _events) {
      if (event.id == id) {
        return event;
      }
    }
    return null;
  }
}
