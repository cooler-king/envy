import 'envy_interpolator.dart';
import '../color/color.dart';

/// Base class for various color interpolation techniques.
///
abstract class ColorInterpolator extends EnvyInterpolator<Color> {
  Color interpolate(Color a, Color b, num fraction);
}

/// The [RgbaInterpolator] linearly interpolates the red, green, blue and alpha values betyween the two colors
/// individually.
///
class RgbaInterpolator extends ColorInterpolator {
  Color interpolate(Color a, Color b, num fraction) {
    return new Color.rgba(a.red + (b.red - a.red) * fraction, a.green + (b.green - a.green) * fraction,
        a.blue + (b.blue - a.blue) * fraction, a.alpha + (b.alpha - a.alpha) * fraction);
  }
}

/// The [RgbInterpolator] linearly interpolates the red, green and blue values betyween the two colors
/// individually.
///
/// Slightly more efficient to use than RgbaInterpolator when the alpha value is know to be constant.
///
class RgbInterpolator extends ColorInterpolator {
  Color interpolate(Color a, Color b, num fraction) {
    return new Color.rgb(a.red + (b.red - a.red) * fraction, a.green + (b.green - a.green) * fraction,
        a.blue + (b.blue - a.blue) * fraction);
  }
}
