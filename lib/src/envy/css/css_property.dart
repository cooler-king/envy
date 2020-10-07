import '../interpolate/binary_interpolator.dart';
import '../interpolate/css_style_interpolator.dart';
import '../interpolate/envy_interpolator.dart';
import '../util/css_util.dart';
import 'css_adapter.dart';
import 'enum/css_length_units.dart';

/// The base abstract class for CSS-related properties.
/// All CSS properties can have 'initial' or 'inherit' values.
abstract class CssProperty implements CssAdapter {
  /// Whether to use the initial value.
  bool initial = false;

  /// Whether to use the inherited value.
  bool inherit = false;

  @override
  String get css {
    if (inherit) return 'inherit';
    if (initial) return 'initial';
    return '';
  }

  /// Implementing classes must provide an interpolator.
  EnvyInterpolator<CssProperty> get interpolator;
}

/// Holds a CSS string value.
class CssString extends CssProperty {
  @override
  EnvyInterpolator<CssString> get interpolator => BinaryInterpolator<CssString>();
}

/// Holds a CSS numerical value.
class CssNumber extends CssProperty {
  /// Constructs a instance.
  CssNumber([this.value]);

  /// The numerical value.
  num value;

  @override
  String get css {
    if (value != null) return '$value';
    return super.css;
  }

  /*
  void applyCss(String css) {
    if(css == null) return;
    var sheet = parse(css);
    if(sheet is CssStyleSheet) {
      sheet.cssRules.first.
    }
  }*/

  @override
  EnvyInterpolator<CssNumber> get interpolator => CssNumberInterpolator();
}

/// Holds a CSS length value.
class CssLength extends CssProperty {
  /// Constructs a instance from a value and units.
  CssLength(this.value, this.units);

  /// Constructs a length in pixels.
  CssLength.px(this.value) : units = CssLengthUnits.px;

  /// Constructs a length in pixels (synonym for px).
  CssLength.pixels(this.value) : units = CssLengthUnits.px;

  /// Constructs a length in percent.
  CssLength.percent(this.value) : units = CssLengthUnits.pct;

  /// Constructs a length in centimeters.
  CssLength.cm(this.value) : units = CssLengthUnits.cm;

  /// Constructs a length in ems.
  CssLength.em(this.value) : units = CssLengthUnits.em;

  /// Constructs a length in exes.
  CssLength.ex(this.value) : units = CssLengthUnits.ex;

  /// Constructs a length in inched.
  CssLength.inches(this.value) : units = CssLengthUnits.inch;

  /// Constructs a length in millimeters.
  CssLength.mm(this.value) : units = CssLengthUnits.mm;

  /// Constructs a length in points.
  CssLength.pt(this.value) : units = CssLengthUnits.pt;

  /// Constructs a length in picas.
  CssLength.pc(this.value) : units = CssLengthUnits.pc;

  /// Constructs a length in rems.
  CssLength.rem(this.value) : units = CssLengthUnits.rem;

  /// Constructs a length in viewport horizontal percent.
  CssLength.vh(this.value) : units = CssLengthUnits.vh;

  /// Constructs a length in viewport vertical percent.
  CssLength.vw(this.value) : units = CssLengthUnits.vw;

  /// Constructs a length in percentage of the viewport's maximum side.
  CssLength.vmax(this.value) : units = CssLengthUnits.vmax;

  /// Constructs a length in percentage of the viewport's minimum side.
  CssLength.vmin(this.value) : units = CssLengthUnits.vmin;

  /// The numerical value.
  final num value;

  /// The units of the [value].
  final CssLengthUnits units;

  @override
  String get css {
    if (value != null) return '$value${units?.value ?? 'px'}';
    return super.css;
  }

  @override
  EnvyInterpolator<CssLength> get interpolator => CssLengthInterpolator();

  /// Returns the length in pixels.
  CssLength get inPixels {
    if (units == CssLengthUnits.px) return this;
    return CssLength(CssUtil.toPixels(null, css), CssLengthUnits.px);
  }
}

/// Holds CSS opacity.
class CssOpacity extends CssNumber {
  // num
}

/// Holds a CSS transform.
class CssTransform extends CssProperty {
  @override
  EnvyInterpolator<CssTransform> get interpolator => CssTransformInterpolator();
}
