import 'enum/anchor_mode2d.dart';
import '../../util/logger.dart';

/// An anchor specifies the origin of a shape through a combination
/// of a mode and optional offset.
///
/// Each shape has a default origin, but a non-default anchor can
/// override that setting.
///
class Anchor2d {
  /// Which point to use as a shape's origin for placement and rotation:
  /// default, center, or a particular side or corner
  AnchorMode2d mode;

  // Allow an arbitrary offset relative to the point indicated by the anchor mode
  num offsetX;
  num offsetY;

  Anchor2d({this.mode: AnchorMode2d.DEFAULT, this.offsetX: 0, this.offsetY: 0});

  /// Calculates the adjustments that should be added to the vertices of
  /// a [graphic2d] object based on this anchor's current settings.
  ///
  /// The [top], [right], [bottom] and [left] values represent the nominal
  /// bounds of the [graphic2d] in the coordinate system of that object.
  ///
  List<num> calcAdjustments(num top, num right, num bottom, num left) {
    if (mode == AnchorMode2d.DEFAULT) return [offsetX, offsetY];
    if (mode == AnchorMode2d.CENTER) return [
      -(left + (right - left) / 2 + offsetX),
      -(top + (bottom - top) / 2 + offsetY)
    ];

    if (mode == AnchorMode2d.TOP) return [-(left + (right - left) / 2 + offsetX), -(top + offsetY)];
    if (mode == AnchorMode2d.RIGHT) return [-(right + offsetX), -(top + (bottom - top) / 2 + offsetY)];
    if (mode == AnchorMode2d.BOTTOM) return [-(left + (right - left) / 2 + offsetX), -(bottom + offsetY)];
    if (mode == AnchorMode2d.LEFT) return [-(left + offsetX), -(top + (bottom - top) / 2 + offsetY)];

    if (mode == AnchorMode2d.TOP_LEFT) return [-(left + offsetX), -(top + offsetY)];
    if (mode == AnchorMode2d.TOP_RIGHT) return [-(right + offsetX), -(top + offsetY)];
    if (mode == AnchorMode2d.BOTTOM_LEFT) return [-(left + offsetX), -(bottom + offsetY)];
    if (mode == AnchorMode2d.BOTTOM_RIGHT) return [-(right + offsetX), -(bottom + offsetY)];

    logger.warning("Unexpected anchor mode detected: ${mode}");
    return [0, 0];
  }

  bool get isDefault => mode == AnchorMode2d.DEFAULT && offsetX == 0 && offsetY == 0;

  bool get isNotDefault => !isDefault;
}
