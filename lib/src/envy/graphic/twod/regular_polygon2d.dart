import 'dart:html';
import 'dart:math';
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional regular polygon to be drawn on an HTML canvas.
/// The regular polygon's number of points, radius
/// and rotation can be set dynamically.
class RegularPolygon2d extends Graphic2dNode {
  /// Constructs a instance.
  RegularPolygon2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['pointCount'] = NumberProperty();
    properties['radius'] = NumberProperty();
  }

  /// The number of vertices (and sides) in the polygon.
  NumberProperty get pointCount => properties['pointCount'] as NumberProperty;

  /// The radius of the circle that would enclose the regular polygon.
  NumberProperty get radius => properties['radius'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _pointCount, _x, _y, _radius;
    _pointCount = pointCount.valueAt(index);

    // No points, nothing to render
    if (_pointCount < 1) return;

    _radius = radius.valueAt(index);

    // Adjust for anchor (default is center of RegularPolygon)
    _x = 0;
    _y = 0;
    final Anchor2d _anchor = anchor.valueAt(index);
    if (_anchor != null) {
      final adj = _anchor.calcAdjustments(-_radius, _radius, _radius, -_radius);
      _x += adj[0];
      _y += adj[1];
    }

    final halfAngleStepRad = pi / _pointCount;
    final angleStepRad = 2.0 * halfAngleStepRad;
    var preAngleRad = -halfAngleStepRad;
    num postAngleRad = halfAngleStepRad;
    final _fill = fill.valueAt(index);
    final _stroke = stroke.valueAt(index);

    ctx
      ..beginPath()
      ..moveTo(_x + sin(preAngleRad) * _radius, _y + cos(preAngleRad) * _radius);
    for (var i = 0; i < _pointCount; i++) {
      ctx.lineTo(sin(postAngleRad) * _radius, cos(postAngleRad) * _radius);

      preAngleRad += angleStepRad;
      postAngleRad += angleStepRad;
    }
    ctx.closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
