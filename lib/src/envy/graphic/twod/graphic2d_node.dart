import 'dart:async';
import 'dart:html';
import 'dart:math' show max;
import 'package:quantity/quantity.dart' show Angle, angle0;
import 'package:vector_math/vector_math.dart' show Vector2;
import '../../color/color.dart';
import '../../envy_property.dart';
import '../../html/canvas_node.dart';
import '../graphic_node.dart';
import 'drawing_style2d.dart';
import 'enum/line_cap2d.dart';
import 'enum/line_join2d.dart';
import 'number_list.dart';

/// The abstract base class for all two-dimensional graphic nodes.
abstract class Graphic2dNode extends GraphicLeaf {
  /// Constructs a instance.
  Graphic2dNode(this.htmlNode) {
    _initContextProperties();
    initBaseProperties();

    _initStreams();
  }

  /// The HTML node associated with this graphic.
  final Node htmlNode;

  /// Broadcasts when the graphic is single-clicked.
  Stream<Graphic2dIntersection> onClick;
  StreamController<Graphic2dIntersection> _onClickController;

  /// Broadcasts when the graphic is double-clicked.
  Stream<Graphic2dIntersection> onDoubleClick;
  StreamController<Graphic2dIntersection> _onDoubleClickController;

  /// Broadcasts when the cursor enters the boundary of the graphic
  /// (regardless of whether anything else is on top of it).
  Stream<Graphic2dIntersection> onMouseEnter;
  StreamController<Graphic2dIntersection> _onMouseEnterController;

  /// Broadcasts when the cursor enters the visible portion of the graphic.
  Stream<Graphic2dIntersection> onMouseOver;
  StreamController<Graphic2dIntersection> _onMouseOverController;

  /// Broadcasts when the cursor moves over the graphic.
  Stream<Graphic2dIntersection> onMouseMove;
  StreamController<Graphic2dIntersection> _onMouseMoveController;

  /// Broadcasts when the cursor moves out of the graphic.
  Stream<Graphic2dIntersection> onMouseOut;
  StreamController<Graphic2dIntersection> _onMouseOutController;

  /// Broadcasts when the cursor leaves the graphic.
  Stream<Graphic2dIntersection> onMouseLeave;
  StreamController<Graphic2dIntersection> _onMouseLeaveController;

  /// Broadcasts when a mouse button is depressed while over the graphic.
  Stream<Graphic2dIntersection> onMouseDown;
  StreamController<Graphic2dIntersection> _onMouseDownController;

  /// Broadcasts when a mouse button is released while over the graphic.
  Stream<Graphic2dIntersection> onMouseUp;
  StreamController<Graphic2dIntersection> _onMouseUpController;

  // For efficiency.
  int _i = 0;
  Angle _rotation = angle0;
  Vector2 _scale = vec2one;
  Vector2 _skew = vec2zero;
  NumberList _ctxNumberLists;
  num _ctxNum;
  DrawingStyle2d _ctxDrawingStyle2d;
  String _ctxString;
  LineCap2d _ctxLineCap2d;
  LineJoin2d _ctxLineJoin2d;
  Color _ctxColor;
  final HitTest _hitTest = HitTest(0, 0);

  /// The default dash pattern is a dotted line.
  static const List<int> defaultLineDash = const <int>[1, 0];

  void _initContextProperties() {
    // Fill style and stroke style can be CSS color, gradient or pattern.

    // DON'T GIVE THESE INITIAL ENTER VALUES (causes exit properties to have rawSize of 1 unless manually cleared).
    // Use property default values in constructors.

    properties['fillStyle'] = DrawingStyle2dProperty(optional: true); //..enter = DrawingStyle2dConstant.black;
    properties['strokeStyle'] = DrawingStyle2dProperty(optional: true); //..enter = DrawingStyle2dConstant.black;

    properties['globalAlpha'] = NumberProperty(defaultValue: 1, optional: true); //..enter = NumberConstant.one;
    properties['globalCompositeOperation'] = StringProperty(optional: true); //..enter =
    //StringConstant.enumerationValue(CompositeOperation2d.SOURCE_OVER);

    // Line properties
    properties['lineWidth'] = NumberProperty(defaultValue: 1, optional: true); //..enter = NumberConstant.one;

    properties['lineCap'] = LineCap2dProperty(optional: true);
    properties['lineJoin'] = LineJoin2dProperty(optional: true);
    properties['miterLimit'] = NumberProperty(defaultValue: 10, optional: true); //..enter = NumberConstant(10);
    properties['lineDashOffset'] = NumberProperty(optional: true); //..enter = NumberConstant.zero;

    properties['lineDash'] = NumberListProperty(optional: true);

    // Text properties
    properties['font'] = FontProperty(optional: true);
    properties['textAlign'] = TextAlign2dProperty(optional: true);
    properties['textBaseline'] = TextBaseline2dProperty(optional: true);

    // Image Properties
    properties['imageSmoothingEnabled'] = BooleanProperty(); //..enter = BooleanConstant.TRUE;

    // Shadow properties
    properties['shadowBlur'] = NumberProperty(optional: true); //..enter = NumberConstant.zero;
    properties['shadowOffsetX'] = NumberProperty(optional: true); //..enter = NumberConstant.zero;
    properties['shadowOffsetY'] = NumberProperty(optional: true); //..enter = NumberConstant.zero;
    properties['shadowColor'] = ColorProperty(optional: true); //..enter = ColorConstant.transparentBlack;
  }

  /// Initialize the set of base properties that every Graphic2d includes.
  ///
  /// anchor: the point to consider the origin of the graphic element
  /// fill:  whether or not to fill the graphic (with a color, gradient or pattern)
  /// stroke: whether or not to stroke the outline of the graphic (with a color, gradient or pattern)
  /// x: the x coordinate of the anchor
  /// y: the y coordinate of the anchor
  /// rotation: the rotation about the anchor
  void initBaseProperties() {
    properties['anchor'] = Anchor2dProperty(optional: true);
    properties['fill'] = BooleanProperty(defaultValue: true, optional: true);
    properties['stroke'] = BooleanProperty(defaultValue: true, optional: true);
    properties['x'] = NumberProperty()..payload = 'x';
    properties['y'] = NumberProperty()..payload = 'y';
    properties['rotation'] = AngleProperty(optional: true);
    properties['scale'] = Scale2Property(optional: true);
    properties['skew'] = Skew2Property(optional: true);

    // Arbitrary data payload.
    properties['data'] = GenericProperty();
  }

  // Context properties.

  /// The style that will be applied during fill operations.
  DrawingStyle2dProperty get fillStyle => properties['fillStyle'] as DrawingStyle2dProperty;

  /// The style that will be applied during stroke operations.
  DrawingStyle2dProperty get strokeStyle => properties['strokeStyle'] as DrawingStyle2dProperty;

  /// The global opacity to be applied during all drawing operations.
  NumberProperty get globalAlpha => properties['globalAlpha'] as NumberProperty;

  /// The global composite operation to be applied during all drawing operations.
  StringProperty get globalCompositeOperation => properties['globalCompositeOperation'] as StringProperty;

  /// Controls the width of lines being rendered.
  NumberProperty get lineWidth => properties['lineWidth'] as NumberProperty;

  /// Controls how line endpoints are rendered.
  LineCap2dProperty get lineCap => properties['lineCap'] as LineCap2dProperty;

  /// Controls ho9w the joints between line segments are rendered.
  LineJoin2dProperty get lineJoin => properties['lineJoin'] as LineJoin2dProperty;

  /// Controls the dash pattern (with the numbers indicating solid, then empty, then solid, etc.).
  NumberListProperty get lineDash => properties['lineDash'] as NumberListProperty;

  /// Controls the alignment of text being rendered.
  TextAlign2dProperty get textAlign => properties['textAlign'] as TextAlign2dProperty;

  /// Controls the vertical offset of text being rendered.
  TextBaseline2dProperty get textBaseline => properties['textBaseline'] as TextBaseline2dProperty;

  /// Controls the font in which text is rendered.
  FontProperty get font => properties['font'] as FontProperty;

  /// Controls text shadow blur.
  NumberProperty get shadowBlur => properties['shadowBlur'] as NumberProperty;

  /// Controls text shadow horizontal offset.
  NumberProperty get shadowOffsetX => properties['shadowOffsetX'] as NumberProperty;

  /// Controls text shadow vertical offset.
  NumberProperty get shadowOffsetY => properties['shadowOffsetY'] as NumberProperty;

  /// Controls text shadow color.
  ColorProperty get shadowColor => properties['shadowColor'] as ColorProperty;

  // Base properties.

  /// Controls the origin of the graphic being rendered.
  Anchor2dProperty get anchor => properties['anchor'] as Anchor2dProperty;

  /// Controls whether the graphic is filled.
  BooleanProperty get fill => properties['fill'] as BooleanProperty;

  /// Controls whether (the outline of) the shape is stroked.
  BooleanProperty get stroke => properties['stroke'] as BooleanProperty;

  /// The x-coordinate of the graphic's anchor.
  NumberProperty get x => properties['x'] as NumberProperty;

  /// The y-coordinate of the graphic's anchor.
  NumberProperty get y => properties['y'] as NumberProperty;

  /// Rotation about the graphic's anchor.
  AngleProperty get rotation => properties['rotation'] as AngleProperty;

  /// Controls scaling of the graphic.
  Scale2Property get scale => properties['scale'] as Scale2Property;

  /// Controls skewing of the graphic.
  Skew2Property get skew => properties['skew'] as Skew2Property;

  /// An arbitrary data payload that can be attached to a graphic.
  GenericProperty get data => properties['data'] as GenericProperty;

  // Synonym properties.

  /// Opacity is a synonym for [globalAlpha].
  NumberProperty get opacity => globalAlpha;

  /// Updates this 2D graphic.
  /// If [finish] is true, the size will be used, making any exiting
  /// graphics disappear.
  @override
  void update(num fraction, {dynamic context, bool finish = false}) {
    // TODO
    // 1 - get all canvas parents
    // 2 - render in each one (INDEPENDENT population only implementation)

    // _currentContext2DList contains the contexts for the CanvasElements currently being updated.
    for (final CanvasRenderingContext2D context in currentContext2DList) {
      // Update dynamic properties.
      super.update(fraction, context: context, finish: finish);
      _render(context, finish);
    }
  }

  /// Draws the graphic.
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest});

  /// Renders a graphic for each index up to the current rendering size.
  ///
  /// If [finish] is true, the rendering size will be the size (and therefore any exiting
  /// graphics will not be drawn).  Otherwise the rendering size will be the larger of the
  /// current size and the size (that is, everything is drawn including graphics and
  /// graphics on their way out).
  void _render(CanvasRenderingContext2D context, bool finish) {
    final int renderSize = finish ? size : max(size, prevSize);
    for (_i = 0; _i < renderSize; _i++) {
      context.save();
      _apply2dContext(_i, context);
      renderIndex(_i, context);
      context.restore();
    }
  }

  //TODO find a way to use nulls for default values -- efficiency
  //TODO only apply properties that are used for particular types of graphics?
  void _apply2dContext(int index, CanvasRenderingContext2D ctx) {
    _ctxDrawingStyle2d = fillStyle.valueAt(index);
    if (_ctxDrawingStyle2d != null) ctx.fillStyle = _ctxDrawingStyle2d.style(ctx);

    _ctxDrawingStyle2d = strokeStyle.valueAt(index);
    if (_ctxDrawingStyle2d != null) ctx.strokeStyle = _ctxDrawingStyle2d.style(ctx);

    ctx.globalAlpha = globalAlpha.valueAt(index) ?? 1;

    _ctxString = globalCompositeOperation.valueAt(index);
    if (_ctxString != null) ctx.globalCompositeOperation = _ctxString;

    _ctxNum = lineWidth.valueAt(index);
    if (_ctxNum != null) ctx.lineWidth = _ctxNum;

    _ctxLineCap2d = lineCap.valueAt(index);
    if (_ctxLineCap2d != null) ctx.lineCap = _ctxLineCap2d.value;

    _ctxLineJoin2d = lineJoin.valueAt(index);
    if (_ctxLineJoin2d != null) ctx.lineJoin = _ctxLineJoin2d.value;

    _ctxNumberLists = lineDash.valueAt(index);
    if (_ctxNumberLists != null) {
      if (_ctxNumberLists.isEmpty) {
        if (ctx.getLineDash()?.isNotEmpty == true) ctx.setLineDash(defaultLineDash);
      } else {
        ctx.setLineDash(_ctxNumberLists);
      }
    }

    _ctxNum = shadowBlur.valueAt(index);
    if (_ctxNum != null) ctx.shadowBlur = _ctxNum;

    _ctxColor = shadowColor.valueAt(index);
    if (_ctxColor != null) ctx.shadowColor = _ctxColor.css;

    _applyTransform(index, ctx);
  }

  /// Applies translation, scale, skew and rotation values.
  /// This method should be called after the geometry has already
  /// been adjusted for the anchor.
  void _applyTransform(int i, CanvasRenderingContext2D ctx) {
    _scale = scale.valueAt(i);
    _skew = skew.valueAt(i);
    if (_scale != vec2one || _skew != vec2zero) {
      // Scale, skew and translate.
      ctx.transform(_scale?.x ?? 1, _skew?.x ?? 0, _skew?.y ?? 0, _scale?.y ?? 1, x.valueAt(i), y.valueAt(i));
    } else {
      // Translate only.
      ctx.translate(x.valueAt(i), y.valueAt(i));
    }

    // Then rotate, as necessary.
    _rotation = rotation.valueAt(i);
    if (_rotation != null && _rotation.mks.toDouble() != 0) {
      ctx.rotate(_rotation.mks.toDouble());
    }
  }

  /// Hit testing of the path in reverse order (returning only the first index hit), where x and y
  /// are coordinates in the local coordinate system of the graphic.
  /// Returns -1 if none of the stored Path2Ds for this graphic contain the
  /// point described by x, y.
  int indexContainingPoint(num x, num y, CanvasRenderingContext2D ctx) {
    for (_i = size - 1; _i >= 0; _i--) {
      ctx.save();
      _applyTransform(_i, ctx);

      _hitTest
        ..x = x
        ..y = y
        ..hit = false;
      renderIndex(_i, ctx, hitTest: _hitTest);
      if (_hitTest.hit) {
        ctx.restore();
        return _i;
      }
      ctx.restore();
    }
    return -1;
  }

  /// Hit testing of the path in reverse order (returning all indices hit), where x and y
  /// are coordinates in the local coordinate system of the graphic.
  ///
  /// Returns null if none of the stored Path2Ds for this graphic contain the
  /// point described by x, y.
  ///
  /// The indices will be appended to [listToUse], if provided.
  List<int> allIndicesContainingPoint(num x, num y, CanvasRenderingContext2D ctx, {List<int> listToUse}) {
    final List<int> hitIndices = listToUse ?? <int>[];
    //for (_i = paths.length - 1; _i >= 0; _i--) {
    for (_i = size - 1; _i >= 0; _i--) {
      ctx.save();
      _applyTransform(_i, ctx);

      _hitTest
        ..x = x
        ..y = y
        ..hit = false;
      renderIndex(_i, ctx, hitTest: _hitTest);
      if (_hitTest.hit) hitIndices.add(_i);
      ctx.restore();
    }
    return hitIndices;
  }

  void _initStreams() {
    _onClickController = StreamController<Graphic2dIntersection>.broadcast();
    onClick = _onClickController.stream;

    _onDoubleClickController = StreamController<Graphic2dIntersection>.broadcast();
    onDoubleClick = _onDoubleClickController.stream;

    _onMouseEnterController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseEnter = _onMouseEnterController.stream;

    _onMouseOverController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseOver = _onMouseOverController.stream;

    _onMouseMoveController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseMove = _onMouseMoveController.stream;

    _onMouseOutController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseOut = _onMouseOutController.stream;

    _onMouseLeaveController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseLeave = _onMouseLeaveController.stream;

    _onMouseDownController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseDown = _onMouseDownController.stream;

    _onMouseUpController = StreamController<Graphic2dIntersection>.broadcast();
    onMouseUp = _onMouseUpController.stream;
  }

  /// Broadcasts a click intersection event.
  void fireClickEvent(Graphic2dIntersection g2di) {
    if (_onClickController.hasListener) _onClickController.add(g2di);
  }

  /// Broadcasts a double-click intersection event.
  void fireDoubleClickEvent(Graphic2dIntersection g2di) {
    if (_onDoubleClickController.hasListener) _onDoubleClickController.add(g2di);
  }

  /// Broadcasts an enter intersection event.
  void fireMouseEnterEvent(Graphic2dIntersection g2di) {
    if (_onMouseEnterController.hasListener) _onMouseEnterController.add(g2di);
  }

  /// Broadcasts an out intersection event.
  void fireMouseOutEvent(Graphic2dIntersection g2di) {
    if (_onMouseOutController.hasListener) _onMouseOutController.add(g2di);
  }

  /// Broadcasts a leave intersection event.
  void fireMouseLeaveEvent(Graphic2dIntersection g2di) {
    if (_onMouseLeaveController.hasListener) _onMouseLeaveController.add(g2di);
  }

  /// Broadcasts an over intersection event.
  void fireMouseOverEvent(Graphic2dIntersection g2di) {
    if (_onMouseOverController.hasListener) _onMouseOverController.add(g2di);
  }

  /// Broadcasts a move intersection event.
  void fireMouseMoveEvent(Graphic2dIntersection g2di) {
    if (_onMouseMoveController.hasListener) _onMouseMoveController.add(g2di);
  }

  /// Broadcasts a mouse down intersection event.
  void fireMouseDownEvent(Graphic2dIntersection g2di) {
    if (_onMouseDownController.hasListener) _onMouseDownController.add(g2di);
  }

  /// Broadcasts a mouse up intersection event.
  void fireMouseUpEvent(Graphic2dIntersection g2di) {
    if (_onMouseUpController.hasListener) _onMouseUpController.add(g2di);
  }

  /// Fills the current path defined in [ctx], unless a [hitTest] is requested.
  /// Returns true only if hitTest is requested and there is a hit.
  bool fillOrHitTest(CanvasRenderingContext2D ctx, HitTest hitTest) {
    if (hitTest == null) {
      ctx.fill();
      return false;
    }
    return hitTest.hit = ctx.isPointInPath(hitTest.x, hitTest.y);
  }

  /// Strokes the current path defined in [ctx], unless a [hitTest] is requested.
  /// Returns true only if hitTest is requested and there is a hit.
  bool strokeOrHitTest(CanvasRenderingContext2D ctx, HitTest hitTest) {
    if (hitTest == null) {
      ctx.stroke();
      return false;
    }
    return hitTest.hit = ctx.isPointInStroke(hitTest.x, hitTest.y);
  }
}

/// Optionally passed into renderIndex to request a hit test rather than a render.
class HitTest {
  /// Constructs a instance.
  HitTest(this.x, this.y);

  /// The x-value of the point to test.
  num x;

  /// The y-value of the point to test.
  num y;

  /// Whether a hit was detected.
  bool hit = false;
}
