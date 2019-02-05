import '../../../util/enumeration.dart';

/// With globalAlpha applied this sets how shapes and images are drawn onto the existing bitmap.
///
/// Possible values: source-atop, source-in, source-out, source-over (default), destination-atop, destination-in
/// destination-out, destination-over, lighter and xor.
class CompositeOperation2d extends Enumeration<String> {
  const CompositeOperation2d(String value) : super(value);

  static const CompositeOperation2d sourceOver = const CompositeOperation2d('source-over');
  static const CompositeOperation2d sourceAtop = const CompositeOperation2d('source-atop');
  static const CompositeOperation2d sourceIn = const CompositeOperation2d('source-in');
  static const CompositeOperation2d sourceOut = const CompositeOperation2d('source-out');
  static const CompositeOperation2d destinationAtop = const CompositeOperation2d('destination-atop');
  static const CompositeOperation2d destinationIn = const CompositeOperation2d('destination-in');
  static const CompositeOperation2d destinationOut = const CompositeOperation2d('destination-out');
  static const CompositeOperation2d destinationOver = const CompositeOperation2d('destination-over');
  static const CompositeOperation2d lighter = const CompositeOperation2d('lighter');
  static const CompositeOperation2d xor = const CompositeOperation2d('xor');
}
