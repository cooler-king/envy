import '../../../util/enumeration.dart';

/// Defines the type of corners where two lines meet. Possible values: round,
/// bevel, and miter (default).
///
class LineJoin2d extends Enumeration<String> {
  const LineJoin2d(String value) : super(value);

  static const LineJoin2d miter = const LineJoin2d('miter');
  static const LineJoin2d round = const LineJoin2d('round');
  static const LineJoin2d bevel = const LineJoin2d('bevel');
}
