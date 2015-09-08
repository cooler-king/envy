part of envy;

class PlaybackDirection {

  /// All iterations are played as specified
  static final String normal = "normal";

  /// All iterations are played in the reverse direction from the way they are specified
  static final String reverse = "reverse";

  /// Even iterations are played as specified, odd iterations are played in the reverse
  /// direction from the way they are specified.
  ///
  static final String alternate = "alternate";

  /// Even iterations are played in the reverse direction from the way they are specified,
  /// odd iterations are played as specified.
  ///
  static final String alternate_reverse = "alternate-reverse";
}
