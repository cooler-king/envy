part of envy;

/// A 2-dimensional cross to be drawn on an HTML canvas.
///
/// The cross consists of a vertical bar and a horizontal bar that
/// can be positioned anywhere along the vertical bar (0 percent
/// means the horizontal bar's center is located at the top
/// of the vertical bar).
///
class Cross2d extends Graphic2dNode {
  Cross2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["verticalWidth"] = new NumberProperty();
    properties["verticalHeight"] = new NumberProperty();
    properties["horizontalWidth"] = new NumberProperty();
    properties["horizontalHeight"] = new NumberProperty();
    properties["percent"] = new NumberProperty();
  }

  NumberProperty get verticalWidth => properties["verticalWidth"] as NumberProperty;
  NumberProperty get verticalHeight => properties["verticalHeight"] as NumberProperty;
  NumberProperty get horizontalWidth => properties["horizontalWidth"] as NumberProperty;
  NumberProperty get horizontalHeight => properties["horizontalHeight"] as NumberProperty;
  NumberProperty get percent => properties["percent"] as NumberProperty;

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x, _y, _verticalWidth, _verticalHeight, _horizontalWidth, _horizontalHeight, _percent;
    Anchor2d _anchor;
    _verticalWidth = verticalWidth.valueAt(i);
    _verticalHeight = verticalHeight.valueAt(i);
    _horizontalWidth = horizontalWidth.valueAt(i);
    _horizontalHeight = horizontalHeight.valueAt(i);
    _percent = percent.valueAt(i);
    _anchor = anchor.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    num halfVerticalWidth = _verticalWidth / 2;

    num width = Math.max(_verticalWidth, _horizontalWidth);
    num height = _verticalHeight;

    num halfWidth = width / 2;
    num halfHeight = height / 2;

    num minY = -halfHeight;
    num maxY = halfHeight;
    num hbarY = (_percent - 50) * 0.01 * height;
    num hbarTop = hbarY - (_horizontalHeight / 2);
    num hbarBottom = hbarY + (_horizontalHeight / 2);
    bool outTop = false;
    bool outBottom = false;
    if (hbarTop < minY) {
      minY = hbarTop;
      outTop = true;
    } else if (hbarBottom > maxY) {
      maxY = hbarBottom;
      outBottom = true;
    }

    // Adjust for anchor (default origin is the center of the vertical element)
    _x = 0;
    _y = 0;
    if (anchor != null) {
      List<num> adj = _anchor.calcAdjustments(minY, halfWidth, maxY, -halfWidth);
      _x += adj[0];
      _y += adj[1];
    }

    Path2D p = new Path2D();
    //ctx.beginPath();
    paths.add(p);

    // Start at top left
    if (outTop) {
      p.moveTo(_x - Math.max(halfWidth, halfVerticalWidth), _y + hbarTop);
      p.lineTo(_x + Math.max(halfWidth, halfVerticalWidth), _y + hbarTop);
      p.lineTo(_x + Math.max(halfWidth, halfVerticalWidth), _y + hbarBottom);
      p.lineTo(_x + halfVerticalWidth, _y + hbarBottom);
      p.lineTo(_x + halfVerticalWidth, _y + halfVerticalWidth);
      p.lineTo(_x - halfVerticalWidth, _y + halfVerticalWidth);
      p.lineTo(_x - halfVerticalWidth, _y + hbarBottom);
      p.lineTo(_x - Math.max(halfWidth, halfVerticalWidth), _y + hbarBottom);
    } else if (outBottom) {
      p.moveTo(_x - halfVerticalWidth, _y - halfHeight);
      p.lineTo(_x + halfVerticalWidth, _y - halfHeight);
      p.lineTo(_x + halfVerticalWidth, _y + hbarTop);
      p.lineTo(_x + Math.max(halfWidth, halfVerticalWidth), _y + hbarTop);
      p.lineTo(_x + Math.max(halfWidth, halfVerticalWidth), _y + hbarBottom);
      p.lineTo(_x - Math.max(halfWidth, halfVerticalWidth), _y + hbarBottom);
      p.lineTo(_x - Math.max(halfWidth, halfVerticalWidth), _y + hbarTop);
      p.lineTo(_x - halfVerticalWidth, _y + hbarTop);
    } else {
      p.moveTo(_x - halfVerticalWidth, _y - halfHeight);
      p.lineTo(_x + halfVerticalWidth, _y - halfHeight);
      p.lineTo(_x + halfVerticalWidth, _y + hbarTop);
      p.lineTo(_x + Math.max(halfWidth, halfVerticalWidth), _y + hbarTop);
      p.lineTo(_x + Math.max(halfWidth, halfVerticalWidth), _y + hbarBottom);
      p.lineTo(_x + halfVerticalWidth, _y + hbarBottom);
      p.lineTo(_x + halfVerticalWidth, _y + halfHeight);
      p.lineTo(_x - halfVerticalWidth, _y + halfHeight);
      p.lineTo(_x - halfVerticalWidth, _y + hbarBottom);
      p.lineTo(_x - Math.max(halfWidth, halfVerticalWidth), _y + hbarBottom);
      p.lineTo(_x - Math.max(halfWidth, halfVerticalWidth), _y + hbarTop);
      p.lineTo(_x - halfVerticalWidth, _y + hbarTop);
    }

    p.closePath();

    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);
  }
}
