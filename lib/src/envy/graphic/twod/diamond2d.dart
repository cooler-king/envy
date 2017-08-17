import 'dart:html' show CanvasRenderingContext2D, Path2D;
import 'anchor2d.dart';
import 'graphic2d_node.dart';
import '../../envy_property.dart';

/// A 2-dimensional diamond to be drawn on an HTML canvas.
///
class Diamond2d extends Graphic2dNode {
  Diamond2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["width"] = new NumberProperty();
    properties["height"] = new NumberProperty();
  }

  NumberProperty get width => properties["width"] as NumberProperty;
  NumberProperty get height => properties["height"] as NumberProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x, _y, _width, _height;
    Anchor2d _anchor;
    _width = width.valueAt(i);
    _height = height.valueAt(i);
    _anchor = anchor.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    num halfWidth = _width / 2;
    num halfHeight = _height / 2;

    // Adjust for anchor (default origin is the center)
    _x = 0;
    _y = 0;
    if (_anchor != null) {
      List<num> adj = _anchor.calcAdjustments(-halfHeight, halfWidth, halfHeight, -halfWidth);
      _x += adj[0];
      _y += adj[1];
    }

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    p.moveTo(_x, _y - halfHeight);
    p.lineTo(_x + _width, _y);
    p.lineTo(_x, _y + halfHeight);
    p.lineTo(_x - _width, _y);
    p.closePath();

    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);
  }
}
