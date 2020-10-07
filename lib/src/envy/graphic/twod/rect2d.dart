import 'dart:html';
import '../../envy_property.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional rectangle to be drawn on an HTML canvas.
/// The default anchor is the top left corner.
class Rect2d extends Graphic2dNode {
  /// Constructs a instance.
  Rect2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['width'] = NumberProperty();
    properties['height'] = NumberProperty();
  }

  /// The width of the rectangle, in pixels.
  NumberProperty get width => properties['width'] as NumberProperty;

  /// The height of the rectangle, in pixels.
  NumberProperty get height => properties['height'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    final _width = width.valueAt(index);
    final _height = height.valueAt(index);
    final _anchor = anchor.valueAt(index);

    // Adjust for anchor (default origin is upper left).
    final adj = _anchor?.calcAdjustments(0, _width, _height, 0) ?? const <num>[0, 0];
    final _x = adj[0];
    final _y = adj[1];

    ctx
      ..beginPath()
      ..rect(_x, _y, _width, _height)
      ..closePath();

    if (fill.valueAt(index) && fillOrHitTest(ctx, hitTest)) return;
    if (stroke.valueAt(index) && strokeOrHitTest(ctx, hitTest)) return;
  }
}
