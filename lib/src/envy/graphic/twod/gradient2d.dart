import 'dart:html' show CanvasRenderingContext2D, CanvasGradient;
import '../../color/color.dart';

/// Common handle for 2d linear and radial gradients.
abstract class Gradient2d {
  /// The color stops that define the gradient mapped by offset (0-1).
  final Map<num, Color> stops = <num, Color>{};

  CanvasGradient? _canvasGradient;

  /// Adds a color stop to this gradient at the offset.
  /// The offset can range between 0.0 and 1.0.
  void addColorStop(num offset, Color c) {
    stops[offset] = c;
    _canvasGradient = null;
  }

  void _createCanvasGradient(CanvasRenderingContext2D ctx);

  /// Returns this gradient as a CanvasGradient object.
  CanvasGradient asCanvasGradient(CanvasRenderingContext2D ctx) {
    if (_canvasGradient == null) _createCanvasGradient(ctx);
    return _canvasGradient!;
  }
}

/// A gradient that changes linearly along a line defined by two endpoints.
class LinearGradient2d extends Gradient2d {
  /// Constructs a instance.
  LinearGradient2d({this.x0 = 0, this.y0 = 0, this.x1 = 0, this.y1 = 0});

  /// The x-coordinate of the line's first endpoint.
  num x0;

  /// The y-coordinate of the line's first endpoint.
  num y0;

  /// The x-coordinate of the line's other endpoint.
  num x1;

  /// The y-coordinate of the line's other endpoint.
  num y1;

  @override
  void _createCanvasGradient(CanvasRenderingContext2D ctx) {
    _canvasGradient = ctx.createLinearGradient(x0, y0, x1, y1);
    for (final stop in stops.keys) {
      _canvasGradient!.addColorStop(stop, stops[stop].css);
    }
  }
}

/// Radial gradients are defined with two imaginary circles - a starting circle and an
/// ending circle, in which the gradient starts with the start circle and moves towards
/// the end circle.
class RadialGradient2d extends Gradient2d {
  /// Constructs a instance.
  RadialGradient2d({this.x0 = 0, this.y0 = 0, this.r0 = 0, this.x1 = 0, this.y1 = 0, this.r1 = 0});

  /// The starting circle origin x-coordinate.
  num x0;

  /// The starting circle origin y-coordinate.
  num y0;

  /// The starting circle radius.
  num r0;

  /// The ending circle origin x-coordinate.
  num x1;

  /// The ending circle origin y-coordinate.
  num y1;

  /// The ending circle radius.
  num r1;

  @override
  void _createCanvasGradient(CanvasRenderingContext2D ctx) {
    _canvasGradient = ctx.createRadialGradient(x0, y0, r0, x1, y1, r1);
    for (final stop in stops.keys) {
      _canvasGradient!.addColorStop(stop, stops[stop].css);
    }
  }
}
