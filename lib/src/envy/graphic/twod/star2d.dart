import 'dart:html';
import 'dart:math';
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional star to be drawn on an HTML canvas.
///
/// The star's number of points, outer and inner radius
/// and rotation can be set dynamically.
///
class Star2d extends Graphic2dNode {
  Star2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['pointCount'] = new NumberProperty();
    properties['outerRadius'] = new NumberProperty();
    properties['innerRadius'] = new NumberProperty();
  }

  NumberProperty get pointCount => properties['pointCount'] as NumberProperty;
  NumberProperty get innerRadius => properties['innerRadius'] as NumberProperty;
  NumberProperty get outerRadius => properties['outerRadius'] as NumberProperty;

  @override
  void renderIndex(int i, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _pointCount, _x, _y, _outerRadius, _innerRadius;
    _pointCount = pointCount.valueAt(i).toInt();

    // No points, nothing to render
    if (_pointCount < 1) return;

    _outerRadius = outerRadius.valueAt(i);
    _innerRadius = innerRadius.valueAt(i);

    //num maxRadius = Math.max(_outerRadius, _innerRadius);

    final List<num> xRaw = <num>[];
    final List<num> yRaw = <num>[];

    final num halfAngleStepRad = pi / _pointCount;
    final num angleStepRad = 2.0 * halfAngleStepRad;
    num angleRad = 0;
    num preAngleRad = angleRad - halfAngleStepRad;
    num postAngleRad = angleRad + halfAngleStepRad;

    num maxX = double.negativeInfinity;
    num maxY = double.negativeInfinity;

    xRaw.add(sin(preAngleRad) * _innerRadius);
    maxX = max(maxX, xRaw.last);

    yRaw.add(-cos(preAngleRad) * _innerRadius);
    maxY = max(maxY, yRaw.last);

    for (int i = 0; i < _pointCount; i++) {
      xRaw.add(sin(angleRad) * _outerRadius);
      maxX = max(maxX, xRaw.last);
      yRaw.add(-cos(angleRad) * _outerRadius);
      maxY = max(maxY, yRaw.last);

      xRaw.add(sin(postAngleRad) * _innerRadius);
      maxX = max(maxX, xRaw.last);
      yRaw.add(-cos(postAngleRad) * _innerRadius);
      maxY = max(maxY, yRaw.last);

      preAngleRad += angleStepRad;
      angleRad += angleStepRad;
      postAngleRad += angleStepRad;
    }

    // Adjust for anchor (default is center of Star)
    _x = 0;
    _y = 0;
    final Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor != null) {
      final List<num> adj = _anchor.calcAdjustments(-maxY, maxX, maxY, -maxX);
      _x += adj[0];
      _y += adj[1];
    }

    if (xRaw.isNotEmpty) {
      final bool _fill = fill.valueAt(i);
      final bool _stroke = stroke.valueAt(i);

      ctx
        ..beginPath()
        ..moveTo(_x + xRaw[0], _y + yRaw[0]);
      for (int i = 1; i < xRaw.length; i++) {
        ctx.lineTo(_x + xRaw[i], _y + yRaw[i]);
      }
      ctx.closePath();
      if (_fill && fillOrHitTest(ctx, hitTest)) return;
      if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
    }
  }
}
