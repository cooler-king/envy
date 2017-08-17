import '../../../util/enumeration.dart';

/// With globalAlpha applied this sets how shapes and images are drawn onto the existing bitmap.
///
/// Possible values: source-atop, source-in, source-out, source-over (default), destination-atop, destination-in
/// destination-out, destination-over, lighter and xor.
///
class CompositeOperation2d extends Enumeration<String> {
  static const CompositeOperation2d SOURCE_OVER = const CompositeOperation2d("source-over");
  static const CompositeOperation2d SOURCE_ATOP = const CompositeOperation2d("source-atop");
  static const CompositeOperation2d SOURCE_IN = const CompositeOperation2d("source-in");
  static const CompositeOperation2d SOURCE_OUT = const CompositeOperation2d("source-out");
  static const CompositeOperation2d DESTINATION_ATOP = const CompositeOperation2d("destination-atop");
  static const CompositeOperation2d DESTINATION_IN = const CompositeOperation2d("destination-in");
  static const CompositeOperation2d DESTINATION_OUT = const CompositeOperation2d("destination-out");
  static const CompositeOperation2d DESTINATION_OVER = const CompositeOperation2d("destination-over");
  static const CompositeOperation2d LIGHTER = const CompositeOperation2d("lighter");
  static const CompositeOperation2d XOR = const CompositeOperation2d("xor");

  const CompositeOperation2d(String value) : super(value);
}
