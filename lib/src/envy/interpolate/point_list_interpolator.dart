import 'dart:math';
import 'envy_interpolator.dart';
import 'point_interpolator.dart';
import '../graphic/twod/point_list.dart';

const Point ptZeroZero = const Point<num>(0, 0);

/// Interpolates between a two lists containing points.
///
/// By default, time fractions outside the normal range (0-1) may return values outside the
/// range of values provided to the interpolate method.  To limit the returned values to the
/// provided range, set [clamped] to true.
///
/// Singleton.
///
class PointListInterpolator extends EnvyInterpolator<PointList> {
  static final PointListInterpolator instance = new PointListInterpolator._internal();

  // Internal interpolator for individual points
  static final PointInterpolator _pointInterp = new PointInterpolator();

  /// To restrict the minimum and maximum values for overflow fractions, set [clamped] to true
  bool clamped = false;

  factory PointListInterpolator() => instance;

  PointListInterpolator._internal();

  /// Interpolates each individual point based on the time [fraction].
  ///
  /// For lists that grow in length, additional points are added one at a time, equally
  /// spaced over the animation duration.
  ///
  /// if [clamped] is true and the [fraction] is outside the normal range (0-1, inclusive)
  /// then
  ///
  PointList interpolate(PointList a, PointList b, num fraction) {
    int numPoints = a.length == b.length ? b.length : (a.length + ((b.length - a.length) * fraction).ceil());
    PointList newPoints = new PointList();
    for (int i = 0; i < numPoints; i++) {
      newPoints
          .add(_pointInterp.interpolate(i < a.length ? a[i] : ptZeroZero, i < b.length ? b[i] : ptZeroZero, fraction));
    }

    return newPoints;
  }
}
