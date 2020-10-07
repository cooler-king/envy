import '../util/enumeration.dart';

/// Animation fill mode.
class FillMode extends Enumeration<String> {
  /// Constructs a instance.
  const FillMode(String value) : super(value);

  /// Not filled.
  static const FillMode none = FillMode('none');

  /// Forwards fill mode.
  static const FillMode forwards = FillMode('forwards');

  /// Backwards fill mode.
  static const FillMode backwards = FillMode('backwards');

  /// Both forwards and backwards fill mode.
  static const FillMode both = FillMode('both');
}
