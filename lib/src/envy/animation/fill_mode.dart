import '../util/enumeration.dart';

class FillMode extends Enumeration<String> {
  const FillMode(String value) : super(value);

  static const FillMode none = const FillMode('none');
  static const FillMode forwards = const FillMode('forwards');
  static const FillMode backwards = const FillMode('backwards');
  static const FillMode both = const FillMode('both');
}
