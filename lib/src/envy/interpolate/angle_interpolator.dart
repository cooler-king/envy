part of envy;

/// Interpolates between two [Angle]s.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
///
class AngleInterpolator extends EnvyInterpolator<Angle> {
  static final AngleInterpolator instance = new AngleInterpolator._internal();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  factory AngleInterpolator() => instance;

  AngleInterpolator._internal();

  /// Returns a Angle value between [a] and [b] based on the time [fraction].
  ///
  /// if [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then
  ///
  Angle interpolate(Angle a, Angle b, num fraction) => (!clamped || (fraction > 0 && fraction < 1))
      ? new Angle(rad: a.mks.toDouble() + (b.mks.toDouble() - a.mks.toDouble()) * fraction)
      : ((fraction <= 0) ? a : b);
}
