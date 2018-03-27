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
  Color interpolate(Color c1, Color c2, num fraction) => new Color.rgba(c1.r + (c2.r - c1.r) * fraction,
      c1.g + (c2.g - c1.g) * fraction, c1.b + (c2.b - c1.b) * fraction, c1.alpha + (c2.alpha - c1.alpha) * fraction);
}

/// The [RgbInterpolator] linearly interpolates the red, green and blue values between the two colors
/// individually.
///
/// Slightly more efficient to use than RgbaInterpolator when the alpha value is know to be constant.
class RgbInterpolator extends ColorInterpolator {
  @override
  Color interpolate(Color c1, Color c2, num fraction) =>
      new Color.rgb(c1.r + (c2.r - c1.r) * fraction, c1.g + (c2.g - c1.g) * fraction, c1.b + (c2.b - c1.b) * fraction);
}
