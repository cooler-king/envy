part of envy;

/// A 2-dimensional triangle to be drawn on an HTML canvas.
///
/// The triangle is defined by an origin, a base length, a height and a rotation angle
/// (0 degrees is straight up, clockwise).  The default anchor point is the center of the base.
///
class Triangle2d extends Graphic2dNode {

  // Degrees
  final num offsetAngle;

  Triangle2d()
      : offsetAngle = 0,
        super(null) {
    _initProperties();
  }

  Triangle2d.up()
      : offsetAngle = 0,
        super(null) {
    _initProperties();
  }

  Triangle2d.right()
      : offsetAngle = 90,
        super(null) {
    _initProperties();
  }

  Triangle2d.left()
      : offsetAngle = -90,
        super(null) {
    _initProperties();
  }

  Triangle2d.down()
      : offsetAngle = 180,
        super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["base"] = new NumberProperty();
    properties["height"] = new NumberProperty();
    //properties["angle"] = new NumberProperty();
  }

  NumberProperty get x => properties["x"] as NumberProperty;
  NumberProperty get y => properties["y"] as NumberProperty;
  NumberProperty get base => properties["base"] as NumberProperty;
  NumberProperty get height => properties["height"] as NumberProperty;
  //NumberProperty get angle => properties["angle"] as NumberProperty;

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x, _y, _base, _height;
    _base = base.valueAt(i);
    _height = height.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    num halfBase = _base / 2.0;
    num effectiveAngleRad = offsetAngle * Math.PI / 180.0;

    // Adjust for anchor (default is center of base)
    Anchor2d _anchor = anchor.valueAt(i);
    _x = 0;
    _y = 0;
    if (_anchor != null) {
      List<num> adj = _anchor.calcAdjustments(-_height, halfBase, 0, -halfBase);
      _x += adj[0];
      _y += adj[1];
    }

    // Rotate for angle ( plus any angle offset)
    ctx.rotate(effectiveAngleRad);

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    p.moveTo(_x - halfBase, _y);
    p.lineTo(_x, _y - _height);
    p.lineTo(_x + halfBase, _y);
    p.closePath();
    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);

    // Reverse angle rotation
    ctx.rotate(-effectiveAngleRad);
  }
}

/**
 * A 2-dimensional triangle to be drawn on an HTML canvas.
 */
//TODO POlygon?
class TriangleVertices2d extends Graphic2dNode {
  TriangleVertices2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["x1"] = new NumberProperty();
    properties["y1"] = new NumberProperty();
    properties["x2"] = new NumberProperty();
    properties["y2"] = new NumberProperty();
    properties["x3"] = new NumberProperty();
    properties["y3"] = new NumberProperty();
  }

  NumberProperty get x1 => properties["x1"] as NumberProperty;
  NumberProperty get y1 => properties["y1"] as NumberProperty;
  NumberProperty get x2 => properties["x2"] as NumberProperty;
  NumberProperty get y2 => properties["y2"] as NumberProperty;
  NumberProperty get x3 => properties["x3"] as NumberProperty;
  NumberProperty get y3 => properties["y3"] as NumberProperty;

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x1, _y1, _x2, _y2, _x3, _y3;
    _x1 = x1.valueAt(i);
    _y1 = y1.valueAt(i);
    _x2 = x2.valueAt(i);
    _y2 = y2.valueAt(i);
    _x3 = x3.valueAt(i);
    _y3 = y3.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    p.moveTo(_x1, _y1);
    p.lineTo(_x2, _y2);
    p.lineTo(_x3, _y3);
    p.closePath();
    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);
  }
}
