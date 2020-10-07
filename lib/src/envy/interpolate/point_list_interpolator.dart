import 'dart:math';
import '../graphic/twod/point_list.dart';
import 'envy_interpolator.dart';
import 'point_interpolator.dart';

/// A constant point at zero, zero.
const Point<num> ptZeroZero = Point<num>(0, 0);

/// Interpolates between a two lists containing points.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
class PointListInterpolator extends EnvyInterpolator<PointList> {
  /// This factory constructor returns the singleton instance.
  factory PointListInterpolator() => instance;

  PointListInterpolator._internal();

  /// The singleton instance.
  static final PointListInterpolator instance = PointListInterpolator._internal();

  // Internal interpolator for individual points
  static final PointInterpolator _pointInterp = PointInterpolator();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  /// Interpolates each individual point based on the time [fraction].
  /// For lists that grow in length, additional points are added one at a time, equally
  /// spaced over the animation duration.
  /// If [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then a or b is returned as appropriate.
  @override
  PointList interpolate(PointList a, PointList b, num fraction) {
    final int numPoints = a.length == b.length ? b.length : (a.length + ((b.length - a.length) * fraction).ceil());
    final PointList newPoints = PointList();
    for (int i = 0; i < numPoints; i++) {
      newPoints
          .add(_pointInterp.interpolate(i < a.length ? a[i] : ptZeroZero, i < b.length ? b[i] : ptZeroZero, fraction));
    }

    return newPoints;
  }
}
