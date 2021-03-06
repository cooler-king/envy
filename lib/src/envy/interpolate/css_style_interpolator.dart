import '../css/css_property.dart';
import '../css/css_style.dart';
import '../css/enum/css_length_units.dart';
import '../util/css_util.dart';
import 'envy_interpolator.dart';
import 'number_interpolator.dart';

/// Interpolates between two [CssStyle]s.
class CssStyleInterpolator extends EnvyInterpolator<CssStyle> {
  final CssStyle _style = CssStyle();

  @override
  CssStyle interpolate(CssStyle a, CssStyle b, num fraction) {
    _style.clear();

    // Interpolate each property in the CssStyle (which is a Map).
    CssProperty aValue, bValue, iValue;
    final bOnlyProps = List<String>.from(b.keys);
    bool bHas;
    for (final prop in a.keys) {
      bHas = bOnlyProps.remove(prop);

      aValue = a[prop];
      bValue = bHas ? b[prop] : CssStyle.defaultValueForProp(prop);
      iValue = aValue.interpolator.interpolate(aValue, bValue, fraction);

      _style[prop] = iValue;
    }

    // Do the b-only props.
    for (final prop in bOnlyProps) {
      aValue = CssStyle.defaultValueForProp(prop);
      iValue = aValue.interpolator.interpolate(aValue, b[prop], fraction);

      _style[prop] = iValue;
    }

    return _style;
  }
}

/// Interpolates between CSS numbers.
class CssNumberInterpolator extends EnvyInterpolator<CssNumber> {
  final NumberInterpolator _numberInterpolator = NumberInterpolator();

  @override
  CssNumber interpolate(CssNumber a, CssNumber b, num fraction) =>
      CssNumber(_numberInterpolator.interpolate(a.value, b.value, fraction));
}

/// Interpolates between CSS lengths.
class CssLengthInterpolator extends EnvyInterpolator<CssLength> {
  final NumberInterpolator _numberInterpolator = NumberInterpolator();

  @override
  CssLength interpolate(CssLength a, CssLength b, num fraction) {
    if (a.units == b.units) {
      return CssLength(_numberInterpolator.interpolate(a.value, b.value, fraction), a.units);
    } else {
      // Convert both to pixels.
      final aPixels = CssUtil.toPixels(null, a.css);
      final bPixels = CssUtil.toPixels(null, b.css);
      return CssLength(_numberInterpolator.interpolate(aPixels, bPixels, fraction), CssLengthUnits.px);
    }
  }
}

/// Interpolates between CSS transforms.
class CssTransformInterpolator extends EnvyInterpolator<CssTransform> {
  @override
  CssTransform interpolate(CssTransform a, CssTransform b, num fraction) {
    //TODO
    if (fraction < 0.5) {
      return a;
    } else {
      return b;
    }
  }
}
