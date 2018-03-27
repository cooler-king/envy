import '../../../util/enumeration.dart';

class AnchorMode2d extends Enumeration<String> {
  static const AnchorMode2d defaultMode = const AnchorMode2d('default');
  static const AnchorMode2d center = const AnchorMode2d('center');
  static const AnchorMode2d top = const AnchorMode2d('top');
  static const AnchorMode2d right = const AnchorMode2d('right');
  static const AnchorMode2d bottom = const AnchorMode2d('bottom');
  static const AnchorMode2d left = const AnchorMode2d('left');
  static const AnchorMode2d topLeft = const AnchorMode2d('topleft');
  static const AnchorMode2d topRight = const AnchorMode2d('topright');
  static const AnchorMode2d bottomLeft = const AnchorMode2d('bottomleft');
  static const AnchorMode2d bottomRight = const AnchorMode2d('bottomright');

  const AnchorMode2d(String value) : super(value);

  static AnchorMode2d from(dynamic d) {
    if (d is AnchorMode2d) return d;
    if (d is String) {
      final String lc = d.toLowerCase();
      if (lc == 'center') return AnchorMode2d.center;

      if (lc.contains('top')) {
        if (lc.contains('left')) {
          return AnchorMode2d.topLeft;
        } else if (lc.contains('right')) {
          return AnchorMode2d.topRight;
        } else {
          return AnchorMode2d.top;
        }
      } else if (lc.contains('bottom')) {
        if (lc.contains('left')) {
          return AnchorMode2d.bottomLeft;
        } else if (lc.contains('right')) {
          return AnchorMode2d.bottomRight;
        } else {
          return AnchorMode2d.bottom;
        }
      } else if (lc.contains('left')) {
        return AnchorMode2d.left;
      } else if (lc.contains('right')) {
        return AnchorMode2d.right;
      }
    }

    return AnchorMode2d.defaultMode;
  }
}
