import 'dart:html' show CanvasRenderingContext2D;
import 'package:quantity/quantity.dart' show twoPi;
import '../../envy_property.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional ellipse to be drawn on an HTML canvas.
class Ellipse2d extends Graphic2dNode {
  /// Constructs a instance.
  Ellipse2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['radiusX'] = NumberProperty();
    properties['radiusY'] = NumberProperty();
  }

  /// Holds the ellipse's radius along the x-axis.
  NumberProperty get radiusX => properties['radiusX'] as NumberProperty;

  /// Holds the ellipse's radius along the y-axis.
  NumberProperty get radiusY => properties['radiusY'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _radiusX, _radiusY;
    _radiusX = radiusX.valueAt(index);
    _radiusY = radiusY.valueAt(index);
    final _fill = fill.valueAt(index);
    final _stroke = stroke.valueAt(index);

    _x = 0;
    _y = 0;

    // Adjust for anchor (default is center of ellipse).
    final _anchor = anchor.valueAt(index);
    if (_anchor != null) {
      final adj = _anchor.calcAdjustments(-_radiusY, _radiusX, _radiusY, -_radiusX);
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
