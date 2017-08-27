import 'dart:html' show CanvasRenderingContext2D, Path2D;
import 'anchor2d.dart';
import 'graphic2d_node.dart';
import '../../envy_property.dart';

/// A 2-dimensional bar (rectangle) to be drawn on an HTML canvas.
///
/// A Bar2d differs from a [Rect2d] in that its height is measured
/// from the anchor point up (opposite the canvas' vertical axis) and
/// also in its default anchor point
///
/// The default anchor is the bottom middle.
///
class Bar2d extends Graphic2dNode {
  Bar2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["width"] = new NumberProperty(optional: true)..payload = "bar width";
    properties["height"] = new NumberProperty(optional: true)..payload = "bar height";
  }

  NumberProperty get width => properties["width"] as NumberProperty;
  NumberProperty get height => properties["height"] as NumberProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _width = width.valueAt(i);
    num _height = height.valueAt(i);
    Anchor2d _anchor = anchor.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Adjust for anchor (default origin is bottom middle)
    num _x = 0;
    num _y = 0;
    num halfWidth = _width / 2.0;
    List<num> adj = _anchor?.calcAdjustments(-_height, halfWidth, 0, -halfWidth) ?? [0, 0];
    _x += adj[0];
    _y += adj[1];

    Path2D p = new Path2D();
    p.rect(_x - halfWidth, _y - _height, _width, _height);
    paths.add(p);

    //if (_fill) ctx.fillRect(_x - halfWidth, _y - _height, _width, _height);
    //if (_stroke) ctx.strokeRect(_x - halfWidth, _y - _height, _width, _height);
    if (_fill) ctx.fill();
    if (_stroke) ctx.stroke(p);
  }
}
