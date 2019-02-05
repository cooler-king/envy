import '../graphic/twod/anchor2d.dart';
import '../graphic/twod/enum/anchor_mode2d.dart';
import 'binary_interpolator.dart';
import 'envy_interpolator.dart';
import 'number_interpolator.dart';

/// Interpolates between two [Anchor2d]s.
///
/// The anchor's mode is handled with a binary interpolator, while the anchor's offset is
/// handled by a number interpolator.
class Anchor2dInterpolator extends EnvyInterpolator<Anchor2d> {
  Anchor2dInterpolator({this.modeInterpolator, this.offsetInterpolator}) {
    modeInterpolator ??= new BinaryInterpolator<AnchorMode2d>();
    offsetInterpolator ??= new NumberInterpolator();
  }

  BinaryInterpolator<AnchorMode2d> modeInterpolator;
  NumberInterpolator offsetInterpolator;

  @override
  Anchor2d interpolate(Anchor2d a, Anchor2d b, num fraction) {
    final Anchor2d _anchor2d = new Anchor2d()
      ..mode = modeInterpolator.interpolate(a.mode, b.mode, fraction)
      ..offsetX = offsetInterpolator.interpolate(a.offsetX, b.offsetX, fraction)
      ..offsetY = offsetInterpolator.interpolate(a.offsetY, b.offsetY, fraction);
    return _anchor2d;
  }
}
