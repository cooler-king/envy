import 'player.dart';

/// A [Timeline] has a zero point on the global system clock and
/// is not scaled; it's seconds are equal to wall-clock seconds.
/// All time properties are returned in seconds (not milliseconds).
class Timeline {
  /// Define a Timeline by specifying its zero time as its creation time.
  Timeline.now() : startMillis = DateTime.now().millisecondsSinceEpoch;

  /// Define a Timeline by specifying its zero time in milliseconds since epoch.
  Timeline.zeroMillis(this.startMillis);

  /// Define a Timeline by specifying its zero time as a DateTime.
  Timeline.zeroDateTime(DateTime zero) : startMillis = zero.millisecondsSinceEpoch;

  /// Derives this Timeline by applying an offset in milliseconds to an existing Timeline.
  Timeline.derive(Timeline t1, int millisOffset) : startMillis = t1.startMillis + millisOffset;

  /// The zero point of this timeline with respect to the global clock, in milliseconds.
  final int startMillis;

  /// Gets the current time in this Timeline's frame, in seconds.
  /// If the current global time is before the timeline's start time
  /// null will be returned (consistent with the Web Animations spec).
  num get currentTime => started ? (DateTime.now().millisecondsSinceEpoch - startMillis) / 1000.0 : null;

  /// A Timeline is considered started if its start time is less than or equal to the
  /// current global time.
  bool get started => DateTime.now().millisecondsSinceEpoch >= startMillis;

  /// Creates a Player bound to this timeline and having a start time
  /// equal to the [currentTime] plus a little bit (or 0 if the timeline has not yet started).
  /// A small amount of delay before starting is added so that the timing setup can complete
  /// before the animation loop begins.
  Player play() {
    final current = currentTime;

    // Add 10 milliseconds for a little setup time
    return Player(this, current != null ? current + 0.01 : 0);
  }

  /// Returns the current time in the Timeline's frame, in seconds.
  /// Unlike [currentTime] the [effectiveTime] will be 0 if the
  /// timeline has not yet started.
  num get effectiveTime => started ? (DateTime.now().millisecondsSinceEpoch - startMillis) / 1000.0 : 0;
}
