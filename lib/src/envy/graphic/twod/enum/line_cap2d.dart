import '../../../util/enumeration.dart';

/// Type of endings on the end of lines. Possible values: butt (default), round,
/// and square.
///
class LineCap2d extends Enumeration<String> {
  static const LineCap2d BUTT = const LineCap2d("butt");
  static const LineCap2d ROUND = const LineCap2d("round");
  static const LineCap2d SQUARE = const LineCap2d("square");

  const LineCap2d(String value) : super(value);
}
