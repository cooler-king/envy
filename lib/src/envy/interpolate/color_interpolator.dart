import '../color/color.dart';
import 'envy_interpolator.dart';

/// Base class for various color interpolation techniques.
abstract class ColorInterpolator extends EnvyInterpolator<Color> {
  @override
  Color interpolate(Color a, Color b, num fraction);
}

/// The [RgbaInterpolator] linearly interpolates the red, green, blue and alpha values between the two colors
/// individually.
class RgbaInterpolator extends ColorInterpolator {
  @override
  Color interpolate(Color a, Color b, num fraction) => Color.rgba(a.r + (b.r - a.r) * fraction,
      a.g + (b.g - a.g) * fraction, a.b + (b.b - a.b) * fraction, a.alpha + (b.alpha - a.alpha) * fraction);
}

/// The [RgbInterpolator] linearly interpolates the red, green and blue values between the two colors
/// individually.
///
/// Slightly more efficient to use than RgbaInterpolator when the alpha value is known to be constant.
class RgbInterpolator extends ColorInterpolator {
  @override
  Color interpolate(Color a, Color b, num fraction) =>
      Color.rgb(a.r + (b.r - a.r) * fraction, a.g + (b.g - a.g) * fraction, a.b + (b.b - a.b) * fraction);
}
