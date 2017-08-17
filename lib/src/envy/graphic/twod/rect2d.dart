import 'dart:html';
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional rectangle to be drawn on an HTML canvas.
///
/// The default anchor is the top left corner.
///
class Rect2d extends Graphic2dNode {
  Rect2d() : super(null) {
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
    //_apply2dContext(i, ctx);
    _width = width.valueAt(i);
    _height = height.valueAt(i);
    _anchor = anchor.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    //print("x, y, width, height... ${_x}, ${_y}, ${_width}, ${_height}");

    // Adjust for anchor (default origin is upper left)
    List<num> adj = _anchor?.calcAdjustments(0, _width, _height, 0) ?? [0, 0];
    _x = adj[0];
    _y = adj[1];

    Path2D p = new Path2D();
    paths.add(p);
    p.rect(_x, _y, _width, _height);

    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);
  }
}
