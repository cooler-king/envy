import '../../../util/enumeration.dart';

/// With globalAlpha applied this sets how shapes and images are drawn onto the existing bitmap.
///
/// Possible values: source-atop, source-in, source-out, source-over (default), destination-atop, destination-in
/// destination-out, destination-over, lighter and xor.
class CompositeOperation2d extends Enumeration<String> {
  /// Constructs a constant value.
  const CompositeOperation2d(String value) : super(value);

  /// Composite operation source-over.
  static const CompositeOperation2d sourceOver = CompositeOperation2d('source-over');

  /// Composite operation source-atop.
  static const CompositeOperation2d sourceAtop = CompositeOperation2d('source-atop');

  /// Composite operation source-in.
  static const CompositeOperation2d sourceIn = CompositeOperation2d('source-in');

  /// Composite operation source-out.
  static const CompositeOperation2d sourceOut = CompositeOperation2d('source-out');

  /// Composite operation destination-atop.
  static const CompositeOperation2d destinationAtop = CompositeOperation2d('destination-atop');

  /// Composite operation destination-in.
  static const CompositeOperation2d destinationIn = CompositeOperation2d('destination-in');

  /// Composite operation destination-out.
  static const CompositeOperation2d destinationOut = CompositeOperation2d('destination-out');

  /// Composite operation destination-over.
  static const CompositeOperation2d destinationOver = CompositeOperation2d('destination-over');

  /// Composite operation lighter.
  static const CompositeOperation2d lighter = CompositeOperation2d('lighter');

  /// Composite operation xor.
  static const CompositeOperation2d xor = CompositeOperation2d('xor');
}
