import '../../util/enumeration.dart';

/// Enumerates the length units used in CSS.
class CssLengthUnits extends Enumeration<String> {
  /// Constructs a instance.
  const CssLengthUnits(String value) : super(value);

  /// Pixels.
  static const CssLengthUnits px = CssLengthUnits('px');

  /// Percentage.
  static const CssLengthUnits pct = CssLengthUnits('%');

  /// Inches.
  static const CssLengthUnits inch = CssLengthUnits('in');

  /// Centimeters.
  static const CssLengthUnits cm = CssLengthUnits('cm');

  /// Millimeters.
  static const CssLengthUnits mm = CssLengthUnits('mm');

  /// Ems.
  static const CssLengthUnits em = CssLengthUnits('em');

  /// Rems.
  static const CssLengthUnits rem = CssLengthUnits('rem');

  /// Exes.
  static const CssLengthUnits ex = CssLengthUnits('ex');

  /// Points.
  static const CssLengthUnits pt = CssLengthUnits('pt');

  /// Picas.
  static const CssLengthUnits pc = CssLengthUnits('pc');

  /// Viewport width fraction.
  static const CssLengthUnits vw = CssLengthUnits('vw');

  /// Viewport height fraction.
  static const CssLengthUnits vh = CssLengthUnits('vh');

  /// Fraction of the smallest viewport side.
  static const CssLengthUnits vmin = CssLengthUnits('vmin');

  /// Fraction of the largest viewport side.
  static const CssLengthUnits vmax = CssLengthUnits('vmax');
}
