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
    properties['width'] = new NumberProperty();
    properties['height'] = new NumberProperty();
  }

  NumberProperty get width => properties['width'] as NumberProperty;
  NumberProperty get height => properties['height'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _width, _height;
    Anchor2d _anchor;
    //_apply2dContext(i, ctx);
    _width = width.valueAt(index);
    _height = height.valueAt(index);
    _anchor = anchor.valueAt(index);
    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    //print('x, y, width, height... ${_x}, ${_y}, ${_width}, ${_height}');

    // Adjust for anchor (default origin is upper left)
    final List<num> adj = _anchor?.calcAdjustments(0, _width, _height, 0) ?? <num>[0, 0];
    _x = adj[0];
    _y = adj[1];

    ctx
      ..beginPath()
      ..rect(_x, _y, _width, _height)
      ..closePath();

    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
