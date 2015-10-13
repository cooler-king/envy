part of envy;

/// All CSS properties can have 'initial' or 'inherit' values.
///
abstract class CssProperty implements CssAdapter {
  bool initial = false;
  bool inherit = false;

  String get css {
    if (inherit) return 'inherit';
    if (initial) return 'initial';
    return "";
  }

  EnvyInterpolator get interpolator;
}

class CssString extends CssProperty {
  EnvyInterpolator get interpolator => new BinaryInterpolator();
}

class CssNumber extends CssProperty {
  num value;

  CssNumber([this.value]);

  String get css {
    if (value != null) return "${value}";
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

  EnvyInterpolator get interpolator => new CssNumberInterpolator();
}

class CssLength extends CssProperty {
  final CssLengthUnits units;
  final num value;

  CssLength(this.value, this.units);

  CssLength.px(this.value) : units = CssLengthUnits.px;
  CssLength.pixels(this.value) : units = CssLengthUnits.px;
  CssLength.percent(this.value) : units = CssLengthUnits.pct;
  CssLength.cm(this.value) : units = CssLengthUnits.cm;
  CssLength.em(this.value) : units = CssLengthUnits.em;
  CssLength.ex(this.value) : units = CssLengthUnits.ex;
  CssLength.inches(this.value) : units = CssLengthUnits.inch;
  CssLength.mm(this.value) : units = CssLengthUnits.mm;
  CssLength.pt(this.value) : units = CssLengthUnits.pt;
  CssLength.pc(this.value) : units = CssLengthUnits.pc;
  CssLength.rem(this.value) : units = CssLengthUnits.rem;
  CssLength.vh(this.value) : units = CssLengthUnits.vh;
  CssLength.vw(this.value) : units = CssLengthUnits.vw;
  CssLength.vmax(this.value) : units = CssLengthUnits.vmax;
  CssLength.vmin(this.value) : units = CssLengthUnits.vmin;

  String get css {
    if (value != null) return "${value}${units?.value ?? 'px'}";
    return super.css;
  }

  EnvyInterpolator get interpolator => new CssLengthInterpolator();

  CssLength get inPixels {
    if (units == CssLengthUnits.px) return this;
    return new CssLength(CssUtil.toPixels(null, css), CssLengthUnits.px);
  }
}

class CssOpacity extends CssNumber {
  // num
}

class CssTransform extends CssProperty {
  EnvyInterpolator get interpolator => new CssTransformInterpolator();
}
