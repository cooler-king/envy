import 'dart:html';
import 'dart:math';
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional regular polygon to be drawn on an HTML canvas.
///
/// The regular polygon's number of points, radius
/// and rotation can be set dynamically.
///
class RegularPolygon2d extends Graphic2dNode {
  RegularPolygon2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['pointCount'] = new NumberProperty();
    properties['radius'] = new NumberProperty();
  }

  NumberProperty get pointCount => properties['pointCount'] as NumberProperty;
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
      final List<num> adj = _anchor.calcAdjustments(-_radius, _radius, _radius, -_radius);
      _x += adj[0];
      _y += adj[1];
    }

    final num halfAngleStepRad = pi / _pointCount;
    final num angleStepRad = 2.0 * halfAngleStepRad;
    num preAngleRad = -halfAngleStepRad;
    num postAngleRad = halfAngleStepRad;
    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    //Path2D p = new Path2D();
    //paths.add(p);
    ctx
      ..beginPath()
      ..moveTo(_x + sin(preAngleRad) * _radius, _y + cos(preAngleRad) * _radius);
    for (int i = 0; i < _pointCount; i++) {
      ctx.lineTo(sin(postAngleRad) * _radius, cos(postAngleRad) * _radius);

      preAngleRad += angleStepRad;
      postAngleRad += angleStepRad;
    }
    ctx.closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
