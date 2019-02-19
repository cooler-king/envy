import 'dart:html' show CanvasRenderingContext2D;
import 'dart:math' show sin, cos, min, max;
import 'package:quantity/quantity.dart' show twoPi, Angle, AngleRange, angle0, angle90, angle180, angle270;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional annular section to be drawn on an HTML canvas.
///
/// An annular section is a portion of a circle bounded by minimum and
/// maximum radii and angles.  The zero angle corresponds with the x-axis
/// and angles increase in the clockwise direction.
class AnnularSection2d extends Graphic2dNode {
  /// Constructs a new instance.
  AnnularSection2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['innerRadius'] = new NumberProperty();
    properties['outerRadius'] = new NumberProperty();
    properties['startAngle'] = new AngleProperty();
    properties['endAngle'] = new AngleProperty();
  }

  /// Holds the inner radius, in pixels, of the annular section.
  NumberProperty get innerRadius => properties['innerRadius'] as NumberProperty;

  /// Holds the outer radius, in pixels, of the annular section.
  NumberProperty get outerRadius => properties['outerRadius'] as NumberProperty;

  /// Holds the start angle of the annular section, clockwise from the x-axis.
  AngleProperty get startAngle => properties['startAngle'] as AngleProperty;

  /// Holds the end angle of the annular section, clockwise from the x-axis.
  AngleProperty get endAngle => properties['endAngle'] as AngleProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _innerRadius, _outerRadius, _startAngleRad, _endAngleRad;
    _innerRadius = innerRadius.valueAt(index);
    _outerRadius = outerRadius.valueAt(index);
    _startAngleRad = startAngle.valueAt(index).valueSI.toDouble();
    _endAngleRad = endAngle.valueAt(index).valueSI.toDouble();

    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    final num cosStart = cos(_startAngleRad);
    final num sinStart = sin(_startAngleRad);
    final num cosEnd = cos(_endAngleRad);
    final num sinEnd = sin(_endAngleRad);

    // Adjust for anchor (default is at the origin of the circle of which the annulus is a section)
    _x = 0;
    _y = 0;
    final Anchor2d _anchor = anchor.valueAt(index);
    if (_anchor?.isNotDefault == true) {
      final num x1 = _innerRadius * cosStart;
      final num y1 = _innerRadius * sinStart;

      final num x2 = _innerRadius * cosEnd;
      final num y2 = _innerRadius * sinEnd;

      final num x3 = _outerRadius * cosEnd;
      final num y3 = _outerRadius * sinEnd;

      final num x4 = _outerRadius * cosStart;
      final num y4 = _outerRadius * sinStart;

      final AngleRange range = new AngleRange(new Angle(rad: _startAngleRad), new Angle(rad: _endAngleRad));

      final num minX = range.contains360(angle180) ? -_outerRadius : min(x1, min(x2, min(x3, x4)));
      final num maxX = range.contains360(angle0) ? _outerRadius : max(x1, max(x2, max(x3, x4)));
      final num minY = range.contains360(angle270) ? -_outerRadius : min(y1, min(y2, min(y3, y4)));
      final num maxY = range.contains360(angle90) ? _outerRadius : max(y1, max(y2, max(y3, y4)));

      final List<num> adj = _anchor.calcAdjustments(minY, maxX, maxY, minX);
      _x += adj[0];
      _y += adj[1];
    }

    final num angleDelta = (_endAngleRad - _startAngleRad).abs();
    if (angleDelta.remainder(twoPi) < 0.0001 || (angleDelta - twoPi).abs() < 0.0001) {
      // Handle 360 degree annulus specially so there is no line going from inner to outer edge
      if (_fill) {
        final num cosStart = cos(_startAngleRad);
        final num sinStart = sin(_startAngleRad);
        ctx
          ..beginPath()
          ..moveTo(_x + _innerRadius * cosStart, _y + _innerRadius * sinStart)
          ..arc(_x, _y, _innerRadius, _startAngleRad, _endAngleRad, false)
          ..lineTo(_x + _outerRadius * cosEnd, _y + _outerRadius * sinEnd)
          ..arc(_x, _y, _outerRadius, _endAngleRad, _startAngleRad, true)
          ..lineTo(_x + _innerRadius * cosStart, _y + _innerRadius * sinStart)
          ..closePath();

        // Fill only for this piece so no line!
        if (fillOrHitTest(ctx, hitTest)) return;
      }

      if (_stroke) {
        // Add two circles to draw the edges (stroke only!)
        ctx
          ..beginPath()
          ..arc(_x, _y, _innerRadius, 0, twoPi, false)
          ..closePath();
        if (strokeOrHitTest(ctx, hitTest)) return;

        ctx
          ..beginPath()
          ..arc(_x, _y, _outerRadius, 0, twoPi, false)
          ..closePath();
        if (strokeOrHitTest(ctx, hitTest)) return;
      }
    } else {
      final num x1 = _x + _innerRadius * cosStart;
      final num y1 = _y + _innerRadius * sinStart;
      ctx
        ..beginPath()
        ..moveTo(x1, y1)
        ..arc(_x, _y, _innerRadius, _startAngleRad, _endAngleRad, false)
        ..lineTo(_x + _outerRadius * cosEnd, _y + _outerRadius * sinEnd)
        ..arc(_x, _y, _outerRadius, _endAngleRad, _startAngleRad, true)
        ..lineTo(x1, y1)
        ..closePath();

      if (_fill && fillOrHitTest(ctx, hitTest)) return;

      if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
    }
  }
}
