import '../graphic/twod/pattern2d.dart';
import 'binary_interpolator.dart';
import 'envy_interpolator.dart';

/// Interpolates between two [Pattern2d]s.
/// Singleton.
class Pattern2dInterpolator extends EnvyInterpolator<Pattern2d> {
  /// This factory constructor returns the singleton instance.
  factory Pattern2dInterpolator() => instance;

  Pattern2dInterpolator._internal();

  /// The singleton instance.
  static final Pattern2dInterpolator instance = Pattern2dInterpolator._internal();

  final BinaryInterpolator<Pattern2d> _binaryInterpolator = BinaryInterpolator<Pattern2d>();

  /// Returns a Pattern2d value between [a] and [b] based on the time [fraction].
  //TODO blend images instead?
  @override
  Pattern2d interpolate(Pattern2d a, Pattern2d b, num fraction) => _binaryInterpolator.interpolate(a, b, fraction);
}
