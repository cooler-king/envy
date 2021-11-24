import 'dart:html' show CanvasRenderingContext2D;
import '../../envy_property.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional bar (rectangle) to be drawn on an HTML canvas.
///
/// A Bar2d differs from a `Rect2d` in that its height is measured
/// from the anchor point up (opposite the canvas' vertical axis) and
/// also in its default anchor point.
///
/// The default anchor is the bottom middle.
class Bar2d extends Graphic2dNode {
  /// Constructs a instance.
  Bar2d() {
    _initProperties();
  }

  void _initProperties() {
    properties['width'] = NumberProperty(optional: true)..payload = 'bar width';
    properties['height'] = NumberProperty(optional: true)..payload = 'bar height';
  }

  /// Holds the width of the bar in pixels.
  NumberProperty get width => properties['width'] as NumberProperty;

  /// Holds the height of the bar in pixels.
  NumberProperty get height => properties['height'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest? hitTest}) {
    final _width = width.valueAt(index);
    final _height = height.valueAt(index);
    final _anchor = anchor.valueAt(index);
    final _fill = fill.valueAt(index);
    final _stroke = stroke.valueAt(index);

    // Adjust for anchor (default origin is bottom middle)
    num _x = 0;
    num _y = 0;
    final halfWidth = _width / 2.0;
    final adj = _anchor.calcAdjustments(-_height, halfWidth, 0, -halfWidth);
    _x += adj[0];
    _y += adj[1];

    //Path2D p = Path2D();
    ctx
      ..beginPath()
      ..rect(_x - halfWidth, _y - _height, _width, _height)
      ..closePath();

    //print('BAR ${_x - halfWidth} ${_y - _height} $_width $_height');

    //if (_fill) ctx.fillRect(_x - halfWidth, _y - _height, _width, _height);
    //if (_stroke) ctx.strokeRect(_x - halfWidth, _y - _height, _width, _height);
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
