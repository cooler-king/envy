import '../../../util/enumeration.dart';

/// An enumeration of predefined two-dimensional graphic anchor possibilities.
class AnchorMode2d extends Enumeration<String> {
  /// Constructs a constance instance.
  const AnchorMode2d(String value) : super(value);

  /// Default, as interpreted by a particular graphic.
  static const AnchorMode2d defaultMode = AnchorMode2d('default');

  /// The center of the graphic.
  static const AnchorMode2d center = AnchorMode2d('center');

  /// The top of the graphic's bounding box.
  static const AnchorMode2d top = AnchorMode2d('top');

  /// The rightmost extent of the graphic's bounding box.
  static const AnchorMode2d right = AnchorMode2d('right');

  /// The bottom of the graphic's bounding box.
  static const AnchorMode2d bottom = AnchorMode2d('bottom');

  /// The leftmost extent of the graphic's bounding box.
  static const AnchorMode2d left = AnchorMode2d('left');

  /// The top left corner of the graphic's bounding box.
  static const AnchorMode2d topLeft = AnchorMode2d('topleft');

  /// The top right corner of the graphic's bounding box.
  static const AnchorMode2d topRight = AnchorMode2d('topright');

  /// The bottom left corner of the graphic's bounding box.
  static const AnchorMode2d bottomLeft = AnchorMode2d('bottomleft');

  /// The bottom right corner of the graphic's bounding box.
  static const AnchorMode2d bottomRight = AnchorMode2d('bottomright');

  /// Attempts to convert [d] into an AnchorMode2d, returning the [defaultMode]
  /// if it is unable to interpret the value.
  static AnchorMode2d from(dynamic d) {
    if (d is AnchorMode2d) return d;
    if (d is String) {
      final lc = d.toLowerCase();
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
