import '../color/color.dart';
import '../graphic/twod/gradient2d.dart';
import 'binary_interpolator.dart';
import 'color_interpolator.dart';
import 'envy_interpolator.dart';
import 'number_interpolator.dart';

/// Interpolates between two [Gradient2d]s.
class Gradient2dInterpolator extends EnvyInterpolator<Gradient2d> {
  /// Constructs a new instance.
  Gradient2dInterpolator({ColorInterpolator colorInterpolator}) {
    _colorInterpolator = colorInterpolator ?? (new RgbaInterpolator());
  }

  final NumberInterpolator _numberInterpolator = new NumberInterpolator();
  ColorInterpolator _colorInterpolator = new RgbaInterpolator();

  /// Returns a Gradient2d value between [a] and [b] based on the time [fraction].
  @override
  Gradient2d interpolate(Gradient2d a, Gradient2d b, num fraction) {
    Gradient2d gradient;

    if (a is LinearGradient2d && b is LinearGradient2d) {
      final num x0 = _numberInterpolator.interpolate(a.x0, b.x0, fraction);
      final num y0 = _numberInterpolator.interpolate(a.y0, b.y0, fraction);
      final num x1 = _numberInterpolator.interpolate(a.x1, b.x1, fraction);
      final num y1 = _numberInterpolator.interpolate(a.y1, b.y1, fraction);
      gradient = new LinearGradient2d(x0: x0, y0: y0, x1: x1, y1: y1);
    } else if (a is RadialGradient2d && b is RadialGradient2d) {
      // Radial gradients are defined with two imaginary circles - a starting circle and an
      // ending circle, in which the gradient starts with the start circle and moves towards
      // the end circle.
      final num x0 = _numberInterpolator.interpolate(a.x0, b.x0, fraction);
      final num y0 = _numberInterpolator.interpolate(a.y0, b.y0, fraction);
      final num r0 = _numberInterpolator.interpolate(a.r0, b.r0, fraction);
      final num x1 = _numberInterpolator.interpolate(a.x1, b.x1, fraction);
      final num y1 = _numberInterpolator.interpolate(a.y1, b.y1, fraction);
      final num r1 = _numberInterpolator.interpolate(a.r1, b.r1, fraction);
      gradient = new RadialGradient2d(x0: x0, y0: y0, r0: r0, x1: x1, y1: y1, r1: r1);
    } else {
      // Linear to radial, radial to linear -- just use binary interpolator
      //TODO something more elegant for these?
      //TODO this will change input gradients -- BUG
      gradient = new BinaryInterpolator<Gradient2d>().interpolate(a, b, fraction);
    }

    // Consolidate the number, fractional value and Color of each stop
    final List<num> aStops = new List<num>.from(a.stops.keys)..sort();
    final List<num> bStops = new List<num>.from(b.stops.keys)..sort();
    final int numStops = _numberInterpolator.interpolate(aStops.length, bStops.length, fraction).round();

    // Interpolate stop values and colors
    num stopA, stopB, stop;
    Color colorA, colorB, color;
    for (int i = 0; i < numStops; i++) {
      stopA = i < aStops.length ? aStops[i] : 1.0;
      stopB = i < bStops.length ? bStops[i] : 1.0;
      stop = _numberInterpolator.interpolate(stopA, stopB, fraction);

      colorA = i < aStops.length ? a.stops[stopA] : aStops.isNotEmpty ? a.stops[aStops.last] : Color.black;
      colorB = i < bStops.length ? b.stops[stopB] : bStops.isNotEmpty ? b.stops[bStops.last] : Color.black;

      color = _colorInterpolator.interpolate(colorA, colorB, fraction);

      gradient.addColorStop(stop, color);
    }

    return gradient;
  }
}
