part of envy;

/// Supported values: top, hanging, middle, alphabetic (default),
/// ideographic, or bottom
///
class TextBaseline2d extends Enumeration<String> {
  static const TextBaseline2d ALPHABETIC = const TextBaseline2d("alphabetic");
  static const TextBaseline2d TOP = const TextBaseline2d("top");
  static const TextBaseline2d HANGING = const TextBaseline2d("hanging");
  static const TextBaseline2d MIDDLE = const TextBaseline2d("middle");
  static const TextBaseline2d IDEOGREAPHIC = const TextBaseline2d("ideographic");
  static const TextBaseline2d BOTTOM = const TextBaseline2d("bottom");

  const TextBaseline2d(String value) : super(value);

  static TextBaseline2d from(dynamic d) {
    if (d is TextBaseline2d) return d;
    if (d is String) {
      String lc = d.trim().toLowerCase();
      if (lc == "alphabetic") return TextBaseline2d.ALPHABETIC;
      if (lc == "top") return TextBaseline2d.TOP;
      if (lc == "hanging") return TextBaseline2d.HANGING;
      if (lc == "middle") return TextBaseline2d.MIDDLE;
      if (lc == "ideographic") return TextBaseline2d.IDEOGREAPHIC;
      if (lc == "bottom") return TextBaseline2d.BOTTOM;
    }

    return TextBaseline2d.ALPHABETIC;
  }
}
