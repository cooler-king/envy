import 'dart:html' show CanvasRenderingContext2D;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional diamond to be drawn on an HTML canvas.
///
class Diamond2d extends Graphic2dNode {
  Diamond2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['width'] = new NumberProperty();
    properties['height'] = new NumberProperty();
  }

  NumberProperty get width => properties['width'] as NumberProperty;
  NumberProperty get height => properties['height'] as NumberProperty;

  @override
  void renderIndex(int i, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _width, _height;
    Anchor2d _anchor;
    _width = width.valueAt(i);
    _height = height.valueAt(i);
    _anchor = anchor.valueAt(i);
    final bool _fill = fill.valueAt(i);
    final bool _stroke = stroke.valueAt(i);

    final num halfWidth = _width / 2;
    final num halfHeight = _height / 2;

    // Adjust for anchor (default origin is the center)
    _x = 0;
    _y = 0;
    if (_anchor != null) {
      final List<num> adj = _anchor.calcAdjustments(-halfHeight, halfWidth, halfHeight, -halfWidth);
      _x += adj[0];
      _y += adj[1];
    }

    ctx
      ..beginPath()
      ..moveTo(_x, _y - halfHeight)
      ..lineTo(_x + _width, _y)
      ..lineTo(_x, _y + halfHeight)
      ..lineTo(_x - _width, _y)
      ..closePath();

    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
