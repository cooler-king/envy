/// The direction of the time playback.
class PlaybackDirection {
  /// All iterations are played as specified
  static const String normal = 'normal';

  /// All iterations are played in the reverse direction from the way they are specified
  static const String reverse = 'reverse';

  /// Even iterations are played as specified, odd iterations are played in the reverse
  /// direction from the way they are specified.
  static const String alternate = 'alternate';

  /// Even iterations are played in the reverse direction from the way they are specified,
  /// odd iterations are played as specified.
  static const String alternateReverse = 'alternate-reverse';
}
