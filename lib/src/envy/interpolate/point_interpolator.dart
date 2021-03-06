import 'dart:math';
import 'envy_interpolator.dart';

/// Interpolates between two 2-dimensional points.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
class PointInterpolator extends EnvyInterpolator<Point<num>> {
  /// This factory constructor returns the singleton instance.
  factory PointInterpolator() => instance;

  PointInterpolator._internal();

  /// The singleton instance.
  static final PointInterpolator instance = PointInterpolator._internal();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true.
  bool clamped = false;

  /// Returns a `Point` having x and y values between those of points [a] and [b]
  /// based on the time [fraction].
  /// If [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then a or b is returned as appropriate.
  @override
  Point<num> interpolate(Point<num> a, Point<num> b, num fraction) {
    num x, y;
    if (!clamped || (fraction >= 0 && fraction <= 1)) {
      x = a.x + (b.x - a.x) * fraction;
      y = a.y + (b.y - a.y) * fraction;
    } else {
      x = (fraction < 0) ? a.x : b.x;
      y = (fraction < 0) ? a.y : b.y;
    }

    return Point<num>(x, y);
  }
}
