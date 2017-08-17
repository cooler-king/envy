import 'package:quantity/quantity.dart' show twoPi;
import 'dart:html' show CanvasRenderingContext2D, Path2D;
import 'anchor2d.dart';
import 'graphic2d_node.dart';
import '../../envy_property.dart';

/// A 2-dimensional ellipse to be drawn on an HTML canvas.
///
class Ellipse2d extends Graphic2dNode {
  Ellipse2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["radiusX"] = new NumberProperty();
    properties["radiusY"] = new NumberProperty();
  }

  NumberProperty get radiusX => properties["radiusX"] as NumberProperty;
  NumberProperty get radiusY => properties["radiusY"] as NumberProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x, _y, _radiusX, _radiusY;
    _radiusX = radiusX.valueAt(i);
    _radiusY = radiusY.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Adjust for anchor (default is center of ellipse)
    Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor != null) {
      List<num> adj = _anchor.calcAdjustments(-_radiusY, _radiusX, _radiusY, -_radiusX);
      _x += adj[0];
      _y += adj[1];
    }

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    p.ellipse(_x, _y, _radiusX, _radiusY, 0, 0, twoPi, false);
    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);
  }
}
