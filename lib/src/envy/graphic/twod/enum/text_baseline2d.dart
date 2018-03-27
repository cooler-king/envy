import '../../../util/enumeration.dart';

/// Supported values: top, hanging, middle, alphabetic (default),
/// ideographic, or bottom
///
class TextBaseline2d extends Enumeration<String> {
  static const TextBaseline2d alphabetic = const TextBaseline2d('alphabetic');
  static const TextBaseline2d top = const TextBaseline2d('top');
  static const TextBaseline2d hanging = const TextBaseline2d('hanging');
  static const TextBaseline2d middle = const TextBaseline2d('middle');
  static const TextBaseline2d ideographic = const TextBaseline2d('ideographic');
  static const TextBaseline2d bottom = const TextBaseline2d('bottom');

  const TextBaseline2d(String value) : super(value);

  static TextBaseline2d from(dynamic d) {
    if (d is TextBaseline2d) return d;
    if (d is String) {
      final String lc = d.trim().toLowerCase();
      if (lc == 'alphabetic') return TextBaseline2d.alphabetic;
      if (lc == 'top') return TextBaseline2d.top;
      if (lc == 'hanging') return TextBaseline2d.hanging;
      if (lc == 'middle') return TextBaseline2d.middle;
      if (lc == 'ideographic') return TextBaseline2d.ideographic;
      if (lc == 'bottom') return TextBaseline2d.bottom;
    }

    return TextBaseline2d.alphabetic;
  }
}
