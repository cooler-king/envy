import '../../../util/enumeration.dart';

/// Type of endings on the end of lines. Possible values: butt (default), round,
/// and square.
class LineCap2d extends Enumeration<String> {
  /// Constructs a constant instance.
  const LineCap2d(String value) : super(value);

  /// A butt line cap.
  static const LineCap2d butt = LineCap2d('butt');

  /// A round line cap.
  static const LineCap2d round = LineCap2d('round');

  /// A square line cap.
  static const LineCap2d square = LineCap2d('square');
}
