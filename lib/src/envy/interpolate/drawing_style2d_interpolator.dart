import '../color/color.dart';
import '../graphic/twod/drawing_style2d.dart';
import '../graphic/twod/gradient2d.dart';
import '../graphic/twod/pattern2d.dart';
import 'binary_interpolator.dart';
import 'color_interpolator.dart';
import 'envy_interpolator.dart';
import 'gradient2d_interpolator.dart';

/// Interpolates between two drawing styles.
class DrawingStyle2dInterpolator extends EnvyInterpolator<DrawingStyle2d> {
  /// Constructs a new instance.
  DrawingStyle2dInterpolator({this.colorInterpolator, this.gradient2dInterpolator, this.pattern2dInterpolator}) {
    colorInterpolator ??= new RgbaInterpolator();
    gradient2dInterpolator ??= new Gradient2dInterpolator();
    pattern2dInterpolator ??= new BinaryInterpolator<Pattern2d>();
  }

  /// The color interpolator.
  EnvyInterpolator<Color> colorInterpolator;

  /// The gradient interpolator.
  EnvyInterpolator<Gradient2d> gradient2dInterpolator;

  /// the pattern interpolator.
  EnvyInterpolator<Pattern2d> pattern2dInterpolator;

  final BinaryInterpolator<DrawingStyle2d> _binaryInterpolator = new BinaryInterpolator<DrawingStyle2d>();

  /// Returns a [DrawingStyle2d] having values between those of DrawingStyle2ds [a] and [b]
  /// based on the time [fraction].
  @override
  DrawingStyle2d interpolate(DrawingStyle2d a, DrawingStyle2d b, num fraction) {
    if (identical(a, b)) return a;
    // Get the pattern, gradient or color in the style (first non-null, in that order)
    final dynamic obj1 = a.styleObj;
    final dynamic obj2 = b.styleObj;

    // Handle interpolation between same type (color, gradient or pattern)
    if (obj1 is Color && obj2 is Color) {
      if (identical(obj1, obj2) || obj1.matches(obj2)) return a;
      return new DrawingStyle2d(color: colorInterpolator.interpolate(obj1, obj2, fraction));
    }
    if (obj1 is Gradient2d && obj2 is Gradient2d) {
      if (identical(obj1, obj2)) return a;
      return new DrawingStyle2d(gradient: gradient2dInterpolator.interpolate(obj1, obj2, fraction));
    }
    if (obj1 is Pattern2d && obj2 is Pattern2d) {
      if (identical(obj1, obj2)) return a;
      return new DrawingStyle2d(pattern: pattern2dInterpolator.interpolate(obj1, obj2, fraction));
    }

    //TODO more elegant?  blend as images?
    return _binaryInterpolator.interpolate(a, b, fraction);
  }
}
