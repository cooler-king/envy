part of envy;

/// Supported values: start (default), end, left, right or center.
///
/// Note that these values are not the same as the supported CSS text-align values.
///
class TextAlign2d extends Enumeration<String> {
  static const TextAlign2d START = const TextAlign2d("start");
  static const TextAlign2d END = const TextAlign2d("end");
  static const TextAlign2d LEFT = const TextAlign2d("left");
  static const TextAlign2d RIGHT = const TextAlign2d("right");
  static const TextAlign2d CENTER = const TextAlign2d("center");

  const TextAlign2d(String value) : super(value);

  static TextAlign2d from(dynamic d) {
    if (d is TextAlign2d) return d;
    if (d is String) {
      String lc = d.trim().toLowerCase();
      if (lc == "left") return TextAlign2d.LEFT;
      if (lc == "right") return TextAlign2d.RIGHT;
      if (lc == "center") return TextAlign2d.CENTER;
      if (lc == "start") return TextAlign2d.START;
      if (lc == "end") return TextAlign2d.END;
    }

    return TextAlign2d.START;
  }
}
