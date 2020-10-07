import 'envy_interpolator.dart';

/// Interpolates between two numbers.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
class NumberInterpolator extends EnvyInterpolator<num> {
  /// This factory constructor returns the singleton instance.
  factory NumberInterpolator() => instance;

  NumberInterpolator._internal();

  /// The singleton instance.
  static final NumberInterpolator instance = NumberInterpolator._internal();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  /// Returns a numerical value between [a] and [b] based on the time [fraction].
  /// If [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then the appropriate endpoint value will be returned.
  @override
  num interpolate(num a, num b, num fraction) =>
      (!clamped || (fraction >= 0 && fraction <= 1)) ? a + (b - a) * fraction : ((fraction < 0) ? a : b);
}
