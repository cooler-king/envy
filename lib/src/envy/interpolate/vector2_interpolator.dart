import 'package:vector_math/vector_math.dart' show Vector2;
import 'envy_interpolator.dart';

/// Interpolates between two 2-dimensional vectors.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
///
class Vector2Interpolator extends EnvyInterpolator<Vector2> {
  static final Vector2Interpolator instance = new Vector2Interpolator._internal();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  factory Vector2Interpolator() => instance;

  Vector2Interpolator._internal();

  /// Returns a [Vector2] having x and y values between those of Vector2s [a] and [b]
  /// based on the time [fraction].
  ///
  /// if [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then
  ///
  @override
  Vector2 interpolate(Vector2 a, Vector2 b, num fraction) {
    num x, y;
    if (!clamped || (fraction >= 0 && fraction <= 1)) {
      x = a.x + (b.x - a.x) * fraction;
      y = a.y + (b.y - a.y) * fraction;
    } else {
      x = ((fraction < 0) ? a.x : b.x);
      y = ((fraction < 0) ? a.y : b.y);
    }

    return new Vector2(x.toDouble(), y.toDouble());
  }
}
