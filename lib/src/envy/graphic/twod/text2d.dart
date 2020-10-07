import 'dart:html';
import '../../envy_property.dart';
import '../../text/font.dart';
import '../../util/logger.dart';
import 'anchor2d.dart';
import 'enum/text_align2d.dart';
import 'enum/text_baseline2d.dart';
import 'graphic2d_node.dart';

/// Text to be drawn on an HTML canvas.
class Text2d extends Graphic2dNode {
  /// The length of the interior vertices from the star's center.
  Text2d() : super(null) {
    _initProperties();
  }

  /// The horizontal offset from the anchor.
  NumberProperty get dx => properties['dx'] as NumberProperty;

  /// The vertical offset from the anchor.
  NumberProperty get dy => properties['dy'] as NumberProperty;

  /// The text to render.
  StringProperty get text => properties['text'] as StringProperty;

  /// The maximum pixel width the text should occupy.
  NumberProperty get maxWidth => properties['maxWidth'] as NumberProperty;

  void _initProperties() {
    properties['dx'] = NumberProperty();
    properties['dy'] = NumberProperty();
    properties['text'] = StringProperty();
    properties['maxWidth'] = NumberProperty();
  }

  /// Overrides to make default stroke value false (text is not
  /// typically stroked, just filled).
  @override
  void initBaseProperties() {
    super.initBaseProperties();
    properties['stroke'] = BooleanProperty(defaultValue: false);
  }

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest hitTest}) {
    num _dx, _dy, _maxWidth;
    final String _text = text.valueAt(index);

    // Nothing to render?
    if (_text?.isEmpty == true) return;

    _dx = dx.valueAt(index);
    _dy = dy.valueAt(index);
    _maxWidth = maxWidth.valueAt(index);
    final bool _fill = fill.valueAt(index);
    final bool _stroke = stroke.valueAt(index);

    // Set the text-related properties in the global context
    final TextAlign2d _align = textAlign.valueAt(index);
    if (_align != null) ctx.textAlign = _align.value;

    final TextBaseline2d _baseline = textBaseline.valueAt(index);
    if (_baseline != null) ctx.textBaseline = _baseline.value;

    final Font _font = font.valueAt(index);
    if (_font != null) ctx.font = _font.css;

    // Adjust for anchor (default is top left)
    final TextMetrics metrics = ctx.measureText(_text);
    final num approxHeight = ctx.measureText('x').width * 1.25;
    final Anchor2d _anchor = anchor.valueAt(index);
    if (_anchor?.isNotDefault == true) {
      final List<num> adj = _anchor.calcAdjustments(-approxHeight, metrics.width, 0, 0);
      _dx += adj[0];
      _dy += adj[1];
    }

    // Hit test against backing rectangle, if requested.
    if (hitTest != null) {
      ctx.beginPath();
      if (metrics.actualBoundingBoxLeft != null) {
        ctx.rect(
            -metrics.actualBoundingBoxLeft + _dx,
            -metrics.actualBoundingBoxAscent + _dy,
            metrics.actualBoundingBoxRight + metrics.actualBoundingBoxLeft,
            metrics.actualBoundingBoxAscent + metrics.actualBoundingBoxDescent);
      } else if (metrics.width != null) {
        ctx.rect(_dx, _dy, metrics.width, _dy - approxHeight);
      } else {
        logger.warning('Problem with text metrics for $_text');
      }
      ctx.closePath();
      if (_fill && hitTest != null && ctx.isPointInPath(hitTest.x, hitTest.y) ||
          _stroke && hitTest != null && ctx.isPointInStroke(hitTest.x, hitTest.y)) {
        hitTest.hit = true;
      }
      return;
    }

    if (_maxWidth != null && _maxWidth > 0.0) {
      if (_fill) ctx.fillText(_text, _dx, _dy, _maxWidth);
      if (_stroke) ctx.strokeText(_text, _dx, _dy, _maxWidth);
    } else {
      if (_fill) ctx.fillText(_text, _dx, _dy);
      if (_stroke) ctx.strokeText(_text, _dx, _dy);
    }
  }
}
