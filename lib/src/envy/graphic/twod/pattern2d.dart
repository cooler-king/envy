part of envy;

enum PatternRepeat { repeat, repeatX, repeatY, noRepeat }

abstract class Pattern2d {
  CanvasPattern asCanvasPattern(CanvasRenderingContext2D ctx);
}

class ImagePattern2d extends Pattern2d {
  ImageElement imageObj;

  PatternRepeat repeat;

  CanvasPattern _canvasPattern;

  int patternWidth;
  int patternHeight;

  ImagePattern2d(this.imageObj, {this.repeat: PatternRepeat.repeat, this.patternWidth, this.patternHeight});

  void _createCanvasPattern(CanvasRenderingContext2D ctx) {
    String repeatStr = 'repeat';
    if (repeat == PatternRepeat.repeatX) repeatStr = 'repeat-x';
    if (repeat == PatternRepeat.repeatY) repeatStr = 'repeat-y';
    if (repeat == PatternRepeat.noRepeat) repeatStr = 'no-repeat';

    if (patternWidth == null && patternHeight == null) {
      // Use full sized image
      _canvasPattern = ctx.createPatternFromImage(imageObj, repeatStr);
    } else {
      // Scale down the image onto an auxiliary canvas and use that for the pattern
      int width = patternWidth ?? imageObj.width;
      int height = patternHeight ?? imageObj.height;
      CanvasElement patternCanvas = new CanvasElement(width: width, height: height);

      patternCanvas.context2D.drawImageScaled(imageObj, 0, 0, width, height);
      _canvasPattern = ctx.createPattern(patternCanvas, repeatStr);
    }
  }

  CanvasPattern asCanvasPattern(CanvasRenderingContext2D ctx) {
    if (_canvasPattern == null) _createCanvasPattern(ctx);
    return _canvasPattern;
  }
}
