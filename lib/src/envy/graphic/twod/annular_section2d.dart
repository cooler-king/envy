import 'dart:html' show CanvasRenderingContext2D;
import 'dart:math' show sin, cos, min, max;
import 'package:quantity/quantity.dart' show twoPi;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional annular section to be drawn on an HTML canvas.
///
/// An annular section is a portion of a circle bounded by minimum and
/// maximum radii and angles.  The zero angle corresponds with the x-axis
/// and angles increase in the clockwise direction.
///
class AnnularSection2d extends Graphic2dNode {
  AnnularSection2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["innerRadius"] = new NumberProperty();
    properties["outerRadius"] = new NumberProperty();
    properties["startAngle"] = new AngleProperty();
    properties["endAngle"] = new AngleProperty();
  }

  NumberProperty get innerRadius => properties["innerRadius"] as NumberProperty;
  NumberProperty get outerRadius => properties["outerRadius"] as NumberProperty;
  AngleProperty get startAngle => properties["startAngle"] as AngleProperty;
  AngleProperty get endAngle => properties["endAngle"] as AngleProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _innerRadius, _outerRadius, _startAngleRad, _endAngleRad;
    _innerRadius = innerRadius.valueAt(i);
    _outerRadius = outerRadius.valueAt(i);
    _startAngleRad = startAngle.valueAt(i).valueSI.toDouble();
    _endAngleRad = endAngle.valueAt(i).valueSI.toDouble();

    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    num cosStart = cos(_startAngleRad);
    num sinStart = sin(_startAngleRad);
    num cosEnd = cos(_endAngleRad);
    num sinEnd = sin(_endAngleRad);

    // Adjust for anchor (default is at the origin of the circle of which the annulus is a section)
    _x = 0;
    _y = 0;
    Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor?.isNotDefault ?? false) {
      num x1 = _innerRadius * cosStart;
      num y1 = _innerRadius * sinStart;

      num x2 = _innerRadius * cosEnd;
      num y2 = _innerRadius * sinEnd;

      num x3 = _outerRadius * cosEnd;
      num y3 = _outerRadius * sinEnd;

      num x4 = _outerRadius * cosStart;
      num y4 = _outerRadius * sinStart;

      num minX = min(x1, max(x2, max(x3, x4)));
      num maxX = max(x1, max(x2, max(x3, x4)));
      num minY = min(y1, max(y2, max(y3, y4)));
      num maxY = max(y1, max(y2, max(y3, y4)));

      List<num> adj = _anchor.calcAdjustments(minY, maxX, maxY, minX);
      _x += adj[0];
      _y += adj[1];
    }

    var angleDelta = (_endAngleRad - _startAngleRad).abs();
    if (angleDelta.remainder(twoPi) < 0.0001 || (angleDelta - twoPi).abs() < 0.0001) {
      // Handle 360 degree annulus specially so there is no line going from inner to outer edge
      if (_fill) {
        num cosStart = cos(_startAngleRad);
        num sinStart = sin(_startAngleRad);
        ctx.beginPath();
        ctx.moveTo(_x + _innerRadius * cosStart, _y + _innerRadius * sinStart);
        ctx.arc(_x, _y, _innerRadius, _startAngleRad, _endAngleRad, false);
        ctx.lineTo(_x + _outerRadius * cosEnd, _y + _outerRadius * sinEnd);
        ctx.arc(_x, _y, _outerRadius, _endAngleRad, _startAngleRad, true);
        ctx.lineTo(_x + _innerRadius * cosStart, _y + _innerRadius * sinStart);
        ctx.closePath();

        // Fill only for this piece so no line!
        if (fillOrHitTest(ctx, hitTest)) return;
      }

      if (_stroke) {
        // Add two circles to draw the edges (stroke only!)
        ctx.beginPath();
        ctx.arc(_x, _y, _innerRadius, 0, twoPi, false);
        ctx.closePath();
        if (strokeOrHitTest(ctx, hitTest)) return;

        ctx.beginPath();
        ctx.arc(_x, _y, _outerRadius, 0, twoPi, false);
        ctx.closePath();
        if (strokeOrHitTest(ctx, hitTest)) return;
      }
    } else {
      num x1 = _x + _innerRadius * cosStart;
      num y1 = _y + _innerRadius * sinStart;
      ctx.beginPath();
      ctx.moveTo(x1, y1);
      ctx.arc(_x, _y, _innerRadius, _startAngleRad, _endAngleRad, false);
      ctx.lineTo(_x + _outerRadius * cosEnd, _y + _outerRadius * sinEnd);
      ctx.arc(_x, _y, _outerRadius, _endAngleRad, _startAngleRad, true);
      ctx.lineTo(x1, y1);
      ctx.closePath();

      if (_fill && fillOrHitTest(ctx, hitTest)) return;

      if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
    }
  }
}
