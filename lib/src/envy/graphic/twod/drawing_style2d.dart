import 'dart:html' show CanvasRenderingContext2D;
import '../../color/color.dart';
import 'gradient2d.dart';
import 'pattern2d.dart';

/// Represents a fill style or a stroke style, either a pattern, gradient or color.
///
/// If more than one type of value is present, a pattern takes precedence over the others and
/// a gradient takes precedence over a color.
///
class DrawingStyle2d {
  DrawingStyle2d({this.color, this.gradient, this.pattern});

  Color color;
  Gradient2d gradient;
  Pattern2d pattern;

  static final DrawingStyle2d black = new DrawingStyle2d(color: Color.black);
  static final DrawingStyle2d white = new DrawingStyle2d(color: Color.white);

  dynamic style(CanvasRenderingContext2D ctx) =>
      pattern?.asCanvasPattern(ctx) ?? (gradient?.asCanvasGradient(ctx) ?? color?.css);

  dynamic get styleObj => pattern ?? (gradient ?? color);
}

/// A synonym class for better readability.
///
class FillStyle2d extends DrawingStyle2d {}

/// A synonym class for better readability.
///
class StrokeStyle2d extends DrawingStyle2d {}
