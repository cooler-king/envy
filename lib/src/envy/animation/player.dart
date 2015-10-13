part of envy;

/// Players provide an elapsed time relative to a specific
/// time on a specific [Timeline].
///
class Player {
  /// A dynamic list of TimedItemGroups to update
  final List<TimedItemGroup> _registered = [];

  /// The timer that triggers updates to registered TimedItemGroups
  Timer timer;

  /// The timeline with which the player is associated
  Timeline timeline;

  /// Start time of this player on its associated timeline, in seconds
  final num startTime;

  /// The rate of play of a player can be controlled by setting its [_playbackRate].
  ///
  /// For example, setting a playback rate of 2 will cause the player's current time
  /// to increase at twice the rate of its timeline. Similarly, a playback rate of -1
  /// will cause the player's current time to decrease at the same rate as the time
  /// values from its timeline increase.
  ///
  /// Players have a playback rate that provides a scaling factor from the rate of
  /// change of the associated timeline's time values to the player's current time.
  ///
  /// Setting a player's playback rate to zero effectively pauses the player but
  /// without affecting the player's paused state.
  ///
  num _playbackRate = 1;

  bool _paused = false;
  num _pauseStartTime = 0;

  num _timeDrift = 0;

  /// Create a new Player bound to [timeline] with the specified
  /// [startTime], in seconds, on that timeline.
  ///
  Player(this.timeline, this.startTime) {
    //print("player construction startTime = ${startTime}");

    //TODO add delay for start time
    _initTimer();
  }

  /// The [currentTime] is the elapsed time, in seconds, of the player
  /// relative to the [startTime] on its associated [timeline].
  ///
  /// Time drifts due to pausing the player are taken into account.
  ///
  num get currentTime => timeline.started ? (timeline.currentTime - startTime) * _playbackRate - timeDrift : null;

  /// The effective current time is the non-null elapsed time of the player
  /// relative to the [startTime] on its associated [timeline].
  ///
  /// It differs from the [currentTime] in that it will be 0 rather
  /// than null if the timeline has not yet started.
  ///
  /// Time drifts due to pausing the player are taken into account.
  ///
  num get effectiveCurrentTime {
    num current = currentTime;
    return current ?? 0;
  }

  num get effectiveTimelineTime => timeline.effectiveTime;

  num get playbackRate => _playbackRate;

  /// Sets the playback rate.
  ///
  /// Changes to the playback rate also trigger a compensatory seek so that that the
  /// player's current time is unaffected by the change to the playback rate.
  ///
  void set playbackRate(num rate) {
    num prevTime = effectiveCurrentTime;
    _playbackRate = rate;
    seek(prevTime);
  }

  bool get paused => _paused;

  /// Pausing can be used to temporarily suspend a player. Like seeking, pausing
  /// effectively causes the current time of a player to be offset from its timeline
  /// by means of setting the time drift.
  ///
  /// Whether pausing before or after a player's start time the duration of the
  /// interval during which the player was paused is added to the player's time drift
  /// whilst the start time remains unaffected.
  ///
  void pause(bool tf) {
    if (tf == _paused) return;
    if (_paused) {
      _timeDrift = timeDrift;
    } else {
      _pauseStartTime = effectiveCurrentTime;
    }
    _paused = tf;
  }

  num get timeDrift {
    if (_paused) {
      return (effectiveTimelineTime - startTime) * playbackRate - _pauseStartTime;
    } else {
      return _timeDrift;
    }
  }

  /// Seeking is the process of updating a player's current time to a desired value.
  ///
  /// Changing the current playback position of a player can be used to rewind its
  /// source content to its start point, fast-forward to a point in the future, or to
  /// provide ad-hoc synchronization between timed items.
  ///
  /// However, in Web Animations, the start time of a player has special significance
  /// in determining the priority of animations (see section 4.2 Combining animations) and
  /// so we cannot simply adjust the start time. Instead, an additional offset is
  /// introduced called the time drift that further offsets a player's current time from
  /// its timeline.
  ///
  /// It is possible to seek a player even if its timeline is not started. Once the timeline
  /// begins, the player will begin playback from the seeked time.
  ///
  void seek(num seekTime) {
    if (_paused) {
      _pauseStartTime = seekTime;
    } else {
      _timeDrift = (effectiveTimelineTime - startTime) * _playbackRate - seekTime;
    }
  }

  void _registerTimedItemGroup(TimedItemGroup timedItemGroup) {
    if (!_registered.contains(timedItemGroup)) {
      _registered.add(timedItemGroup);
      if (timer != null) timedItemGroup._prepareForAnimation();
    }
  }

  /// Removes [timedItemGroup] from the list of those registered.
  ///
  /// If there are no more timedItemGroups registered after removal
  /// the [timer] will be cancelled (if not null).
  ///
  /// Returns true if the timedItemGroup was found and removed; false
  /// if it could not be found.
  ///
  bool _deregisterTimedItemGroup(TimedItemGroup timedItemGroup) {
    if (_registered.contains(timedItemGroup)) {
      _registered.remove(timedItemGroup);
      if (_registered.isEmpty && timer != null) {
        try {
          timer.cancel();
          timer = null;
        } catch (e) {
          _LOG.warning("Problem canceling timer:  ${e}");
        }
      }
      return true;
    }
    return false;
  }

  /// Run a timer at 15 millisecond intervals (just over 60 fps), optionally
  /// waiting [delayMillis] milliseconds before starting.
  ///
  void _initTimer([num delayMillis = null]) {
    if (delayMillis == null) {
      _prepareForAnimation();
      timer = new Timer.periodic(new Duration(milliseconds: 15), (Timer t) {
        _updateRegisteredGroups();
      });
    } else {
      // Wait before creating animation timer
      new Timer(new Duration(milliseconds: delayMillis), () {
        _prepareForAnimation();
        timer = new Timer.periodic(new Duration(milliseconds: 15), (Timer t) {
          _updateRegisteredGroups();
        });
      });
    }
  }

  void _prepareForAnimation() {
    _registered.forEach((TimedItemGroup tig) {
      tig._prepareForAnimation();
    });
  }

  void _updateRegisteredGroups() {
    for (TimedItemGroup group in _registered) {
      try {
        // Set the context to true to indicate a direct update
        group.update(group.timeFraction, context: true);
      } catch (e, s) {
        _LOG.severe("Problem updating registered timed item group: ${e}", e, s);
      }

      // Is this group finished animating? (deregisters group from player)
      if (effectiveCurrentTime >= group.endTime) {
        // Schedule the group to finish when the updating is complete
        Timer.run(() => group._finishAnimation(context: true));
      }
    }
  }
}
