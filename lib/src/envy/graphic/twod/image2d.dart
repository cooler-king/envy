part of envy;

/// A 2-dimensional image to be drawn on an HTML canvas.
///
class Image2d extends Graphic2dNode {
  // TODO dynamic node reference?
  CanvasImageSourceNode source;

  NumberProperty get sourceX => properties["sourceX"] as NumberProperty;
  NumberProperty get sourceY => properties["sourceY"] as NumberProperty;
  NumberProperty get sourceWidth => properties["sourceWidth"] as NumberProperty;
  NumberProperty get sourceHeight => properties["sourceHeight"] as NumberProperty;
  NumberProperty get width => properties["width"] as NumberProperty;
  NumberProperty get height => properties["height"] as NumberProperty;

  Image2d(this.source) : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["sourceX"] = new NumberProperty();
    properties["sourceY"] = new NumberProperty();
    properties["sourceWidth"] = new NumberProperty();
    properties["sourceHeight"] = new NumberProperty();
    properties["width"] = new NumberProperty();
    properties["height"] = new NumberProperty();
  }

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _sourceX, _sourceY, _sourceWidth, _sourceHeight, _x, _y, _width, _height;
    _sourceX = sourceX.valueAt(i);
    _sourceY = sourceY.valueAt(i);
    _sourceWidth = sourceWidth.valueAt(i);
    _sourceHeight = sourceHeight.valueAt(i);
    _width = width.valueAt(i);
    _height = height.valueAt(i);

    // fill and stroke don't apply

    if (source != null) {
      CanvasImageSource imgSource = source.elementAt(i);

      if (_width == 0 || _height == 0) {
        // If width and height are not explicitly set (non-zero) then use actual dimensions
        // (Note: ImageElement, VideoElement and CanvasElement all have width and height properties)
        if (_width == 0) _width = (imgSource as dynamic).width;
        if (_height == 0) _height = (imgSource as dynamic).height;
      }

      // Adjust for anchor (default is upper left)
      _x = 0;
      _y = 0;
      Anchor2d _anchor = anchor.valueAt(i);
      if (_anchor != null) {
        List<num> adj = _anchor.calcAdjustments(0, _width, _height, 0);
        _x += adj[0];
        _y += adj[1];
      }

      // Store rect path for hit testing
      Path2D p = new Path2D();
      paths.add(p);
      p.rect(_x, _y, _width, _height);

      if ((_sourceX != null && _sourceX > 0) ||
          (_sourceY != null && _sourceY > 0) ||
          (_sourceWidth != null && _sourceWidth > 0) ||
          (_sourceHeight != null && _sourceHeight > 0)) {
        ctx.drawImageScaledFromSource(imgSource, _sourceX, _sourceY, _sourceWidth, _sourceHeight, _x, _y,
            _width > 0 ? _width : _sourceWidth, _height > 0 ? _height : _sourceHeight);
      } else if ((_width != null && _width > 0) || (_height != null && _height > 0)) {
        ctx.drawImageScaled(source.elementAt(i), _x, _y, _width, _height);
      } else {
        ctx.drawImage(source.elementAt(i), _x, _y);
      }
    }
  }
}
