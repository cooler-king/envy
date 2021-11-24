import 'dart:html' show CanvasRenderingContext2D;
import 'dart:math' show max;
import '../../envy_property.dart';
import 'anchor2d.dart';
import 'graphic2d_node.dart';

/// A 2-dimensional cross to be drawn on an HTML canvas.
///
/// The cross consists of a vertical bar and a horizontal bar that
/// can be positioned anywhere along the vertical bar (0 percent
/// means the horizontal bar's center is located at the top
/// of the vertical bar).
class Cross2d extends Graphic2dNode {
  /// Constructs a instance.
  Cross2d() {
    _initProperties();
  }

  void _initProperties() {
    properties['verticalWidth'] = NumberProperty();
    properties['verticalHeight'] = NumberProperty();
    properties['horizontalWidth'] = NumberProperty();
    properties['horizontalHeight'] = NumberProperty();
    properties['percent'] = NumberProperty();
  }

  /// Holds the width of the vertical piece of the cross.
  NumberProperty get verticalWidth => properties['verticalWidth'] as NumberProperty;

  /// Holds the height of the vertical piece of the cross.
  NumberProperty get verticalHeight => properties['verticalHeight'] as NumberProperty;

  /// Holds the width of the horizontal piece of the cross.
  NumberProperty get horizontalWidth => properties['horizontalWidth'] as NumberProperty;

  /// Holds the height of the horizontal piece of the cross.
  NumberProperty get horizontalHeight => properties['horizontalHeight'] as NumberProperty;

  /// Holds the percent along the vertical piece at which to place
  /// the horizontal piece, with zero being the top and 100 being the bottom.
  NumberProperty get percent => properties['percent'] as NumberProperty;

  @override
  void renderIndex(int index, CanvasRenderingContext2D ctx, {HitTest? hitTest}) {
    num _x, _y, _verticalWidth, _verticalHeight, _horizontalWidth, _horizontalHeight, _percent;
    Anchor2d _anchor;
    _verticalWidth = verticalWidth.valueAt(index);
    _verticalHeight = verticalHeight.valueAt(index);
    _horizontalWidth = horizontalWidth.valueAt(index);
    _horizontalHeight = horizontalHeight.valueAt(index);
    _percent = percent.valueAt(index);
    _anchor = anchor.valueAt(index);
    final _fill = fill.valueAt(index);
    final _stroke = stroke.valueAt(index);

    final halfVerticalWidth = _verticalWidth / 2;

    final width = max(_verticalWidth, _horizontalWidth);
    final height = _verticalHeight;

    final halfWidth = width / 2;
    final halfHeight = height / 2;

    var minY = -halfHeight;
    var maxY = halfHeight;
    final hbarY = (_percent - 50) * 0.01 * height;
    final hbarTop = hbarY - (_horizontalHeight / 2);
    final hbarBottom = hbarY + (_horizontalHeight / 2);
    var outTop = false;
    var outBottom = false;
    if (hbarTop < minY) {
      minY = hbarTop;
      outTop = true;
    } else if (hbarBottom > maxY) {
      maxY = hbarBottom;
      outBottom = true;
    }

    // Adjust for anchor (default origin is the center of the vertical element)
    _x = 0;
    _y = 0;
    final adj = _anchor.calcAdjustments(minY, halfWidth, maxY, -halfWidth);
    _x += adj[0];
    _y += adj[1];

    // Start at top left
    ctx.beginPath();
    if (outTop) {
      ctx
        ..moveTo(_x - max(halfWidth, halfVerticalWidth), _y + hbarTop)
        ..lineTo(_x + max(halfWidth, halfVerticalWidth), _y + hbarTop)
        ..lineTo(_x + max(halfWidth, halfVerticalWidth), _y + hbarBottom)
        ..lineTo(_x + halfVerticalWidth, _y + hbarBottom)
        ..lineTo(_x + halfVerticalWidth, _y + halfVerticalWidth)
        ..lineTo(_x - halfVerticalWidth, _y + halfVerticalWidth)
        ..lineTo(_x - halfVerticalWidth, _y + hbarBottom)
        ..lineTo(_x - max(halfWidth, halfVerticalWidth), _y + hbarBottom);
    } else if (outBottom) {
      ctx
        ..moveTo(_x - halfVerticalWidth, _y - halfHeight)
        ..lineTo(_x + halfVerticalWidth, _y - halfHeight)
        ..lineTo(_x + max(halfWidth, halfVerticalWidth), _y + hbarTop)
        ..lineTo(_x + max(halfWidth, halfVerticalWidth), _y + hbarBottom)
        ..lineTo(_x - max(halfWidth, halfVerticalWidth), _y + hbarBottom)
        ..lineTo(_x - max(halfWidth, halfVerticalWidth), _y + hbarTop)
        ..lineTo(_x - halfVerticalWidth, _y + hbarTop);
    } else {
      ctx
        ..moveTo(_x - halfVerticalWidth, _y - halfHeight)
        ..lineTo(_x + halfVerticalWidth, _y - halfHeight)
        ..lineTo(_x + halfVerticalWidth, _y + hbarTop)
        ..lineTo(_x + max(halfWidth, halfVerticalWidth), _y + hbarTop)
        ..lineTo(_x + max(halfWidth, halfVerticalWidth), _y + hbarBottom)
        ..lineTo(_x + halfVerticalWidth, _y + hbarBottom)
        ..lineTo(_x + halfVerticalWidth, _y + halfHeight)
        ..lineTo(_x - halfVerticalWidth, _y + halfHeight)
        ..lineTo(_x - halfVerticalWidth, _y + hbarBottom)
        ..lineTo(_x - max(halfWidth, halfVerticalWidth), _y + hbarBottom)
        ..lineTo(_x - max(halfWidth, halfVerticalWidth), _y + hbarTop)
        ..lineTo(_x - halfVerticalWidth, _y + hbarTop);
    }

    ctx.closePath();

    if (_fill && fillOrHitTest(ctx, hitTest)) return;
    if (_stroke && strokeOrHitTest(ctx, hitTest)) return;
  }
}
