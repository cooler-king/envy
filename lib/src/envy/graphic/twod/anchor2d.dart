import '../../util/logger.dart';
import 'enum/anchor_mode2d.dart';

/// An anchor specifies the origin of a shape through a combination
/// of a mode and optional offset.
///
/// Each shape has a default origin, but a non-default anchor can
/// override that setting.
class Anchor2d {
  /// Which point to use as a shape's origin for placement and rotation:
  /// default, center, or a particular side or corner
  AnchorMode2d mode;

  // Allow an arbitrary offset relative to the point indicated by the anchor mode
  num offsetX;
  num offsetY;

  Anchor2d({this.mode: AnchorMode2d.defaultMode, this.offsetX: 0, this.offsetY: 0});

  /// Calculates the adjustments that should be added to the vertices of
  /// a `graphic2d` object based on this anchor's current settings.
  ///
  /// The [top], [right], [bottom] and [left] values represent the nominal
  /// bounds of the `graphic2d` in the coordinate system of that object.
  List<num> calcAdjustments(num top, num right, num bottom, num left) {
    if (mode == AnchorMode2d.defaultMode) return <num>[offsetX, offsetY];
    if (mode == AnchorMode2d.center)
      return <num>[-(left + (right - left) / 2 + offsetX), -(top + (bottom - top) / 2 + offsetY)];

    if (mode == AnchorMode2d.top) return <num>[-(left + (right - left) / 2 + offsetX), -(top + offsetY)];
    if (mode == AnchorMode2d.right) return <num>[-(right + offsetX), -(top + (bottom - top) / 2 + offsetY)];
    if (mode == AnchorMode2d.bottom) return <num>[-(left + (right - left) / 2 + offsetX), -(bottom + offsetY)];
    if (mode == AnchorMode2d.left) return <num>[-(left + offsetX), -(top + (bottom - top) / 2 + offsetY)];

    if (mode == AnchorMode2d.topLeft) return <num>[-(left + offsetX), -(top + offsetY)];
    if (mode == AnchorMode2d.topRight) return <num>[-(right + offsetX), -(top + offsetY)];
    if (mode == AnchorMode2d.bottomLeft) return <num>[-(left + offsetX), -(bottom + offsetY)];
    if (mode == AnchorMode2d.bottomRight) return <num>[-(right + offsetX), -(bottom + offsetY)];

    logger.warning('Unexpected anchor mode detected: $mode');
    return <num>[0, 0];
  }

  bool get isDefault => mode == AnchorMode2d.defaultMode && offsetX == 0 && offsetY == 0;

  bool get isNotDefault => !isDefault;
}
