import '../text/font.dart';
import 'binary_interpolator.dart';
import 'envy_interpolator.dart';

/// Interpolation between two fonts.
class FontInterpolator extends EnvyInterpolator<Font> {
  /// Constructs a instance, with all component interpolators
  /// defaulting to binary.
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

  /// Interpolates between two font styles.
  EnvyInterpolator<dynamic>? styleInterpolator;

  /// Interpolates between two font variants.
  EnvyInterpolator<dynamic>? variantInterpolator;

  /// Interpolates between two font weights.
  EnvyInterpolator<dynamic>? weightInterpolator;

  /// Interpolates between two font sizes.
  EnvyInterpolator<dynamic>? sizeInterpolator;

  /// Interpolates between two font families.
  EnvyInterpolator<dynamic>? familyInterpolator;

  final BinaryInterpolator<dynamic> _binaryInterpolator = BinaryInterpolator.middle;

  /// Returns a [Font] having values between those of Fonts [a] and [b]
  /// based on the time [fraction].
  @override
  Font interpolate(Font a, Font b, num fraction) {
    final f = Font()
      ..style = _interpolateProperty(a.style, b.style, fraction, styleInterpolator!) as FontStyle
      ..variant = _interpolateProperty(a.variant, b.variant, fraction, variantInterpolator!) as FontVariant
      ..weight = _interpolateProperty(a.weight, b.weight, fraction, weightInterpolator!) as FontWeight
      ..size = _interpolateProperty(a.size, b.size, fraction, sizeInterpolator!) as FontSize
      ..family = _interpolateProperty(a.family, b.family, fraction, familyInterpolator!) as FontFamily;
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
