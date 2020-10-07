import '../../util/enumeration.dart';

/// Enumerates the length units used in CSS.
class CssLengthUnits extends Enumeration<String> {
  /// Constructs a instance.
  const CssLengthUnits(String value) : super(value);

  /// Pixels.
  static const CssLengthUnits px = const CssLengthUnits('px');

  /// Percentage.
  static const CssLengthUnits pct = const CssLengthUnits('%');

  /// Inches.
  static const CssLengthUnits inch = const CssLengthUnits('in');

  /// Centimeters.
  static const CssLengthUnits cm = const CssLengthUnits('cm');

  /// Millimeters.
  static const CssLengthUnits mm = const CssLengthUnits('mm');

  /// Ems.
  static const CssLengthUnits em = const CssLengthUnits('em');

  /// Rems.
  static const CssLengthUnits rem = const CssLengthUnits('rem');

  /// Exes.
  static const CssLengthUnits ex = const CssLengthUnits('ex');

  /// Points.
  static const CssLengthUnits pt = const CssLengthUnits('pt');

  /// Picas.
  static const CssLengthUnits pc = const CssLengthUnits('pc');

  /// Viewport width fraction.
  static const CssLengthUnits vw = const CssLengthUnits('vw');

  /// Viewport height fraction.
  static const CssLengthUnits vh = const CssLengthUnits('vh');

  /// Fraction of the smallest viewport side.
  static const CssLengthUnits vmin = const CssLengthUnits('vmin');

  /// Fraction of the largest viewport side.
  static const CssLengthUnits vmax = const CssLengthUnits('vmax');
}
