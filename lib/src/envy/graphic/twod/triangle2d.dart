import 'dart:html';
import 'dart:math';
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional triangle to be drawn on an HTML canvas.
///
/// The triangle is defined by an origin, a base length, a height and a rotation angle
/// (0 degrees is straight up, clockwise).  The default anchor point is the center of the base.
class Triangle2d extends Graphic2dNode {
  /// Constructs a new instance, with the triangle pointing up.
  Triangle2d()
      : offsetAngle = 0,
        super(null) {
    _initProperties();
  }

  /// Constructs a new instance, with the triangle pointing up.
  Triangle2d.up()
      : offsetAngle = 0,
        super(null) {
    _initProperties();
  }

  /// Constructs a new instance, with the triangle pointing to the right.
  Triangle2d.right()
      : offsetAngle = 90,
        super(null) {
    _initProperties();
  }

  /// Constructs a new instance, with the triangle pointing to the left.
  Triangle2d.left()
      : offsetAngle = -90,
        super(null) {
    _initProperties();
  }

  /// Constructs a new instance, with the triangle pointing down.
  Triangle2d.down()
      : offsetAngle = 180,
        super(null) {
    _initProperties();
  }

  ///  The offset angle, in degrees.
  final num offsetAngle;

  void _initProperties() {
    properties['base'] = new NumberProperty();
    properties['height'] = new NumberProperty();
    //properties['angle'] = new NumberProperty();
  }

  @override
  NumberProperty get x => properties['x'] as NumberProperty;

  @override
  NumberProperty get y => properties['y'] as NumberProperty;

  /// Holds the size of the triangle base, in pixels.
  NumberProperty get base => properties['base'] as NumberProperty;

  /// Holds the height of the triangle, in pixels.
  NumberProperty get height => properties['height'] as NumberProperty;
  //NumberProperty get angle => properties['angle'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x, _y, _base, _height;
    _base = base.valueAt(index);
    _height = height.valueAt(index);
    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    final num halfBase = _base / 2.0;
    final num effectiveAngleRad = offsetAngle * pi / 180.0;

    // Adjust for anchor (default is center of base)
    final Anchor2d _anchor = anchor.valueAt(index);
    _x = 0;
    _y = 0;
    if (_anchor != null) {
      final List<num> adj = _anchor.calcAdjustments(-_height, halfBase, 0, -halfBase);
      _x += adj[0];
      _y += adj[1];
    }

    // Rotate for angle ( plus any angle offset)
    ctx
      ..rotate(effectiveAngleRad)
      ..beginPath()
      ..moveTo(_x - halfBase, _y)
      ..lineTo(_x, _y - _height)
      ..lineTo(_x + halfBase, _y)
      ..closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;

    // Reverse angle rotation
    ctx.rotate(-effectiveAngleRad);
  }
}

/// A 2-dimensional triangle defined by three arbitrary vertices, to be drawn on an HTML canvas.
class TriangleVertices2d extends Graphic2dNode {
  /// Constructs a new instance.
  TriangleVertices2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties['x1'] = new NumberProperty();
    properties['y1'] = new NumberProperty();
    properties['x2'] = new NumberProperty();
    properties['y2'] = new NumberProperty();
    properties['x3'] = new NumberProperty();
    properties['y3'] = new NumberProperty();
  }

  /// Holds the x-value of the first vertex.
  NumberProperty get x1 => properties['x1'] as NumberProperty;

  /// Holds the y-value of the first vertex.
  NumberProperty get y1 => properties['y1'] as NumberProperty;

  /// Holds the x-value of the second vertex.
  NumberProperty get x2 => properties['x2'] as NumberProperty;

  /// Holds the y-value of the second vertex.
  NumberProperty get y2 => properties['y2'] as NumberProperty;

  /// Holds the x-value of the third vertex.
  NumberProperty get x3 => properties['x3'] as NumberProperty;

  /// Holds the y-value of the third vertex.
  NumberProperty get y3 => properties['y3'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _x1, _y1, _x2, _y2, _x3, _y3;
    _x1 = x1.valueAt(index);
    _y1 = y1.valueAt(index);
    _x2 = x2.valueAt(index);
    _y2 = y2.valueAt(index);
    _x3 = x3.valueAt(index);
    _y3 = y3.valueAt(index);
    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    ctx
      ..beginPath()
      ..moveTo(_x1, _y1)
      ..lineTo(_x2, _y2)
      ..lineTo(_x3, _y3)
      ..closePath();
    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
