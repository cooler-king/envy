import 'fill_mode.dart';
import 'playback_direction.dart';
import 'timing_function.dart';

Timing defaultTiming = new Timing();

/// WebIDL:
/// interface Timing {
///    attribute double                             startDelay;
///    attribute FillMode                           fillMode;
///    attribute double                             iterationStart;
///    attribute (unrestricted double or DOMString) iterationDuration;
///    attribute (unrestricted double or DOMString) activeDuration;
///    attribute double                             playbackRate;
///    attribute PlaybackDirection                  direction;
///    attribute DOMString                          timingFunction;
/// }
///
class Timing {
  static const num auto = double.infinity;

  Timing();

  //static final Timing defaultTiming = new Timing();

  /// The number of seconds from a timed item's start time to the start of the active interval.
  num startDelay = 0;

  FillMode fillMode = FillMode.both;

  /// Offset into the series of iterations at which the timed item should begin.
  /// The iteration start is a finite real number greater than or equal to zero.
  ///
  /// For example, a value of 0.5 means start half way through the first iteration.
  ///
  num iterationStart = 0;

  /// A real number greater than or equal to zero (including positive infinity)
  /// representing the number of times to repeat the timed item.
  ///
  num iterationCount = 1;

  /// The iteration duration which is a real number greater than or equal to zero (including positive infinity)
  /// representing the time taken to complete a single iteration of the timed item.
  ///
  /// A null value will be interpreted as "auto".
  ///
  num iterationDuration = 2;

  /// The length of its active interval.
  ///
  num activeDuration = Timing.auto;

  /// This is a multiplier applied to the local time potentially causing the item to run at a
  /// different rate to its natural speed.
  ///
  num playbackRate = 1;

  String direction = PlaybackDirection.normal;

  TimingFunction timingFunction = new LinearFunction();
}
