import '../group_node.dart';
import 'fill_mode.dart';
import 'playback_direction.dart';
import 'player.dart';
import 'timing.dart';
import 'timing_group.dart';

// ignore_for_file: avoid_returning_null

/// The abstract base class for time-based group nodes that provide
/// time fractions (used to interpolate property values) to their children.
/// Concrete subclasses include AnimationGroup, SequenceTimingGroup and
/// ParallelTimingGroup.
abstract class TimedItemGroup extends GroupNode {
  /// Only non-null if parent if a SequenceTimingGroup.  In seconds.
  num _startTime;

  /// The start delay represents the number of seconds from a timed item's
  /// start time to the start of the active interval.
  num _startDelay;

  /// The timing.
  final Timing timing = new Timing();

  /// Optional parent group
  TimingGroup parentTimingGroup;

  /// This group's player.
  /// Setting the player registers this node with it and
  /// de-registers this node from the previous player, if there was one.
  Player get player => _player;
  Player _player;
  set player(Player p) {
    if (_player == p) return;

    // Deregister existing player, if necessary
    if (_player != null) _player.deregisterTimedItemGroup(this);

    _player = p;
    if (p != null) _player.registerTimedItemGroup(this);
  }

  /// For a timed item, the inherited time at a given moment is based on the
  /// first matching condition from the following:
  ///
  /// If the timed item has a parent timing group,the inherited time is the
  /// parent timing group's current transformed time value. If the timed item
  /// is directly associated with a player, the inherited time is the current
  /// time of the player.  Otherwise, the inherited time is null.
  num get inheritedTime {
    if (parentTimingGroup != null) return parentTimingGroup.transformedTime;
    if (player != null) return player.currentTime;
    return null;
  }

  /// A timed item's start time is the moment at which the parent timing group,
  /// if any, has scheduled the timed item to begin. It is expressed in inherited
  /// time. In most cases, including the case when the timed item has no parent
  /// timing group, the start time is zero. The singular exception is sequence
  /// timing groups which set the start times of their children as described in
  /// section 3.13.4.1 of the Web Animation spec:
  /// The start time of children of a sequence timing group.
  num get startTime {
    if (parentTimingGroup is SequenceTimingGroup && _startTime == null)
      (parentTimingGroup as SequenceTimingGroup).calcStartTimes();

    return _startTime ?? 0;
  }

  set startTime(num time) => _startTime = time;

  /// The local time of a timed item is the timed item's inherited time minus
  /// its start time. If the inherited time is null then the local time is also null.
  ///
  /// Children take the transformed time values from their parent -- called the
  /// inherited time -- and add their start time to establish their own
  /// local time space.
  num get localTime {
    final num inherited = inheritedTime;
    return inherited != null ? inherited - startTime : null;
  }

  /// The active time.
  num get activeTime => _calcActiveTime(iterationDuration, localTime);

  num _calcActiveTime(num iterDur, num local) {
    if (local == null) return null;
    if (local < startDelay) {
      if (timing.fillMode == FillMode.backwards || timing.fillMode == FillMode.both) return 0;
      return null;
    }

    final num activeDur = _calcActiveDuration(iterDur);
    if (local < startTime + activeDur) {
      return local - startDelay;
    }

    if (timing.fillMode == FillMode.forwards || timing.fillMode == FillMode.both) {
      return activeDur;
    }

    return null;
  }

  /// The length of the active interval is called the active duration.
  /// Animation will stop at the end of the active interval and snap to
  /// the end state.
  num get activeDuration {
    if (timing.activeDuration == Timing.auto) {
      return _calcActiveDuration(iterationDuration);
    } else {
      return timing.activeDuration;
    }
  }

  num _calcActiveDuration(num iterDur) {
    if (timing.playbackRate == 0) return double.infinity;
    if (timing.activeDuration == Timing.auto || timing.activeDuration < 0) {
      return _calcRepeatedDuration(iterDur) / timing.playbackRate.abs();
    } else {
      return timing.activeDuration;
    }
  }

  /// The normalized active duration.
  num get normalizedActiveDuration {
    if (timing.playbackRate == 0) return double.infinity;
    return _calcRepeatedDuration(1) / timing.playbackRate.abs();
  }

  /// The intrinsic iteration duration of a timed item is zero, however some specific
  /// types of timed item such as timing groups override this behavior and provide an
  /// alternative intrinsic duration (see section 3.13.3.2 The intrinsic iteration
  /// duration of a parallel timing group and section 3.13.4.2 The intrinsic iteration
  /// duration of a sequence timing group).
  num get intrinsicIterationDuration => 0;

  /// The length of a single iteration is called the iteration duration.
  num get iterationDuration {
    if (timing.iterationDuration == Timing.auto || timing.iterationDuration == null) {
      return intrinsicIterationDuration;
    } else {
      return timing.iterationDuration;
    }
  }

  /// Repeated duration = iteration duration * iteration count
  num get repeatedDuration => _calcRepeatedDuration(iterationDuration);

  num _calcRepeatedDuration(num iterDuration) => iterDuration * timing.iterationCount;

  /// The scale active time.
  num get scaledActiveTime => _calcScaledActiveTime(iterationDuration, localTime);

  /// Calculate the scaled active time with the specified iteration duration
  /// and local time.
  num _calcScaledActiveTime(num iterDur, num local) {
    final num active = _calcActiveTime(iterDur, local);
    if (active == null) return null;
    if (timing.playbackRate < 0) {
      print(
          'TimedItemGroup._calcScaledActiveTime neg playback rate... ${(active - _calcActiveDuration(iterDur)) * timing.playbackRate + _calcStartOffset(iterDur)}');
      return (active - _calcActiveDuration(iterDur)) * timing.playbackRate + _calcStartOffset(iterDur);
    }
    return active * timing.playbackRate + _calcStartOffset(iterDur);
  }

  /// The start offset.
  num get startOffset => timing.iterationStart * iterationDuration;

  /// The start delay.
  num get startDelay => _startDelay ?? 0;

  num _calcStartOffset(num iterDur) => timing.iterationStart * iterDur;

  /// The iteration time.
  num get iterationTime => _calcIterationTime(iterationDuration, localTime);

  /// Calculate the iteration time with the specified iteration duration
  /// and local time.
  ///
  num _calcIterationTime(num iterDur, num local, [num scaledActive]) {
    scaledActive ??= _calcScaledActiveTime(iterDur, local);
    if (scaledActive == null) return null;
    if (iterDur == 0) return 0;
    if (timing.iterationCount != 0 &&
        (_calcRepeatedDuration(iterDur) == scaledActive - startOffset) &&
        ((timing.iterationCount + timing.iterationStart) % 1 == 0)) return iterDur;
    return scaledActive % iterDur;
  }

  /// The current iteration.
  num get currentIteration => _calcCurrentIteration(iterationDuration, localTime);

  num _calcCurrentIteration(num iterDur, num local, [num scaledActive, num iterTime]) {
    scaledActive ??= _calcScaledActiveTime(iterDur, local);
    if (scaledActive == null) return null;
    if (scaledActive == 0) return 0;
    if (iterDur == 0) return (timing.iterationStart + timing.iterationCount).floor();
    iterTime ??= _calcIterationTime(iterDur, local, scaledActive);
    if (iterDur == iterTime) return timing.iterationStart + timing.iterationCount - 1;

    return (scaledActive / iterDur).floor();
  }

  /// The directed time.
  num get directedTime => _calcDirectedTime(iterationDuration, localTime);

  /// Calculates the directed time with the specified iteration duration
  /// and local time.
  num _calcDirectedTime(num iterDur, num local) {
    final num scaledActive = _calcScaledActiveTime(iterDur, local);
    final num iterTime = _calcIterationTime(iterDur, local, scaledActive);
    if (iterTime == null) return null;

    // Determine current playback direction
    bool forwards = true;
    if (timing.direction == PlaybackDirection.reverse) {
      forwards = false;
    } else {
      // Alternate or alternate-reverse
      num d = _calcCurrentIteration(iterDur, local, scaledActive, iterTime);
      if (timing.direction == PlaybackDirection.alternateReverse) d += 1;
      if (d % 2 != 0) forwards = false;
    }

    if (forwards) return iterTime;
    return iterDur - iterTime;
  }

  /// The transformed time.
  num get transformedTime => _calcTransformedTime(iterationDuration, localTime);

  /// Calculate the transformed time with the specified iteration duration
  /// and local time.
  num _calcTransformedTime(num iterDur, num local) {
    final num directed = _calcDirectedTime(iterDur, local);
    if (directed == null) return null;
    final num iterFraction = (iterDur == 0) ? 0 : directed / iterDur;
    final num scaledFraction = timing.timingFunction.output(iterFraction);
    return scaledFraction * iterDur;
  }

  ///  End time is the time when this item completes its active interval.
  num get endTime => startTime + startDelay + activeDuration;

  /// Thee time fraction controls the animation.
  num get timeFraction {
    //TODO store time fraction for frame (keyed to global time or frame number?)

    final num iterDur = iterationDuration;

    // Special calc if iteration duration is zero
    if (iterDur == 0) {
      final num local = localTime;
      if (local < startDelay) {
        // Transformed time with iteration duration of 1 and local = startTime - 1
        return _calcTransformedTime(1, startTime - 1);
      } else {
        // Transformed time with iteration duration of 1 and normalized active duration
        return _calcTransformedTime(1, normalizedActiveDuration);
      }
    }
    final num transformed = transformedTime;
    return (transformed == null) ? null : transformed / iterDur;
  }

  /// Updates this group and all its children for the specified [timeFraction].
  ///
  /// If the [context] is a Boolean value it is interpreted as a 'direct' update
  /// from its own [Player].  If a [TimedItemGroup] has its own Player and the update
  /// is not direct, it will be ignored.
  ///
  @override
  void update(num timeFraction, {dynamic context = false, bool finish = false}) {
    // If this TimedItemGroup has its own player then ignore indirect updates from other players
    final bool direct = context is bool && context;
    if (player != null && !direct) return;
    super.update(timeFraction, finish: finish);
  }

  /// Finishes an animation by doing a final update with the `finish` flag set to true.
  void finishAnimation({dynamic context = false}) {
    update(1.0, context: context, finish: true);
    if (player != null) player.deregisterTimedItemGroup(this);
  }
}
