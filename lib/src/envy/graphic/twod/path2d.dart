import 'dart:html';
import 'dart:math' show min, max;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';
import 'point_list.dart';
import 'enum/path_interpolation2d.dart';

const List<num> zeroZero = const [0, 0];

/// A 2-dimensional path (to be drawn on an HTML canvas).
///
class Path2d extends Graphic2dNode {
  Path2d() : super(null) {
    _initProperties();
  }

  /// Overrides to make default fill value false (paths are not
  /// typically filled, just stroked, although closed paths are often
  /// filled).
  ///
  @override
  void initBaseProperties() {
    super.initBaseProperties();
    properties["fill"] = new BooleanProperty(defaultValue: false);
  }

  void _initProperties() {
    properties["points"] = new PointListProperty();
    properties["drawMarkers"] = new BooleanProperty();
    properties["interpolation"] = new PathInterpolation2dProperty();
    properties["tension"] = new NumberProperty(defaultValue: 0.3);
  }

  PointListProperty get points => properties["points"] as PointListProperty;

  BooleanProperty get drawMarkers => properties["drawMarkers"] as BooleanProperty;

  PathInterpolation2dProperty get interpolation => properties["interpolation"] as PathInterpolation2dProperty;

  NumberProperty get tension => properties["tension"] as NumberProperty;

  void renderIndex(int i, CanvasRenderingContext2D ctx) {
    //num _x1, _y1, _x2, _y2;
    Anchor2d _anchor = anchor.valueAt(i);
    PointList _points = points.valueAt(i);
    PathInterpolation2d _interpolation = interpolation.valueAt(i);

    if (_points.isEmpty) return;
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Adjust based on anchor (default origin is x1, y1)
    List<num> adj = _anchor?.calcAdjustments(_points.minY, _points.maxX, _points.maxY, _points.minX) ?? zeroZero;

    Path2D p = new Path2D();
    paths.add(p);
    //ctx.beginPath();
    if (_interpolation == null ||
        _interpolation == PathInterpolation2d.LINEAR ||
        _interpolation == PathInterpolation2d.LINEAR_CLOSED) {
      p.moveTo(_points[0].x + adj[0], _points[0].y + adj[1]);
      for (var pt in _points) {
        p.lineTo(pt.x + adj[0], pt.y + adj[1]);
      }
    } else if (_interpolation == PathInterpolation2d.STEP_BEFORE) {
      p.moveTo(_points[0].x + adj[0], _points[0].y + adj[1]);
      var x = _points[0].x + adj[0];
      for (var pt in _points) {
        var y = pt.y + adj[1];
        p.lineTo(x, y);
        x = pt.x + adj[0];
        p.lineTo(x, y);
      }
    } else if (_interpolation == PathInterpolation2d.STEP_AFTER) {
      p.moveTo(_points[0].x + adj[0], _points[0].y + adj[1]);
      var y = _points[0].y + adj[1];
      for (var pt in _points) {
        var x = pt.x + adj[0];
        p.lineTo(x, y);
        y = pt.y + adj[1];
        p.lineTo(x, y);
      }
    } else if (_interpolation == PathInterpolation2d.DIAGONAL) {
      // Cubic Bezier with tension
      // Control point 1 located on same y value as point 1 toward point 2's x value (1 - tension)
      // Control point 2 located on same y value as point 2 toward point 1's x value (1 - tension)
      var x1 = _points[0].x + adj[0];
      var y1 = _points[0].y + adj[1];
      var x2 = 0;
      var y2 = 0;
      var cp1x = 0;
      var cp2x = 0;
      var deltaX = 0;
      num _tension = max(0.0, min(1.0, tension.valueAt(i)));

      p.moveTo(x1, y1);

      for (int i = 1; i < _points.length; i++) {
        x2 = _points[i].x + adj[0];
        y2 = _points[i].y + adj[1];

        deltaX = (x2 - x1) * (1.0 - _tension);

        cp1x = x1 + deltaX;
        cp2x = x2 - deltaX;

        p.bezierCurveTo(cp1x, y1, cp2x, y2, x2, y2);

        x1 = x2;
        y1 = y2;
      }
    }

    // Close the path if interpolation indicates closure
    if (_interpolation == PathInterpolation2d.LINEAR_CLOSED) {
      p.closePath();

      // Fill only closed paths
      if (_fill) ctx.fill();
    }

    if (_stroke) ctx.stroke(p);

    // Optionally draw markers for points
    // _points.forEach((p){
    //  print(p);
    //});
  }
}
