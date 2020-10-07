import 'dart:html';
import '../../envy_property.dart';
import 'graphic2d_node.dart';

/// A point to be drawn on an HTML canvas.
class Point2d extends Graphic2dNode {
  /// Constructs a instance, optionally specifying the marker to draw.
  Point2d([this.marker]) : super(null) {
    _initProperties();
  }

  /// The marker to draw at the point.
  Graphic2dNode marker;

  void _initProperties() {
    properties['pixelSize'] = NumberProperty();
  }

  /// The pixel size of the point.
  NumberProperty get pixelSize => properties['pixelSize'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y;
    final _anchor = anchor.valueAt(index);
    final _pixelSize = pixelSize.valueAt(index);
    _y = y.valueAt(index);
    final _fill = fill.valueAt(index);
    final _stroke = stroke.valueAt(index);

    _x = 0;
    _y = 0;
    if (anchor != null) {
      // Adjust based on anchor (default origin is x, y).
      final num halfSize = _pixelSize / 2;
      final adj = _anchor?.calcAdjustments(halfSize, halfSize, -halfSize, -halfSize) ?? <num>[0, 0];
      _x += adj[0];
      _y += adj[1];
    }

    //TODO pixelSize, markers not implemented yet

    // Draw marker or point
    if (marker != null) {
      //TODO markers?
    } else {
      // default to filling a single pixel
      if (_fill) ctx.fillRect(_x, _y, 1, 1);
      if (_stroke) ctx.strokeRect(_x, _y, 1, 1);
    }
  }
}
