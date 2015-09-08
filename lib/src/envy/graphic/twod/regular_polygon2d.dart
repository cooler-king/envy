part of envy;

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

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _pointCount, _x, _y, _radius;
    _pointCount = pointCount.valueAt(i);

    // No points, nothing to render
    if (_pointCount < 1) return;

    _radius = radius.valueAt(i);

    // Adjust for anchor (default is center of RegularPolygon)
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

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    p.moveTo(Math.sin(preAngleRad) * _radius, Math.cos(preAngleRad) * _radius);
    for (int i = 0; i < _pointCount; i++) {
      p.lineTo(Math.sin(postAngleRad) * _radius, Math.cos(postAngleRad) * _radius);

      preAngleRad += angleStepRad;
      postAngleRad += angleStepRad;
    }
    p.closePath();
    if (_fill) ctx.fill(p);
    if (_stroke) ctx.stroke(p);
  }
}
