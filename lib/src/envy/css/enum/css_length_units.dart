part of envy;

class CssLengthUnits extends Enumeration<String> {
  static const CssLengthUnits PX = const CssLengthUnits("px");
  static const CssLengthUnits PCT = const CssLengthUnits("%");
  static const CssLengthUnits IN = const CssLengthUnits("in");
  static const CssLengthUnits CM = const CssLengthUnits("cm");
  static const CssLengthUnits MM = const CssLengthUnits("mm");
  static const CssLengthUnits EM = const CssLengthUnits("em");
  static const CssLengthUnits REM = const CssLengthUnits("rem");
  static const CssLengthUnits EX = const CssLengthUnits("ex");
  static const CssLengthUnits PT = const CssLengthUnits("pt");
  static const CssLengthUnits PC = const CssLengthUnits("pc");
  static const CssLengthUnits VW = const CssLengthUnits("vw");
  static const CssLengthUnits VH = const CssLengthUnits("vh");
  static const CssLengthUnits VMIN = const CssLengthUnits("vmin");
  static const CssLengthUnits VMAX = const CssLengthUnits("vmax");

  const CssLengthUnits(String value) : super(value);
}
