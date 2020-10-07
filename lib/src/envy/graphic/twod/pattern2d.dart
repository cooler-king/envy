import 'dart:html';

/// Pattern repetition modes.
enum PatternRepeat {
  /// Repeats in both directions.
  repeat,

  /// Only repeats horizontally.
  repeatX,

  /// Only repeats vertically.
  repeatY,

  /// Doesn't repeat.
  noRepeat
}

/// The abstract base class for two-dimensional patterns.
// ignore: one_member_abstracts
abstract class Pattern2d {
  /// Concrete classes must be able to provide an equivalent canvas pattern.
  CanvasPattern asCanvasPattern(CanvasRenderingContext2D ctx);
}

/// An image pattern.
class ImagePattern2d extends Pattern2d {
  /// Constructs a instance.
  ImagePattern2d(this.imageObj, {this.repeat = PatternRepeat.repeat, this.patternWidth, this.patternHeight});

  /// The image element to apply as the pattern.
  ImageElement imageObj;

  /// The pattern repetition mode.
  PatternRepeat repeat;

  CanvasPattern _canvasPattern;

  /// the width of the pattern.
  int patternWidth;

  /// the height of the pattern.
  int patternHeight;

  void _createCanvasPattern(CanvasRenderingContext2D ctx) {
    var repeatStr = 'repeat';
    if (repeat == PatternRepeat.repeatX) repeatStr = 'repeat-x';
    if (repeat == PatternRepeat.repeatY) repeatStr = 'repeat-y';
    if (repeat == PatternRepeat.noRepeat) repeatStr = 'no-repeat';

    if (patternWidth == null && patternHeight == null) {
      // Use full sized image
      _canvasPattern = ctx.createPatternFromImage(imageObj, repeatStr);
    } else {
      // Scale down the image onto an auxiliary canvas and use that for the pattern
      final width = patternWidth ?? (imageObj.width);
      final height = patternHeight ?? (imageObj.height);
      final patternCanvas = CanvasElement(width: width, height: height);

      patternCanvas.context2D.drawImageScaled(imageObj, 0, 0, width, height);
      _canvasPattern = ctx.createPattern(patternCanvas, repeatStr);
    }
  }

  @override
  CanvasPattern asCanvasPattern(CanvasRenderingContext2D ctx) {
    if (_canvasPattern == null) _createCanvasPattern(ctx);
    return _canvasPattern;
  }
}
