import '../../../util/enumeration.dart';

class AnchorMode2d extends Enumeration<String> {
  static const AnchorMode2d DEFAULT = const AnchorMode2d("default");
  static const AnchorMode2d CENTER = const AnchorMode2d("center");
  static const AnchorMode2d TOP = const AnchorMode2d("top");
  static const AnchorMode2d RIGHT = const AnchorMode2d("right");
  static const AnchorMode2d BOTTOM = const AnchorMode2d("bottom");
  static const AnchorMode2d LEFT = const AnchorMode2d("left");
  static const AnchorMode2d TOP_LEFT = const AnchorMode2d("topleft");
  static const AnchorMode2d TOP_RIGHT = const AnchorMode2d("topright");
  static const AnchorMode2d BOTTOM_LEFT = const AnchorMode2d("bottomleft");
  static const AnchorMode2d BOTTOM_RIGHT = const AnchorMode2d("bottomright");

  const AnchorMode2d(String value) : super(value);

  static from(dynamic d) {
    if (d is AnchorMode2d) return d;
    if (d is String) {
      String lc = d.toLowerCase();
      if (lc == "center") return AnchorMode2d.CENTER;

      if (lc.contains("top")) {
        if (lc.contains("left")) {
          return AnchorMode2d.TOP_LEFT;
        } else if (lc.contains("right")) {
          return AnchorMode2d.TOP_RIGHT;
        } else {
          return AnchorMode2d.TOP;
        }
      } else if (lc.contains("bottom")) {
        if (lc.contains("left")) {
          return AnchorMode2d.BOTTOM_LEFT;
        } else if (lc.contains("right")) {
          return AnchorMode2d.BOTTOM_RIGHT;
        } else {
          return AnchorMode2d.BOTTOM;
        }
      } else if (lc.contains("left")) {
        return AnchorMode2d.LEFT;
      } else if (lc.contains("right")) {
        return AnchorMode2d.RIGHT;
      }
    }

    return AnchorMode2d.DEFAULT;
  }
}
