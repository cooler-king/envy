import 'dart:html' show CanvasRenderingContext2D;
import '../../color/color.dart';
import 'gradient2d.dart';
import 'pattern2d.dart';

/// Represents a fill style or a stroke style, either a pattern, gradient or color.
/// If more than one type of value is present, a pattern takes precedence over the others and
/// a gradient takes precedence over a color.
class DrawingStyle2d {
  /// Constructs a new instance.
  DrawingStyle2d({this.color, this.gradient, this.pattern});

  /// The color to use during fill or stroke operations.
  Color color;

  /// The gradient to use during fill or stroke operations.
  /// Takes precedence over color when defined.
  Gradient2d gradient;

  /// The pattern to use during fill or stroke operations.
  /// Takes precedence over both color and gradient when defined.
  Pattern2d pattern;

  /// The color black as a drawing style.
  static final DrawingStyle2d black = new DrawingStyle2d(color: Color.black);

  /// The color white as a drawing style.
  static final DrawingStyle2d white = new DrawingStyle2d(color: Color.white);

  /// Returns a `CanvasPattern`, `CanvasGradient` or CSS style representing the color, as appropriate.
  dynamic style(CanvasRenderingContext2D ctx) =>
      pattern?.asCanvasPattern(ctx) ?? (gradient?.asCanvasGradient(ctx) ?? color?.css);

  /// Gets the active pattern, gradient or color object.
  dynamic get styleObj => pattern ?? (gradient ?? color);
}
