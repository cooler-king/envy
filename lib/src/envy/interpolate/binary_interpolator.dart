import 'envy_interpolator.dart';

/// Interpolates between two values by instantaneously switching from one
/// to the other at specific fraction thresholds.
///
/// If the number of thresholds is even then the second value is used at
/// a fraction of 1 and the first value is used from the last threshold up
/// to 1.
class BinaryInterpolator<T> extends EnvyInterpolator<T> {
  /// Constructs a binary interpolator that will flip between values `a` and `b` at
  /// specific fraction thresholds.
  BinaryInterpolator([List<num> thresholds]) {
    if (thresholds == null) {
      _thresholds.add(0.5);
    } else {
      _thresholds
        ..addAll(thresholds)
        ..sort();
    }
  }

  /// The fraction threshold to switch return values.
  final List<num> _thresholds = <num>[];

  /// The default binary interpolator switches values in the middle (fraction of 0.5).
  static final BinaryInterpolator<dynamic> middle = BinaryInterpolator<dynamic>();

  // For efficiency.
  bool _odd;

  @override
  T interpolate(T a, T b, num fraction) {
    if (identical(a, b)) return a;
    _odd = false;
    for (final num threshold in _thresholds) {
      if (fraction < threshold) return _odd ? b : a;
      _odd = !_odd;
    }

    return b;
  }
}

/// Flips between two boolean values at specified fraction thresholds.
/// TODO this seems to add nothing
class BooleanInterpolator extends BinaryInterpolator<bool> {
  /// Constructs a instance.
  BooleanInterpolator([List<num> thresholds]) : super(thresholds);

  /// Provides a boolean value for the time [fraction].
  @override
  bool interpolate(bool a, bool b, num fraction) => super.interpolate(a, b, fraction);
}
