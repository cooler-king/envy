import 'dart:html';
import 'dart:math' as Math;
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
    properties["pointCount"] = new NumberProperty();
    properties["radius"] = new NumberProperty();
  }

  NumberProperty get pointCount => properties["pointCount"] as NumberProperty;
  NumberProperty get radius => properties["radius"] as NumberProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _pointCount, _x, _y, _radius;
    _pointCount = pointCount.valueAt(i);

    // No points, nothing to render
    if (_pointCount < 1) return;

    _radius = radius.valueAt(i);

    // Adjust for anchor (default is center of RegularPolygon)
    _x = 0;
    _y = 0;
    Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor != null) {
      List<num> adj = _anchor.calcAdjustments(-_radius, _radius, _radius, -_radius);
      _x += adj[0];
      _y += adj[1];
    }

    num halfAngleStepRad = Math.PI / _pointCount;
    num angleStepRad = 2.0 * halfAngleStepRad;
    num preAngleRad = -halfAngleStepRad;
    num postAngleRad = halfAngleStepRad;
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    //Path2D p = new Path2D();
    //paths.add(p);
    ctx.beginPath();
    ctx.moveTo(_x + Math.sin(preAngleRad) * _radius, _y + Math.cos(preAngleRad) * _radius);
    for (int i = 0; i < _pointCount; i++) {
      ctx.lineTo(Math.sin(postAngleRad) * _radius, Math.cos(postAngleRad) * _radius);

      preAngleRad += angleStepRad;
      postAngleRad += angleStepRad;
    }
    ctx.closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
