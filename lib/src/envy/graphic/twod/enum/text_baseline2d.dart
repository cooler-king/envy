import '../../../util/enumeration.dart';

/// Supported values: top, hanging, middle, alphabetic (default),
/// ideographic, or bottom.
class TextBaseline2d extends Enumeration<String> {
  /// Constructs a instance.
  const TextBaseline2d(String value) : super(value);

  /// Attempts to convert [d] into a TextBaseline2d object.
  /// Returns [alphabetic] if the value is not recognized.
  static TextBaseline2d from(dynamic d) {
    if (d is TextBaseline2d) return d;
    if (d is String) {
      final lc = d.trim().toLowerCase();
      if (lc == 'alphabetic') return TextBaseline2d.alphabetic;
      if (lc == 'top') return TextBaseline2d.top;
      if (lc == 'hanging') return TextBaseline2d.hanging;
      if (lc == 'middle') return TextBaseline2d.middle;
      if (lc == 'ideographic') return TextBaseline2d.ideographic;
      if (lc == 'bottom') return TextBaseline2d.bottom;
    }

    return TextBaseline2d.alphabetic;
  }

  /// Alphabetic text baseline.
  static const TextBaseline2d alphabetic = TextBaseline2d('alphabetic');

  /// Top text baseline.
  static const TextBaseline2d top = TextBaseline2d('top');

  /// Hanging text baseline.
  static const TextBaseline2d hanging = TextBaseline2d('hanging');

  /// Middle text baseline.
  static const TextBaseline2d middle = TextBaseline2d('middle');

  /// Ideographic text baseline.
  static const TextBaseline2d ideographic = TextBaseline2d('ideographic');

  /// Bottom text baseline.
  static const TextBaseline2d bottom = TextBaseline2d('bottom');
}
