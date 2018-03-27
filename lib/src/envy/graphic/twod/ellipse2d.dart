import 'dart:html' show CanvasRenderingContext2D;
import 'package:quantity/quantity.dart' show twoPi;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional ellipse to be drawn on an HTML canvas.
///
class Ellipse2d extends Graphic2dNode {
  Ellipse2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['radiusX'] = new NumberProperty();
    properties['radiusY'] = new NumberProperty();
  }

  NumberProperty get radiusX => properties['radiusX'] as NumberProperty;
  NumberProperty get radiusY => properties['radiusY'] as NumberProperty;

  @override
  void renderIndex(int i, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _radiusX, _radiusY;
    _radiusX = radiusX.valueAt(i);
    _radiusY = radiusY.valueAt(i);
    final bool _fill = fill.valueAt(i);
    final bool _stroke = stroke.valueAt(i);

    // Adjust for anchor (default is center of ellipse)
    final Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor != null) {
      final List<num> adj = _anchor.calcAdjustments(-_radiusY, _radiusX, _radiusY, -_radiusX);
      _x += adj[0];
      _y += adj[1];
    }

    ctx
      ..beginPath()
      ..ellipse(_x, _y, _radiusX, _radiusY, 0, 0, twoPi, false)
      ..closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
