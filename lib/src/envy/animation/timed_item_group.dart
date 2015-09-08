part of envy;

/// The abstract base class for time-based group nodes that provide
/// time fractions (used to interpolate property values) to their children.
///
/// Concrete subclasses include AnimationGroup, SequenceTimingGroup and
/// ParallelTimingGroup.
///
abstract class TimedItemGroup extends GroupNode {

  /// Only non-null if parent if a SequenceTimingGroup.  In seconds.
  num _startTime;

  /// The start delay represents the number of seconds from a timed item's
  /// start time to the start of the active interval.
  ///
  num _startDelay;

  final Timing timing = new Timing();

  /// Optional parent group
  TimingGroup parentTimingGroup;

  /// Direct Player
  Player _player;

  /// Values are calculated only once in the context of the calculation of a time fraction.
  /*
  bool _timeFractionContext = false;
  num _activeDuration;
  num _activeTime;
  num _localTime;
  */

  Player get player => _player;

  /// Sets the player and registers this node with it.
  ///
  /// Deregisters from the previous player, if there was one.
  ///
  void set player(Player p) {
    if (_player == p) return;

    // Deregister existing player, if necessary
    if (_player != null) _player._deregisterTimedItemGroup(this);

    _player = p;
    if (p != null) _player._registerTimedItemGroup(this);
  }

  /// For a timed item, the inherited time at a given moment is based on the
  /// first matching condition from the following:
  ///
  /// If the timed item has a parent timing group,the inherited time is the
  /// parent timing group's current transformed time value. If the timed item
  /// is directly associated with a player, the inherited time is the current
  /// time of the player.  Otherwise, the inherited time is null.
  ///
  num get inheritedTime {
    if (parentTimingGroup != null) return parentTimingGroup.transformedTime;
    //print("inheritedTime.... player = ${player.hashCode}");
    //print("inheritedTime.... player.currentTime = ${player.currentTime}");
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
  ///
  num get startTime {
    if (parentTimingGroup is SequenceTimingGroup && _startTime == null) (parentTimingGroup as SequenceTimingGroup)
        ._calcStartTimes();

    return _startTime == null ? 0 : _startTime;
  }

  /// The local time of a timed item is the timed item's inherited time minus
  /// its start time. If the inherited time is null then the local time is also null.
  ///
  /// Children take the transformed time values from their parent -- called the
  /// inherited time -- and add their start time to establish their own
  /// local time space.
  ///
  num get localTime {
    /*
    if(_timeFractionContext) {
      if(_localTime == null) {
        num inherited = inheritedTime;
        _localTime = inherited != null ? inherited - startTime : null;
      }
      return _localTime;
    }
    */

    num inherited = inheritedTime;
    return inherited != null ? inherited - startTime : null;
  }

  num get activeTime {
    /*
    if(_timeFractionContext) {
      if(_activeTime == null) _activeTime = _calcActiveTime(iterationDuration, localTime);
      return _activeTime;
    }
    */

    return _calcActiveTime(iterationDuration, localTime);
  }

  num _calcActiveTime(num iterDur, num local) {
    //print("TimedItemGroup._calcActiveTime... 1,  iterDur/local = ${iterDur}/${local}");
    if (local == null) return null;
    //print("TimedItemGroup._calcActiveTime... 2, startDElay = ${startDelay}");
    if (local < startDelay) {
      //print("TimedItemGroup._calcActiveTime... 3, fill mode = ${timing.fillMode}");
      if (timing.fillMode == FillMode.BACKWARDS || timing.fillMode == FillMode.BOTH) return 0;
      //print("TimedItemGroup._calcActiveTime... 4, returning null");
      return null;
    }
    //print("TimedItemGroup._calcActiveTime... 5, startTime + _calcActiveDuration(iterDur) = ${startTime + _calcActiveDuration(iterDur)}");

    num activeDur = _calcActiveDuration(iterDur);
    if (local < startTime + activeDur) {
      //print("TimedItemGroup._calcActiveTime 5b... ${local - startDelay}");
      return local - startDelay;
    }
    //print("TimedItemGroup._calcActiveTime... 6, fill mode = ${timing.fillMode}");

    if (timing.fillMode == FillMode.FORWARDS || timing.fillMode == FillMode.BOTH) {
      //print("TimedItemGroup._calcActiveTime...6b ${activeDur}");
      return activeDur;
    }
    //print("TimedItemGroup._calcActiveTime... 7, returning null");

    return null;
  }

  /// The length of the active interval is called the active duration.
  ///
  /// Animation will stop at the end of teh active interval and snap to
  /// the end state.
  ///
  num get activeDuration {
    if (timing.activeDuration == Timing.AUTO) {
      return _calcActiveDuration(iterationDuration);
    } else {
      return timing.activeDuration;
    }
  }

  num _calcActiveDuration(num iterDur) {
    if (timing.playbackRate == 0) return double.INFINITY;
    if (timing.activeDuration == Timing.AUTO || timing.activeDuration < 0) {
      return _calcRepeatedDuration(iterDur) / timing.playbackRate.abs();
    } else {
      return timing.activeDuration;
    }
  }

  num get normalizedActiveDuration {
    //print("TimedItemGroup.normalizedActiveDuration... 1");
    if (timing.playbackRate == 0) return double.INFINITY;
    //print("TimedItemGroup.normalizedActiveDuration... 2");
    return _calcRepeatedDuration(1) / timing.playbackRate.abs();
  }

  /// The intrinsic iteration duration of a timed item is zero, however some specific
  /// types of timed item such as timing groups override this behavior and provide an
  /// alternative intrinsic duration (see section 3.13.3.2 The intrinsic iteration
  /// duration of a parallel timing group and section 3.13.4.2 The intrinsic iteration
  /// duration of a sequence timing group).
  ///
  num get intrinsicIterationDuration => 0;

  /// The length of a single iteration is called the iteration duration.
  ///
  num get iterationDuration {
    if (timing.iterationDuration == Timing.AUTO || timing.iterationDuration == null) {
      return intrinsicIterationDuration;
    } else {
      return timing.iterationDuration;
    }
  }

  /// repeated duration = iteration duration * iteration count
  ///
  num get repeatedDuration => _calcRepeatedDuration(iterationDuration);

  num _calcRepeatedDuration(num iterDuration) => iterDuration * timing.iterationCount;

  num get scaledActiveTime => _calcScaledActiveTime(iterationDuration, localTime);

  /// Calculate the scaled active time with the specified iteration duration
  /// and local time.
  ///
  num _calcScaledActiveTime(num iterDur, num local) {
    //print("TimedItemGroup._calcScaledActiveTime... 1 iterDur/local = ${iterDur}/${local}");
    num active = _calcActiveTime(iterDur, local);
    //print("TimedItemGroup._calcScaledActiveTime... 2");
    if (active == null) return null;
    //print("TimedItemGroup._calcScaledActiveTime... 3");
    if (timing.playbackRate < 0) {
      print(
          "TimedItemGroup._calcScaledActiveTime neg playback rate... ${(active - _calcActiveDuration(iterDur)) * timing.playbackRate + _calcStartOffset(iterDur)}");
      return (active - _calcActiveDuration(iterDur)) * timing.playbackRate + _calcStartOffset(iterDur);
    }
    //print("TimedItemGroup._calcScaledActiveTime... 4");
    //print("TimedItemGroup._calcScaledActiveTime... 4a... ${active}");
    //print("TimedItemGroup._calcScaledActiveTime... 4b... ${timing.playbackRate}");
    //print("TimedItemGroup._calcScaledActiveTime... 4c... ${_calcStartOffset(iterDur)}");

    //print("TimedItemGroup._calcScaledActiveTime... ${active * timing.playbackRate + _calcStartOffset(iterDur)}");
    return active * timing.playbackRate + _calcStartOffset(iterDur);
  }

  num get startOffset => timing.iterationStart * iterationDuration;

  num get startDelay => _startDelay != null ? _startDelay : 0;

  num _calcStartOffset(num iterDur) => timing.iterationStart * iterDur;

  num get iterationTime => _calcIterationTime(iterationDuration, localTime);

  /// Calculate the iteration time with the specified iteration duration
  /// and local time.
  ///
  num _calcIterationTime(num iterDur, num local, [num scaledActive]) {
    //print("TimedItemGroup._calcIterationTime... 1 iterDur/local = ${iterDur}/${local}");
    if (scaledActive == null) scaledActive = _calcScaledActiveTime(iterDur, local);
    //print("TimedItemGroup._calcIterationTime... 2");
    if (scaledActive == null) return null;
    //print("TimedItemGroup._calcIterationTime... 3");
    if (iterDur == 0) return 0;
    //print("TimedItemGroup._calcIterationTime... 4");

    //print("TimedItemGroup._calcIterationTime... 5");
    //print("sat=${sat}");
    if (timing.iterationCount != 0 &&
        (_calcRepeatedDuration(iterDur) == scaledActive - startOffset) &&
        ((timing.iterationCount + timing.iterationStart) % 1 == 0)) return iterDur;
    //print("TimedItemGroup._calcIterationTime... ${scaledActive % iterDur}");

    return scaledActive % iterDur;
  }

  num get currentIteration => _calcCurrentIteration(iterationDuration, localTime);

  num _calcCurrentIteration(num iterDur, num local, [num scaledActive, num iterTime]) {
    if (scaledActive == null) scaledActive = _calcScaledActiveTime(iterDur, local);
    if (scaledActive == null) return null;
    if (scaledActive == 0) return 0;
    if (iterDur == 0) return (timing.iterationStart + timing.iterationCount).floor();
    if (iterTime == null) iterTime = _calcIterationTime(iterDur, local, scaledActive);
    if (iterDur == iterTime) return timing.iterationStart + timing.iterationCount - 1;

    return (scaledActive / iterDur).floor();
  }

  num get directedTime => _calcDirectedTime(iterationDuration, localTime);

  /// Calculate the directed time with the specified iteration duration
  /// and local time.
  ///
  num _calcDirectedTime(num iterDur, num local) {
    num scaledActive = _calcScaledActiveTime(iterDur, local);
    //print("TimedItemGroup._calcDirectedTime... 1 iterDur/local = ${iterDur}/${local}");
    num iterTime = _calcIterationTime(iterDur, local, scaledActive);
    //print("TimedItemGroup._calcDirectedTime... 2");
    if (iterTime == null) return null;
    //print("TimedItemGroup._calcDirectedTime... 3");

    // Determine current playback direction
    //print("TimedItemGroup._calcDirectedTime... 4");
    bool forwards = true;
    if (timing.direction == PlaybackDirection.reverse) {
      //print("TimedItemGroup._calcDirectedTime... 5");
      forwards = false;
    } else {
      // alternate or alternate-reverse
      //print("TimedItemGroup._calcDirectedTime... 6");
      num d = _calcCurrentIteration(iterDur, local, scaledActive, iterTime);
      //print("TimedItemGroup._calcDirectedTime... 7");
      if (timing.direction == PlaybackDirection.alternate_reverse) d += 1;
      //print("TimedItemGroup._calcDirectedTime... 8");
      if (d % 2 != 0) forwards = false;
      //print("TimedItemGroup._calcDirectedTime... 9");
    }

    //print("TimedItemGroup._calcDirectedTime... 10");
    if (forwards) return iterTime;
    //print("iterDur = ${iterDur}");
    //print("TimedItemGroup._calcDirectedTime... ${iterDur - iterTime}");
    return iterDur - iterTime;
  }

  num get transformedTime => _calcTransformedTime(iterationDuration, localTime);

  /// Calculate the transformed time with the specified iteration duration
  /// and local time.
  ///
  num _calcTransformedTime(num iterDur, num local) {
    //print("TimedItemGroup._calcTransformedTime... iterDur/local = ${iterDur}/${local}");

    num directed = _calcDirectedTime(iterDur, local);
    //print("TimedItemGroup._calcTransformedTime... 2");
    if (directed == null) return null;
    //print("TimedItemGroup._calcTransformedTime... directed = ${directed}");

    num iterFraction = (iterDur == 0) ? 0 : directed / iterDur;
    //print("TimedItemGroup._calcTransformedTime... iterFraction = ${iterFraction}");
    num scaledFraction = timing.timingFunction.output(iterFraction);
    //print("TimedItemGroup._calcTransformedTime... scaledFraction = ${scaledFraction}");
    //print("TimedItemGroup._calcTransformedTime... ${scaledFraction * iterDur}");
    return scaledFraction * iterDur;
  }

  ///  End time is the time when this item completes its active interval.
  ///
  num get endTime => startTime + startDelay + activeDuration;

  /// Thee time fraction controls the animation.
  ///
  num get timeFraction {
    //_timeFractionContext = true;
    //print("-------------------------------------------------");
    //print("TimedItemGroup.timeFraction...");

    //TODO store time fraction for frame (keyed to global time or frame number?)

    num iterDur = iterationDuration;

    // Special calc if iteration duration is zero
    num transformed;
    if (iterDur == 0) {
      // print("TimedItemGroup.timeFraction... 3");
      num local = localTime;
      //print("TimedItemGroup.timeFraction... 4... local = ${local}");
      if (local < startDelay) {
        transformed = _calcTransformedTime(1, startTime - 1);
        // transformed time with iteration duration of 1 and local = startTime - 1
        //print("********** timefraction... returning = ${transformed}");
        //_clearTimeFractionContext();
        return transformed;
      } else {
        //print("********** TimedItemGroup.timeFraction... 5a normalizedActiveDuration = ${normalizedActiveDuration}");
        transformed = _calcTransformedTime(1, normalizedActiveDuration);
        // transformed time with iteration duration of 1 and normalized active duration
        //print("********** TimedItemGroup.timeFraction... 5b returning ${transformed}");
        //_clearTimeFractionContext();
        return transformed;
      }
    }

    //print("TimedItemGroup.timeFraction... 6");
    transformed = transformedTime;
    //print("********** TimedItemGroup.timeFraction... done, transformed = ${transformed}");
    //print("********** TimedItemGroup.timeFraction... done, iterDur = ${iterDur}");
    //_clearTimeFractionContext();
    //print("********** TimedItemGroup.timeFraction... FRACTION = ${transformed / iterDur}");
    return (transformed == null) ? null : transformed / iterDur;
  }

  /*
  _clearTimeFractionContext() {
    _timeFractionContext = false;
    _activeDuration = null;
    _activeTime = null;
    _localTime = null;
  }
  */

  /// Updates this group and all its children for the specified [timeFraction].
  ///
  /// If the [context] is a Boolean value it is interpreted as a "direct" update
  /// from its own [Player].  If a [TimedItemGroup] has its own Player and the update
  /// is not direct, it will be ignored.
  ///
  void update(num timeFraction, {dynamic context: false, bool finish: false}) {

    // print("timed item group update ${timeFraction}");

    // If this TimedItemGroup has its own player then ignore indirect updates from other players
    bool direct = context != null && context is bool ? context : false;
    if (player != null && !direct) return;

    super.update(timeFraction, finish: finish);
  }

  /*
  void _prepareForAnimation() {
    //print("Timed item group preparing for animation");
    if(this is DynamicNode) this._prepareForAnimation();
    children.where((EnvyNode child) => child is DynamicNode).forEach((child) {
      //print("timed item group preparing child dynamic node for animation");
        (child as DynamicNode)._prepareForAnimation();
    });
  }
  */

  void _finishAnimation({dynamic context: false}) {
    //TODO exits etc
    //print("!!!!!!!!!!!!!!!!!!! ${this} FINISHING ANIMATION !!!!!!!!!!!!!!!!!!!!!!");
    update(1.0, context: context, finish: true);

    if (player != null) player._deregisterTimedItemGroup(this);
  }
}
