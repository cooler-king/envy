import 'dart:html' show CanvasRenderingContext2D, CanvasGradient;
import '../../color/color.dart';


/// Common handle for 2d linear and radial gradients.
///
abstract class Gradient2d {
  final Map<num, Color> stops = new Map<num, Color>();

  CanvasGradient _canvasGradient;

  /// Adds a color stop to this gradient at the offset.
  /// The offset can range between 0.0 and 1.0.
  ///
  void addColorStop(num offset, Color c) {
    stops[offset] = c;
    _canvasGradient = null;
  }

  void _createCanvasGradient(CanvasRenderingContext2D ctx);

  CanvasGradient asCanvasGradient(CanvasRenderingContext2D ctx) {
    if (_canvasGradient == null) _createCanvasGradient(ctx);
    return _canvasGradient;
  }
}

class LinearGradient2d extends Gradient2d {
  num x0;
  num y0;
  num x1;
  num y1;

  LinearGradient2d({this.x0: 0, this.y0: 0, this.x1: 0, this.y1: 0});

  void _createCanvasGradient(CanvasRenderingContext2D ctx) {
    _canvasGradient = ctx.createLinearGradient(x0, y0, x1, y1);
    for (var stop in stops.keys) {
      _canvasGradient.addColorStop(stop, stops[stop].css);
    }
  }
}

/// Radial gradients are defined with two imaginary circles - a starting circle and an
/// ending circle, in which the gradient starts with the start circle and moves towards
/// the end circle.
///
class RadialGradient2d extends Gradient2d {
  num x0;
  num y0;
  num r0;
  num x1;
  num y1;
  num r1;

  RadialGradient2d({this.x0: 0, this.y0: 0, this.r0: 0, this.x1: 0, this.y1: 0, this.r1: 0});

  void _createCanvasGradient(CanvasRenderingContext2D ctx) {
    _canvasGradient = ctx.createRadialGradient(x0, y0, r0, x1, y1, r1);
    for (var stop in stops.keys) {
      _canvasGradient.addColorStop(stop, stops[stop].css);
    }
  }
}
