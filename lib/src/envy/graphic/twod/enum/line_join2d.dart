part of envy;

/// Defines the type of corners where two lines meet. Possible values: round,
/// bevel, and miter (default).
///
class LineJoin2d extends Enumeration<String> {
  static const LineJoin2d MITER = const LineJoin2d("miter");
  static const LineJoin2d ROUND = const LineJoin2d("round");
  static const LineJoin2d BEVEL = const LineJoin2d("bevel");

  const LineJoin2d(String value) : super(value);
}
