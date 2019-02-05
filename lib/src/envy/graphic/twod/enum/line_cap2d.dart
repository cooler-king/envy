import '../../../util/enumeration.dart';

/// Type of endings on the end of lines. Possible values: butt (default), round,
/// and square.
///
class LineCap2d extends Enumeration<String> {
  const LineCap2d(String value) : super(value);

  static const LineCap2d butt = const LineCap2d('butt');
  static const LineCap2d round = const LineCap2d('round');
  static const LineCap2d square = const LineCap2d('square');
}
