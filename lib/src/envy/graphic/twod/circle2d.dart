import 'dart:html' show CanvasRenderingContext2D;
import 'dart:math' show pi;
import '../../envy_property.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional circle to be drawn on an HTML canvas.
class Circle2d extends Graphic2dNode {
  /// Constructs a instance.
  Circle2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['radius'] = NumberProperty();
  }

  /// Holds the radius of the circle, in pixels.
  NumberProperty get radius => properties['radius'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    final _radius = radius.valueAt(index);
    final _fill = fill.valueAt(index);
    final _stroke = stroke.valueAt(index);

    // Adjust for anchor (default is center of circle).
    final _anchor = anchor.valueAt(index);
    num _x = 0;
    num _y = 0;
    if (_anchor != null) {
      final adj = _anchor.calcAdjustments(-_radius, _radius, _radius, -_radius);
      _x += adj[0];
      _y += adj[1];
    }

    ctx
      ..beginPath()
      ..arc(_x, _y, _radius, 0, 2.0 * pi, false)
      ..closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
