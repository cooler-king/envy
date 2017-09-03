import 'dart:html' show CanvasRenderingContext2D;
import 'dart:math' show PI;
import 'anchor2d.dart';
import 'graphic2d_node.dart';
import '../../envy_property.dart';

/// A 2-dimensional circle to be drawn on an HTML canvas.
///
class Circle2d extends Graphic2dNode {
  Circle2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["radius"] = new NumberProperty();
  }

  NumberProperty get radius => properties["radius"] as NumberProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _radius = radius.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Adjust for anchor (default is center of circle)
    Anchor2d _anchor = anchor.valueAt(i);
    num _x = 0;
    num _y = 0;
    if (_anchor != null) {
      List<num> adj = _anchor.calcAdjustments(-_radius, _radius, _radius, -_radius);
      _x += adj[0];
      _y += adj[1];
    }

    //Path2D p = new Path2D();
    ctx.beginPath();
    ctx.arc(_x, _y, _radius, 0, 2.0 * PI, false);
    ctx.closePath();
    //paths.add(p);
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
