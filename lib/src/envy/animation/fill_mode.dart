import '../util/enumeration.dart';

/// Animation fill mode.
class FillMode extends Enumeration<String> {
  /// Constructs a new instance.
  const FillMode(String value) : super(value);

  /// Not filled.
  static const FillMode none = const FillMode('none');

  /// Forwards fill mode.
  static const FillMode forwards = const FillMode('forwards');

  /// Backwards fill mode.
  static const FillMode backwards = const FillMode('backwards');

  /// Both forwards and backwards fill mode.
  static const FillMode both = const FillMode('both');
}
