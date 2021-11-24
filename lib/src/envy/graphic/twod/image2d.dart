import 'dart:html';
import '../../envy_property.dart';
import '../../html/canvas_image_source_node.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional image to be drawn on an HTML canvas.
class Image2d extends Graphic2dNode {
  /// Constructs a instance.
  Image2d(this.source) {
    _initProperties();
  }

  // TODO dynamic node reference?
  /// The source node.
  CanvasImageSourceNode source;

  /// Holds the x-offset into the source.
  NumberProperty get sourceX => properties['sourceX'] as NumberProperty;

  /// Holds the y-offset into the source.
  NumberProperty get sourceY => properties['sourceY'] as NumberProperty;

  /// Holds the width of the rectangle extracted from the source.
  NumberProperty get sourceWidth => properties['sourceWidth'] as NumberProperty;

  /// Holds the height of the rectangle extracted from the source.
  NumberProperty get sourceHeight => properties['sourceHeight'] as NumberProperty;

  /// Holds the width of the created image.
  NumberProperty get width => properties['width'] as NumberProperty;

  /// Holds the height of the created image.
  NumberProperty get height => properties['height'] as NumberProperty;

  void _initProperties() {
    properties['sourceX'] = NumberProperty();
    properties['sourceY'] = NumberProperty();
    properties['sourceWidth'] = NumberProperty();
    properties['sourceHeight'] = NumberProperty();
    properties['width'] = NumberProperty();
    properties['height'] = NumberProperty();
  }

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest? hitTest}) {
    num _sourceX, _sourceY, _sourceWidth, _sourceHeight, _x, _y, _width, _height;
    _sourceX = sourceX.valueAt(index);
    _sourceY = sourceY.valueAt(index);
    _sourceWidth = sourceWidth.valueAt(index);
    _sourceHeight = sourceHeight.valueAt(index);
    _width = width.valueAt(index);
    _height = height.valueAt(index);

    // Fill and stroke don't apply.

    if (source != null) {
      final imgSource = source.elementAt(index);

      if (_width == 0 || _height == 0) {
        // If width and height are not explicitly set (non-zero) then use actual dimensions.
        // (Note: ImageElement, VideoElement and CanvasElement all have width and height properties).
        if (_width == 0) _width = (imgSource as dynamic).width as num;
        if (_height == 0) _height = (imgSource as dynamic).height as num;
      }

      // Adjust for anchor (default is upper left)
      _x = 0;
      _y = 0;
      final _anchor = anchor.valueAt(index);
      final adj = _anchor.calcAdjustments(0, _width, _height, 0);
      _x += adj[0];
      _y += adj[1];

      if (hitTest != null) {
        ctx
          ..beginPath()
          ..rect(_x, _y, _width, _height)
          ..closePath();
        if (ctx.isPointInPath(hitTest.x, hitTest.y)) {
          hitTest.hit = true;
        }
        return;
      }

      if ((_sourceX > 0) || (_sourceY > 0) || (_sourceWidth > 0) || (_sourceHeight > 0)) {
        ctx.drawImageScaledFromSource(imgSource, _sourceX, _sourceY, _sourceWidth, _sourceHeight, _x, _y,
            _width > 0 ? _width : _sourceWidth, _height > 0 ? _height : _sourceHeight);
      } else if (_width > 0 || _height > 0) {
        ctx.drawImageScaled(source.elementAt(index), _x, _y, _width, _height);
      } else {
        ctx.drawImage(source.elementAt(index), _x, _y);
      }
    }
  }
}
