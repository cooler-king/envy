import 'dart:async';
import 'dart:html';
import 'dart:math' show max;
import 'package:quantity/quantity.dart' show Angle, angle0;
import 'package:vector_math/vector_math.dart' show Vector2;
import '../graphic_node.dart';
import '../../envy_property.dart';
import '../../html/canvas_node.dart';
import 'number_list.dart';
import 'drawing_style2d.dart';
import 'enum/line_cap2d.dart';
import 'enum/line_join2d.dart';
import '../../color/color.dart';

abstract class Graphic2dNode extends GraphicLeaf {
  /// Store paths for efficient hit testing
  final List<Path2D> paths = [];

  ///
  Stream onClick;
  StreamController<Graphic2dIntersection> _onClickController;

  Stream onDoubleClick;
  StreamController<Graphic2dIntersection> _onDoubleClickController;

  Stream onMouseEnter;
  StreamController<Graphic2dIntersection> _onMouseEnterController;

  Stream onMouseOver;
  StreamController<Graphic2dIntersection> _onMouseOverController;

  Stream onMouseMove;
  StreamController<Graphic2dIntersection> _onMouseMoveController;

  Stream onMouseOut;
  StreamController<Graphic2dIntersection> _onMouseOutController;

  Stream onMouseLeave;
  StreamController<Graphic2dIntersection> _onMouseLeaveController;

  Stream onMouseDown;
  StreamController<Graphic2dIntersection> _onMouseDownController;

  Stream onMouseUp;
  StreamController<Graphic2dIntersection> _onMouseUpController;

  // For efficiency
  int _i = 0;
  Angle _rotation = angle0;
  Vector2 _scale = vec2one;
  Vector2 _skew = vec2zero;
  NumberList ctxNumberList;
  num ctxNum;
  DrawingStyle2d ctxDrawingStyle2d;
  String ctxString;
  LineCap2d ctxLineCap2d;
  LineJoin2d ctxLineJoin2d;
  Color ctxColor;

  static const List<int> defaultLineDash = const [1, 0];

  Graphic2dNode(Node htmlNode, [String id]) {
    _initContextProperties();
    initBaseProperties();

    _initStreams();
  }

  void _initContextProperties() {
    // fillStyle and stroke style can be CSS color, gradient or pattern

    // DON'T GIVE THESE INITIAL ENTER VALUES (causes exit properties to have rawSize of 1 unless manually cleared)
    // Use property default values in constructors

    properties["fillStyle"] = new DrawingStyle2dProperty(optional: true); //..enter = DrawingStyle2dConstant.black;
    properties["strokeStyle"] = new DrawingStyle2dProperty(optional: true); //..enter = DrawingStyle2dConstant.black;

    properties["globalAlpha"] = new NumberProperty(defaultValue: 1, optional: true); //..enter = NumberConstant.one;
    properties["globalCompositeOperation"] = new StringProperty(optional: true); //..enter =
    //new StringConstant.enumerationValue(CompositeOperation2d.SOURCE_OVER);

    // Line properties
    properties["lineWidth"] = new NumberProperty(defaultValue: 1, optional: true); //..enter = NumberConstant.one;

    properties["lineCap"] = new LineCap2dProperty(optional: true);
    properties["lineJoin"] = new LineJoin2dProperty(optional: true);
    properties["miterLimit"] = new NumberProperty(defaultValue: 10, optional: true); //..enter = new NumberConstant(10);
    properties["lineDashOffset"] = new NumberProperty(optional: true); //..enter = NumberConstant.zero;

    properties["lineDash"] = new NumberListProperty(optional: true);

    // Text properties
    properties["font"] = new FontProperty(optional: true);
    properties["textAlign"] = new TextAlign2dProperty(optional: true);
    properties["textBaseline"] = new TextBaseline2dProperty(optional: true);

    // Image Properties
    properties["imageSmoothingEnabled"] = new BooleanProperty(); //..enter = BooleanConstant.TRUE;

    // Shadow properties
    properties["shadowBlur"] = new NumberProperty(optional: true); //..enter = NumberConstant.zero;
    properties["shadowOffsetX"] = new NumberProperty(optional: true); //..enter = NumberConstant.zero;
    properties["shadowOffsetY"] = new NumberProperty(optional: true); //..enter = NumberConstant.zero;
    properties["shadowColor"] = new ColorProperty(optional: true); //..enter = ColorConstant.transparentBlack;
  }

  /// Initialize the set of base properties that every Graphic2d includes.
  ///
  /// anchor: the point to consider the origin of the graphic element
  /// fill:  whether or not to fill the graphic (with a color, gradient or pattern)
  /// stroke: whether or not to stroke the outline of the graphic (with a color, gradient or pattern)
  /// x: the x coordinate of the anchor
  /// y: the y coordinate of the anchor
  /// rotation: the rotation about the anchor
  ///
  void initBaseProperties() {
    properties["anchor"] = new Anchor2dProperty(optional: true);
    properties["fill"] = new BooleanProperty(defaultValue: true, optional: true);
    properties["stroke"] = new BooleanProperty(defaultValue: true, optional: true);
    properties["x"] = new NumberProperty()..payload = "x";
    properties["y"] = new NumberProperty()..payload = "y";
    properties["rotation"] = new AngleProperty(optional: true);
    properties["scale"] = new Scale2Property(optional: true);
    properties["skew"] = new Skew2Property(optional: true);

    // Arbitrary data payload
    properties["data"] = new GenericProperty();
  }

  // Context properties
  DrawingStyle2dProperty get fillStyle => properties["fillStyle"] as DrawingStyle2dProperty;

  DrawingStyle2dProperty get strokeStyle => properties["strokeStyle"] as DrawingStyle2dProperty;

  NumberProperty get globalAlpha => properties["globalAlpha"] as NumberProperty;

  StringProperty get globalCompositeOperation => properties["globalCompositeOperation"] as StringProperty;

  NumberProperty get lineWidth => properties["lineWidth"] as NumberProperty;

  LineCap2dProperty get lineCap => properties["lineCap"] as LineCap2dProperty;

  LineJoin2dProperty get lineJoin => properties["lineJoin"] as LineJoin2dProperty;

  NumberListProperty get lineDash => properties["lineDash"] as NumberListProperty;

  TextAlign2dProperty get textAlign => properties["textAlign"] as TextAlign2dProperty;

  TextBaseline2dProperty get textBaseline => properties["textBaseline"] as TextBaseline2dProperty;

  FontProperty get font => properties["font"] as FontProperty;

  NumberProperty get shadowBlur => properties["shadowBlur"] as NumberProperty;

  NumberProperty get shadowOffsetX => properties["shadowOffsetX"] as NumberProperty;

  NumberProperty get shadowOffsetY => properties["shadowOffsetY"] as NumberProperty;

  ColorProperty get shadowColor => properties["shadowColor"] as ColorProperty;

  // Base properties
  Anchor2dProperty get anchor => properties["anchor"] as Anchor2dProperty;

  BooleanProperty get fill => properties["fill"] as BooleanProperty;

  BooleanProperty get stroke => properties["stroke"] as BooleanProperty;

  NumberProperty get x => properties["x"] as NumberProperty;

  NumberProperty get y => properties["y"] as NumberProperty;

  AngleProperty get rotation => properties["rotation"] as AngleProperty;

  Scale2Property get scale => properties["scale"] as Scale2Property;

  Skew2Property get skew => properties["skew"] as Skew2Property;

  GenericProperty get data => properties["data"] as GenericProperty;

  // Synonym properties
  NumberProperty get opacity => globalAlpha;

  /// Update this 2D graphic.
  ///
  /// If [finish] is true, the new size will be used, making any exiting
  /// graphics disappear.
  ///
  ///
  void update(num fraction, {dynamic context, bool finish: false}) {
    //print("${this} graphic2d update fraction = ${fraction}, finish = ${finish}");
    //print("properties = ${properties}");
    // TODO
    // 1 - get all canvas parents
    // 2 - render in each one (INDEPENDENT population only implementation)

    // _currentContext2DList contains the contexts for the CanvasElements currently being updated
    for (var context in currentContext2DList) {
      // Update dynamic properties
      super.update(fraction, context: context, finish: finish);
      //print("g2d update 2");

      //_store2dContext(context);
      //context.save();
      //print("g2d update 3");
      _render(context, finish);
      //print("g2d update 4");
      //_restore2dContext(context);
      //context.restore();
      //print("g2d update 5");
    }
  }

  /// Draws the graphic and stores a Path2D in [paths] for efficient hit testing.
  ///
  void _renderIndex(int index, CanvasRenderingContext2D ctx);

  /// Renders a graphic for each index up to the current rendering size.
  ///
  /// If [finish] is true, the rendering size will be the new size (and therefore any exiting
  /// graphics will not be drawn).  Otherwise the rendering size will be the larger of the
  /// current size and the new size (that is, everything is drawn including new graphics and
  /// graphics on their way out).
  ///
  void _render(CanvasRenderingContext2D context, bool finish) {
    //print("G2D _render... SIZE = ${size}");
    //for(int i=0; i<size; i++) {

    // Forget the current paths, about to make new ones
    paths.clear();

    int renderSize = finish ? size : max(size, prevSize);
    //print("RENDER SIZE = ${renderSize}");
    for (_i = 0; _i < renderSize; _i++) {
      context.save();
      _apply2dContext(_i, context);
      _renderIndex(_i, context);
      context.restore();
    }
  }

  //TODO find a way to use nulls for default values -- efficiency
  //TODO only apply properties that are used for particular types of graphics?
  void _apply2dContext(int index, CanvasRenderingContext2D ctx) {
    ctxDrawingStyle2d = fillStyle.valueAt(index);
    if (ctxDrawingStyle2d != null) ctx.fillStyle = ctxDrawingStyle2d.style(ctx);

    ctxDrawingStyle2d = strokeStyle.valueAt(index);
    if (ctxDrawingStyle2d != null) ctx.strokeStyle = ctxDrawingStyle2d.style(ctx);

    ctx.globalAlpha = globalAlpha.valueAt(index) ?? 1;

    ctxString = globalCompositeOperation.valueAt(index);
    if (ctxString != null) ctx.globalCompositeOperation = ctxString;

    ctxNum = lineWidth.valueAt(index);
    if (ctxNum != null) ctx.lineWidth = ctxNum;

    ctxLineCap2d = lineCap.valueAt(index);
    if (ctxLineCap2d != null) ctx.lineCap = ctxLineCap2d.value;

    ctxLineJoin2d = lineJoin.valueAt(index);
    if (ctxLineJoin2d != null) ctx.lineJoin = ctxLineJoin2d.value;

    ctxNumberList = lineDash.valueAt(index);
    if (ctxNumberList != null) {
      if (ctxNumberList.isEmpty) {
        if (ctx.getLineDash()?.isNotEmpty ?? false) ctx.setLineDash(defaultLineDash);
      } else {
        ctx.setLineDash(ctxNumberList);
      }
    }

    ctxNum = shadowBlur.valueAt(index);
    if (ctxNum != null) ctx.shadowBlur = ctxNum;

    ctxColor = shadowColor.valueAt(index);
    if (ctxColor != null) ctx.shadowColor = ctxColor.css;

    _applyTransform(index, ctx);
  }


  /// First rotate about the anchor point and then apply the
  /// translation, scale and skew with the transform method.
  ///
  /// This method should be called after the geometry has already
  /// been adjusted for the anchor.
  ///
  void _applyTransform(int i, CanvasRenderingContext2D ctx) {
    _scale = scale.valueAt(i);
    _skew = skew.valueAt(i);
    if (scale != vec2one || skew != vec2zero) {
      ctx.transform(_scale?.x ?? 1, _skew?.x ?? 0, _skew?.y ?? 0, _scale?.y ?? 1, x.valueAt(i), y.valueAt(i));
    }

    _rotation = rotation.valueAt(i);
    if (_rotation != null && _rotation.mks != 0) {
      ctx.rotate(_rotation.mks.toDouble());
    }
  }

/*
  void _store2dContext(CanvasRenderingContext2D ctx) {
    ctx.save();
  }

  //TODO is restore necessary if we always overwrite everything?  only for groups when done with children?
  void _restore2dContext(CanvasRenderingContext2D ctx) {
    ctx.restore();
  }

*/

  /// Hit testing of the path in reverse order (returning only the first index hit), where x and y
  /// are coordinates in the local coordinate system of the graphic.
  ///
  /// Returns null if none of the stored Path2Ds for this graphic contain the
  /// point described by x, y.
  ///
  int indexContainingPoint(num x, num y, CanvasRenderingContext2D ctx) {
    for (_i = paths.length - 1; _i >= 0; _i--) {
      ctx.save();
      _applyTransform(_i, ctx);
      if (fill.valueAt(_i)) {
        if (ctx.isPointInPath(paths[_i], x, y)) {
          ctx.restore();
          return _i;
        }
      }
      if (stroke.valueAt(_i)) {
        ctx.lineWidth = lineWidth.valueAt(_i);
        if (ctx.isPointInStroke(paths[_i], x, y)) {
          ctx.restore();
          return _i;
        }
      }
      ctx.restore();
    }
    return null;
  }

  /// Hit testing of the path in reverse order (returning all indices hit), where x and y
  /// are coordinates in the local coordinate system of the graphic.
  ///
  /// Returns null if none of the stored Path2Ds for this graphic contain the
  /// point described by x, y.
  ///
  /// The indices will be appended to [listToUse], if provided.
  ///
  List<int> allIndicesContainingPoint(num x, num y, CanvasRenderingContext2D ctx, {List<int> listToUse}) {
    List<int> hitIndices = listToUse ?? [];
    for (_i = paths.length - 1; _i >= 0; _i--) {
      ctx.save();
      _applyTransform(_i, ctx);
      if (fill.valueAt(_i)) {
        if (ctx.isPointInPath(paths[_i], x, y)) {
          hitIndices.add(_i);
        } else if (stroke.valueAt(_i)) {
          ctx.lineWidth = lineWidth.valueAt(_i);
          if (ctx.isPointInStroke(paths[_i], x, y)) {
            hitIndices.add(_i);
          }
        }
      }
      ctx.restore();
    }
    return hitIndices;
  }

  void _initStreams() {
    _onClickController = new StreamController<Graphic2dIntersection>.broadcast();
    onClick = _onClickController.stream;

    _onDoubleClickController = new StreamController<Graphic2dIntersection>.broadcast();
    onDoubleClick = _onDoubleClickController.stream;

    _onMouseEnterController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseEnter = _onMouseEnterController.stream;

    _onMouseOverController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseOver = _onMouseOverController.stream;

    _onMouseMoveController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseMove = _onMouseMoveController.stream;

    _onMouseOutController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseOut = _onMouseOutController.stream;

    _onMouseLeaveController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseLeave = _onMouseLeaveController.stream;

    _onMouseDownController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseDown = _onMouseDownController.stream;

    _onMouseUpController = new StreamController<Graphic2dIntersection>.broadcast();
    onMouseUp = _onMouseUpController.stream;
  }

  void fireClickEvent(Graphic2dIntersection g2di) {
    if(_onClickController.hasListener) _onClickController.add(g2di);
  }

  void fireDoubleClickEvent(Graphic2dIntersection g2di) {
    if(_onDoubleClickController.hasListener) _onDoubleClickController.add(g2di);
  }

  void fireMouseEnterEvent(Graphic2dIntersection g2di) {
    if(_onMouseEnterController.hasListener) _onMouseEnterController.add(g2di);
  }

  void fireMouseOutEvent(Graphic2dIntersection g2di) {
    if(_onMouseOutController.hasListener) _onMouseOutController.add(g2di);
  }

  void fireMouseLeaveEvent(Graphic2dIntersection g2di) {
    if(_onMouseLeaveController.hasListener) _onMouseLeaveController.add(g2di);
  }

  void fireMouseOverEvent(Graphic2dIntersection g2di) {
    if(_onMouseOverController.hasListener) _onMouseOverController.add(g2di);
  }

  void fireMouseMoveEvent(Graphic2dIntersection g2di) {
    if(_onMouseMoveController.hasListener) _onMouseMoveController.add(g2di);
  }

  void fireMouseDownEvent(Graphic2dIntersection g2di) {
    if(_onMouseDownController.hasListener) _onMouseDownController.add(g2di);
  }

  void fireMouseUpEvent(Graphic2dIntersection g2di) {
    if(_onMouseUpController.hasListener) _onMouseUpController.add(g2di);
  }
}
