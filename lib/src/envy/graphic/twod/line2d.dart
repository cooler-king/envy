part of envy;

/// A 2-dimensional line to be drawn on an HTML canvas.
///
class Line2d extends Graphic2dNode {
  Line2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["x1"] = new NumberProperty();
    properties["y1"] = new NumberProperty();
    properties["x2"] = new NumberProperty();
    properties["y2"] = new NumberProperty();
  }

  NumberProperty get x1 => properties["x1"] as NumberProperty;
  NumberProperty get y1 => properties["y1"] as NumberProperty;
  NumberProperty get x2 => properties["x2"] as NumberProperty;
  NumberProperty get y2 => properties["y2"] as NumberProperty;

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x1, _y1, _x2, _y2;
    Anchor2d _anchor = anchor.valueAt(i);
    _x1 = x1.valueAt(i);
    _y1 = y1.valueAt(i);
    _x2 = x2.valueAt(i);
    _y2 = y2.valueAt(i);
    // fill doesn't apply?
    //bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Adjust based on anchor (default origin is x1, y1)
    if (_anchor != null) {
      num deltaX = _x2 - _x1;
      num deltaY = _y2 - _y1;

      List<num> adj =
          _anchor.calcAdjustments(Math.min(0, deltaY), Math.max(0, deltaX), Math.max(0, deltaY), Math.min(0, deltaX));
      _x1 += adj[0];
      _y1 += adj[1];
      _x2 += adj[0];
      _y2 += adj[1];
    }

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    p.moveTo(_x1, _y1);
    p.lineTo(_x2, _y2);
    if (_stroke) ctx.stroke(p);
  }
}
