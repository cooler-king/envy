import '../../../util/enumeration.dart';

/// Defines the type of corners where two lines meet. Possible values: round,
/// bevel, and miter (default).
class LineJoin2d extends Enumeration<String> {
  /// Constructs a constant instance.
  const LineJoin2d(String value) : super(value);

  /// A miter line join.
  static const LineJoin2d miter = LineJoin2d('miter');

  /// A round line join.
  static const LineJoin2d round = LineJoin2d('round');

  /// A bevel line join.
  static const LineJoin2d bevel = LineJoin2d('bevel');
}
