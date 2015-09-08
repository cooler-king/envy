part of envy;

/// Interpolates between two [Anchor2d]s.
///
/// The anchor's mode is handled with a binary interpolator, while the anchor's offset is
/// handled by a number interpolator.
///
class Anchor2dInterpolator extends EnvyInterpolator<Anchor2d> {
  BinaryInterpolator modeInterpolator;
  NumberInterpolator offsetInterpolator;

  Anchor2dInterpolator({this.modeInterpolator, this.offsetInterpolator}) {
    if (modeInterpolator == null) modeInterpolator = new BinaryInterpolator<AnchorMode2d>();
    if (offsetInterpolator == null) offsetInterpolator = new NumberInterpolator();
  }

  Anchor2d interpolate(Anchor2d a, Anchor2d b, num fraction) {
    Anchor2d _anchor2d = new Anchor2d();
    _anchor2d.mode = modeInterpolator.interpolate(a.mode, b.mode, fraction);
    _anchor2d.offsetX = offsetInterpolator.interpolate(a.offsetX, b.offsetX, fraction);
    _anchor2d.offsetY = offsetInterpolator.interpolate(a.offsetY, b.offsetY, fraction);
    return _anchor2d;
  }
}
