part of envy;

/// Interpolates between two [Pattern2d]s.
///
/// Singleton.
///
class Pattern2dInterpolator extends EnvyInterpolator<Pattern2d> {
  static final Pattern2dInterpolator instance = new Pattern2dInterpolator._internal();

  BinaryInterpolator _binaryInterpolator = new BinaryInterpolator();

  factory Pattern2dInterpolator() => instance;

  Pattern2dInterpolator._internal();

  /// Returns a Pattern2d value between [a] and [b] based on the time [fraction].
  ///
  /// if [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then
  ///
  Pattern2d interpolate(Pattern2d a, Pattern2d b, num fraction) {
    //TODO blend images instead?
    return _binaryInterpolator.interpolate(a, b, fraction);
  }
}
