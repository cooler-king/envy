import 'dart:html';
import 'dart:math' show min, max;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'enum/path_interpolation2d.dart';
import 'graphic2d_node.dart';
import 'point_list.dart';

/// A constant list with two zero values.
const List<num> zeroZero = const <num>[0, 0];

/// A 2-dimensional path (to be drawn on an HTML canvas).
class Path2d extends Graphic2dNode {
  /// Constructs a instance.
  Path2d() : super(null) {
    _initProperties();
  }

  /// Overrides to make default fill value false (paths are not
  /// typically filled, just stroked, although closed paths are often
  /// filled).
  @override
  void initBaseProperties() {
    super.initBaseProperties();
    properties['fill'] = BooleanProperty(defaultValue: false);
  }

  void _initProperties() {
    properties['points'] = PointListProperty();
    properties['drawMarkers'] = BooleanProperty();
    properties['interpolation'] = PathInterpolation2dProperty();
    properties['tension'] = NumberProperty(defaultValue: 0.3);
  }

  /// Holds the path points.
  PointListProperty get points => properties['points'] as PointListProperty;

  /// Controls whether markers are drawn at the points.
  BooleanProperty get drawMarkers => properties['drawMarkers'] as BooleanProperty;

  /// Controls the interpolation algorithm.
  PathInterpolation2dProperty get interpolation => properties['interpolation'] as PathInterpolation2dProperty;

  /// The tension parameter affect how the line is drawn.
  NumberProperty get tension => properties['tension'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    //num _x1, _y1, _x2, _y2;
    final Anchor2d _anchor = anchor.valueAt(index);
    final PointList _points = points.valueAt(index);
    final PathInterpolation2d _interpolation = interpolation.valueAt(index);

    if (_points.isEmpty) return;
    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    // Adjust based on anchor (default origin is x1, y1)
    final List<num> adj = _anchor?.calcAdjustments(_points.minY, _points.maxX, _points.maxY, _points.minX) ?? zeroZero;

    //Path2D p = Path2D();
    //paths.add(p);
    ctx.beginPath();
    if (_interpolation == null ||
        _interpolation == PathInterpolation2d.linear ||
        _interpolation == PathInterpolation2d.linearClosed) {
      ctx.moveTo(_points[0].x + adj[0], _points[0].y + adj[1]);
      for (final Point<num> pt in _points) {
        ctx.lineTo(pt.x + adj[0], pt.y + adj[1]);
      }
    } else if (_interpolation == PathInterpolation2d.stepBefore) {
      ctx.moveTo(_points[0].x + adj[0], _points[0].y + adj[1]);
      num x = _points[0].x + adj[0];
      for (final Point<num> pt in _points) {
        final num y = pt.y + adj[1];
        ctx.lineTo(x, y);
        x = pt.x + adj[0];
        ctx.lineTo(x, y);
      }
    } else if (_interpolation == PathInterpolation2d.stepAfter) {
      ctx.moveTo(_points[0].x + adj[0], _points[0].y + adj[1]);
      num y = _points[0].y + adj[1];
      for (final Point<num> pt in _points) {
        final num x = pt.x + adj[0];
        ctx.lineTo(x, y);
        y = pt.y + adj[1];
        ctx.lineTo(x, y);
      }
    } else if (_interpolation == PathInterpolation2d.diagonal) {
      // Cubic Bezier with tension
      // Control point 1 located on same y value as point 1 toward point 2's x value (1 - tension)
      // Control point 2 located on same y value as point 2 toward point 1's x value (1 - tension)
      num x1 = _points[0].x + adj[0];
      num y1 = _points[0].y + adj[1];
      num x2 = 0;
      num y2 = 0;
      num cp1x = 0;
      num cp2x = 0;
      num deltaX = 0;
      final num _tension = max(0.0, min(1.0, tension.valueAt(index)));

      ctx.moveTo(x1, y1);

      for (int i = 1; i < _points.length; i++) {
        x2 = _points[i].x + adj[0];
        y2 = _points[i].y + adj[1];

        deltaX = (x2 - x1) * (1.0 - _tension);

        cp1x = x1 + deltaX;
        cp2x = x2 - deltaX;

        ctx.bezierCurveTo(cp1x, y1, cp2x, y2, x2, y2);

        x1 = x2;
        y1 = y2;
      }
    }

    // Close the path if interpolation indicates closure
    if (_interpolation == PathInterpolation2d.linearClosed) {
      ctx.closePath();

      // Fill only closed paths
      if (_fill && fillOrHitTest(ctx, hitTest)) return;
    }

    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;

    // Optionally draw markers for points
    // _points.forEach((p){
    //  print(p);
    //});
  }
}
