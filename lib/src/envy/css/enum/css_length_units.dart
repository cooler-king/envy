import '../../util/enumeration.dart';

class CssLengthUnits extends Enumeration<String> {
  static const CssLengthUnits px = const CssLengthUnits('px');
  static const CssLengthUnits pct = const CssLengthUnits('%');
  static const CssLengthUnits inch = const CssLengthUnits('in');
  static const CssLengthUnits cm = const CssLengthUnits('cm');
  static const CssLengthUnits mm = const CssLengthUnits('mm');
  static const CssLengthUnits em = const CssLengthUnits('em');
  static const CssLengthUnits rem = const CssLengthUnits('rem');
  static const CssLengthUnits ex = const CssLengthUnits('ex');
  static const CssLengthUnits pt = const CssLengthUnits('pt');
  static const CssLengthUnits pc = const CssLengthUnits('pc');
  static const CssLengthUnits vw = const CssLengthUnits('vw');
  static const CssLengthUnits vh = const CssLengthUnits('vh');
  static const CssLengthUnits vmin = const CssLengthUnits('vmin');
  static const CssLengthUnits vmax = const CssLengthUnits('vmax');

  const CssLengthUnits(String value) : super(value);
}
