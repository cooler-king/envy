import 'package:quantity/quantity.dart' show Angle;
import 'envy_interpolator.dart';

/// Interpolates between two [Angle]s.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
class AngleInterpolator extends EnvyInterpolator<Angle> {
  /// This factory constructor return the singleton instance.
  factory AngleInterpolator() => instance;

  AngleInterpolator._internal();

  /// The singleton instance.
  static final AngleInterpolator instance = AngleInterpolator._internal();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  /// Returns a Angle value between [a] and [b] based on the time [fraction].
  ///
  /// if [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then
  ///
  @override
  Angle interpolate(Angle a, Angle b, num fraction) => (!clamped || (fraction > 0 && fraction < 1))
      ? Angle(rad: a.mks.toDouble() + (b.mks.toDouble() - a.mks.toDouble()) * fraction)
      : ((fraction <= 0) ? a : b);
}
