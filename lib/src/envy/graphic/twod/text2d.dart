part of envy;

/// Text to be drawn on an HTML canvas.
///
class Text2d extends Graphic2dNode {
  NumberProperty get dx => properties["dx"] as NumberProperty;
  NumberProperty get dy => properties["dy"] as NumberProperty;
  StringProperty get text => properties["text"] as StringProperty;
  NumberProperty get maxWidth => properties["maxWidth"] as NumberProperty;

  Text2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["dx"] = new NumberProperty();
    properties["dy"] = new NumberProperty();
    properties["text"] = new StringProperty();
    properties["maxWidth"] = new NumberProperty();
  }

  /// Overrides to make default stroke value false (text is not
  /// typically stroked, just filled).
  ///
  @override
  void _initBaseProperties() {
    super._initBaseProperties();
    properties["stroke"] = new BooleanProperty(defaultValue: false);
  }

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _dx, _dy, _maxWidth;
    String _text = text.valueAt(i);

    // Nothing to render?
    if (_text?.isEmpty ?? false) return;

    _dx = dx.valueAt(i);
    _dy = dy.valueAt(i);
    _maxWidth = maxWidth.valueAt(i);
    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    // Set the text-related properties in the global context
    TextAlign2d _align = textAlign.valueAt(i);
    if (_align != null) ctx.textAlign = _align.value;

    TextBaseline2d _baseline = textBaseline.valueAt(i);
    if (_baseline != null) ctx.textBaseline = _baseline.value;

    Font _font = font.valueAt(i);
    if (_font != null) ctx.font = _font.css;

    // Adjust for anchor (default is top left)
    TextMetrics metrics = ctx.measureText(_text);
    num approxHeight = ctx.measureText("x").width * 1.25;
    Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor?.isNotDefault ?? false) {
      List<num> adj = _anchor.calcAdjustments(-approxHeight, metrics.width, 0, 0);
      _dx += adj[0];
      _dy += adj[1];
    }

    // Store backing rectangle for hit testing (do not draw)
    Path2D p = new Path2D();
    paths.add(p);
    if (metrics.actualBoundingBoxLeft != null) {
      p.rect(
          -(metrics.actualBoundingBoxLeft) + _dx,
          -(metrics.actualBoundingBoxAscent) + _dy,
          metrics.actualBoundingBoxRight + metrics.actualBoundingBoxLeft,
          metrics.actualBoundingBoxAscent + metrics.actualBoundingBoxDescent);
    } else if (metrics.width != null) {
      p.rect(_dx, _dy, metrics.width, _dy - approxHeight);
    } else {
      _LOG.warning("Problem with text metrics for ${_text}");
    }

    //
    if (_maxWidth != null && _maxWidth > 0.0) {
      if (_fill) ctx.fillText(_text, _dx, _dy, _maxWidth);
      if (_stroke) ctx.strokeText(_text, _dx, _dy, _maxWidth);
    } else {
      if (_fill) ctx.fillText(_text, _dx, _dy);
      if (_stroke) ctx.strokeText(_text, _dx, _dy);
    }
  }
}
