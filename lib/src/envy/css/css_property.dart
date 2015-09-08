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

  CssLength.px(this.value) : units = CssLengthUnits.PX;
  CssLength.pixels(this.value) : units = CssLengthUnits.PX;
  CssLength.percent(this.value) : units = CssLengthUnits.PCT;
  CssLength.cm(this.value) : units = CssLengthUnits.CM;
  CssLength.em(this.value) : units = CssLengthUnits.EM;
  CssLength.ex(this.value) : units = CssLengthUnits.EX;
  CssLength.inches(this.value) : units = CssLengthUnits.IN;
  CssLength.mm(this.value) : units = CssLengthUnits.MM;
  CssLength.pt(this.value) : units = CssLengthUnits.PT;
  CssLength.pc(this.value) : units = CssLengthUnits.PC;
  CssLength.rem(this.value) : units = CssLengthUnits.REM;
  CssLength.vh(this.value) : units = CssLengthUnits.VH;
  CssLength.vw(this.value) : units = CssLengthUnits.VW;
  CssLength.vmax(this.value) : units = CssLengthUnits.VMAX;
  CssLength.vmin(this.value) : units = CssLengthUnits.VMIN;

  String get css {
    if (value != null) return "${value}${units != null ? units.value : 'px'}";
    return super.css;
  }

  EnvyInterpolator get interpolator => new CssLengthInterpolator();

  CssLength get inPixels {
    if (units == CssLengthUnits.PX) return this;
    return new CssLength(CssUtil.toPixels(null, css), CssLengthUnits.PX);
  }
}

class CssOpacity extends CssNumber {
  // num
}

class CssTransform extends CssProperty {
  EnvyInterpolator get interpolator => new CssTransformInterpolator();
}
