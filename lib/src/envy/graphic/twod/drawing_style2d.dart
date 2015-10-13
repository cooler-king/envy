part of envy;

/// Represents a fill style or a stroke style, either a pattern, gradient or color.
///
/// If more than one type of value is present, a pattern takes precedence over the others and
/// a gradient takes precedence over a color.
///
class DrawingStyle2d {
  Color color;
  Gradient2d gradient;
  Pattern2d pattern;

  static final DrawingStyle2d black = new DrawingStyle2d(color: Color.black);
  static final DrawingStyle2d white = new DrawingStyle2d(color: Color.white);

  DrawingStyle2d({this.color, this.gradient, this.pattern});

  dynamic style(CanvasRenderingContext2D ctx) =>
      pattern?.asCanvasPattern(ctx) ?? gradient?.asCanvasGradient(ctx) ?? color?.css ?? null;

  dynamic get styleObj => pattern ?? gradient ?? color ?? null;
}

/// A synonym class for better readability.
///
class FillStyle2d extends DrawingStyle2d {}

/// A synonym class for better readability.
///
class StrokeStyle2d extends DrawingStyle2d {}
