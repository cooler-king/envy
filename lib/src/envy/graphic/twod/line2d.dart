import 'dart:html';
import 'dart:math' show min, max;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional line to be drawn on an HTML canvas.
class Line2d extends Graphic2dNode {
  /// Constructs a instance.
  Line2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['x1'] = NumberProperty();
    properties['y1'] = NumberProperty();
    properties['x2'] = NumberProperty();
    properties['y2'] = NumberProperty();
  }

  /// Holds the x-coordinate of the first vertex.
  NumberProperty get x1 => properties['x1'] as NumberProperty;

  /// Holds the y-coordinate of the first vertex.
  NumberProperty get y1 => properties['y1'] as NumberProperty;

  /// Holds the x-coordinate of the second vertex.
  NumberProperty get x2 => properties['x2'] as NumberProperty;

  /// Holds the y-coordinate of the second vertex.
  NumberProperty get y2 => properties['y2'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x1, _y1, _x2, _y2;
    final Anchor2d _anchor = anchor.valueAt(index);
    _x1 = x1.valueAt(index);
    _y1 = y1.valueAt(index);
    _x2 = x2.valueAt(index);
    _y2 = y2.valueAt(index);
    // fill doesn't apply?
    //bool _fill = fill.valueAt(i);
    final _stroke = stroke.valueAt(index);

    // Adjust based on anchor (default origin is x1, y1)
    if (_anchor != null) {
      final deltaX = _x2 - _x1;
      final deltaY = _y2 - _y1;

      final adj = _anchor.calcAdjustments(min(0, deltaY), max(0, deltaX), max(0, deltaY), min(0, deltaX));
      _x1 += adj[0];
      _y1 += adj[1];
      _x2 += adj[0];
      _y2 += adj[1];
    }

    //Path2D p = Path2D();
    //paths.add(p);
    ctx
      ..beginPath()
      ..moveTo(_x1, _y1)
      ..lineTo(_x2, _y2);
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
