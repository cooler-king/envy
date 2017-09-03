import 'binary_interpolator.dart';
import 'envy_interpolator.dart';
import '../text/font.dart';

class FontInterpolator extends EnvyInterpolator<Font> {
  EnvyInterpolator styleInterpolator;
  EnvyInterpolator variantInterpolator;
  EnvyInterpolator weightInterpolator;
  EnvyInterpolator sizeInterpolator;
  EnvyInterpolator familyInterpolator;
  BinaryInterpolator<dynamic> _binaryInterpolator = new BinaryInterpolator<dynamic>();

  FontInterpolator({this.styleInterpolator, this.variantInterpolator, this.weightInterpolator, this.sizeInterpolator,
      this.familyInterpolator}) {
    if (styleInterpolator == null) styleInterpolator = _binaryInterpolator;
    if (variantInterpolator == null) variantInterpolator = _binaryInterpolator;
    if (weightInterpolator == null) weightInterpolator = _binaryInterpolator;
    if (sizeInterpolator == null) sizeInterpolator = _binaryInterpolator;
    if (familyInterpolator == null) familyInterpolator = _binaryInterpolator;
  }

  /// Returns a [Font] having values between those of Fonts [a] and [b]
  /// based on the time [fraction].
  ///
  Font interpolate(Font a, Font b, num fraction) {
    Font f = new Font();

    f.style = _interpolateProperty(a.style, b.style, fraction, styleInterpolator) as FontStyle;
    f.variant = _interpolateProperty(a.variant, b.variant, fraction, variantInterpolator) as FontVariant;
    f.weight = _interpolateProperty(a.weight, b.weight, fraction, weightInterpolator) as FontWeight;
    f.size = _interpolateProperty(a.size, b.size, fraction, sizeInterpolator) as FontSize;
    f.family = _interpolateProperty(a.family, b.family, fraction, familyInterpolator) as FontFamily;
    return f;
  }

  dynamic _interpolateProperty(dynamic a, dynamic b, num fraction, EnvyInterpolator interp) {
    if (a != null) {
      if (b != null) {
        return interp.interpolate(a, b, fraction);
      } else {
        return a;
      }
    } else {
      if (b != null) {
        return b;
      } else {
        return null;
      }
    }
  }
}
