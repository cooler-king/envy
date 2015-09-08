part of envy;

class DrawingStyle2dInterpolator extends EnvyInterpolator<DrawingStyle2d> {
  EnvyInterpolator colorInterpolator;
  EnvyInterpolator gradient2dInterpolator;
  EnvyInterpolator pattern2dInterpolator;
  BinaryInterpolator _binaryInterpolator = new BinaryInterpolator();

  DrawingStyle2dInterpolator({this.colorInterpolator, this.gradient2dInterpolator, this.pattern2dInterpolator}) {
    if (colorInterpolator == null) colorInterpolator = new RgbaInterpolator();
    if (gradient2dInterpolator == null) gradient2dInterpolator = new Gradient2dInterpolator();
    if (pattern2dInterpolator == null) pattern2dInterpolator = _binaryInterpolator;
  }

  /// Returns a [DrawingStyle2d] having values between those of DrawingStyle2ds [a] and [b]
  /// based on the time [fraction].
  ///
  DrawingStyle2d interpolate(DrawingStyle2d a, DrawingStyle2d b, num fraction) {

    // Get the pattern, gradient or color in the style (first non-null, in that order)
    var obj1 = a.styleObj;
    var obj2 = b.styleObj;

    // Handle interpolation between same type (color, gradient or pattern)
    if (obj1 is Color && obj2 is Color) return new DrawingStyle2d(
        color: colorInterpolator.interpolate(obj1, obj2, fraction));
    if (obj1 is Gradient2d && obj2 is Gradient2d) return new DrawingStyle2d(
        gradient: gradient2dInterpolator.interpolate(obj1, obj2, fraction));
    if (obj1 is Pattern2d && obj2 is Pattern2d) return new DrawingStyle2d(
        pattern: pattern2dInterpolator.interpolate(obj1, obj2, fraction));

    //TODO more elegant?  blend as images?
    return _binaryInterpolator.interpolate(a, b, fraction);
  }
}
