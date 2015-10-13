part of envy;

/// A 2-dimensional line to be drawn on an HTML canvas.
///
class Point2d extends Graphic2dNode {
  Graphic2dNode marker;

  Point2d([this.marker]) : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["pixelSize"] = new NumberProperty();
  }

  NumberProperty get pixelSize => properties["pixelSize"] as NumberProperty;

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x, _y, _pixelSize;
    Anchor2d _anchor = anchor.valueAt(i);
    _pixelSize = pixelSize.valueAt(i);
    _y = y.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Adjust based on anchor (default origin is x, y)
    _x = 0;
    _y = 0;
    List<num> adj = _anchor?.calcAdjustments(0, 0, 0, 0) ?? [0, 0];

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
