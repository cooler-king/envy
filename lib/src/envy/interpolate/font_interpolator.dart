import '../text/font.dart';
import 'binary_interpolator.dart';
import 'envy_interpolator.dart';

class FontInterpolator extends EnvyInterpolator<Font> {
  FontInterpolator(
      {this.styleInterpolator,
      this.variantInterpolator,
      this.weightInterpolator,
      this.sizeInterpolator,
      this.familyInterpolator}) {
    styleInterpolator ??= _binaryInterpolator;
    variantInterpolator ??= _binaryInterpolator;
    weightInterpolator ??= _binaryInterpolator;
    sizeInterpolator ??= _binaryInterpolator;
    familyInterpolator ??= _binaryInterpolator;
  }

  EnvyInterpolator<dynamic> styleInterpolator;
  EnvyInterpolator<dynamic> variantInterpolator;
  EnvyInterpolator<dynamic> weightInterpolator;
  EnvyInterpolator<dynamic> sizeInterpolator;
  EnvyInterpolator<dynamic> familyInterpolator;
  final BinaryInterpolator<dynamic> _binaryInterpolator = new BinaryInterpolator<dynamic>();

  /// Returns a [Font] having values between those of Fonts [a] and [b]
  /// based on the time [fraction].
  @override
  Font interpolate(Font a, Font b, num fraction) {
    final Font f = new Font()
      ..style = _interpolateProperty(a.style, b.style, fraction, styleInterpolator) as FontStyle
      ..variant = _interpolateProperty(a.variant, b.variant, fraction, variantInterpolator) as FontVariant
      ..weight = _interpolateProperty(a.weight, b.weight, fraction, weightInterpolator) as FontWeight
      ..size = _interpolateProperty(a.size, b.size, fraction, sizeInterpolator) as FontSize
      ..family = _interpolateProperty(a.family, b.family, fraction, familyInterpolator) as FontFamily;
    return f;
  }

  dynamic _interpolateProperty(dynamic a, dynamic b, num fraction, EnvyInterpolator<dynamic> interp) {
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
