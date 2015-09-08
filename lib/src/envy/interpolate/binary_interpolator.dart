part of envy;

/// Interpolate between two values by instantaneously switching from one
/// to the other at specific fraction thresholds.
///
/// If the number of thresholds is even then the second value is used at
/// a fraction of 1 and the first value is used from the last threshold up
/// to 1.
///
class BinaryInterpolator<T> extends EnvyInterpolator<T> {

  /// The fraction threshold to switch return values.
  final List<num> _thresholds = [];

  static final BinaryInterpolator<dynamic> middle = new BinaryInterpolator<dynamic>();

  /// Create a binary interpolator that will flip between values [a] and [b] at
  /// specific fraction thresholds.
  ///
  BinaryInterpolator([List<num> thresholds = null]) {
    if (thresholds == null) {
      _thresholds.add(0.5);
    } else {
      _thresholds.addAll(thresholds);
      _thresholds.sort();
    }
  }

  T interpolate(T a, T b, num fraction) {
    if (identical(a, b)) return a;
    bool odd = false;
    for (num threshold in _thresholds) {
      if (fraction < threshold) return odd ? b : a;
      odd = !odd;
    }

    return b;
  }
}

/// Flips between two boolean values at specified fraction thresholds.
///
class BooleanInterpolator extends BinaryInterpolator<bool> {
  BooleanInterpolator([List<num> thresholds = null]) : super(thresholds);

  /// Provides a boolean value for the time [fraction].
  ///
  bool interpolate(bool a, bool b, num fraction) => super.interpolate(a, b, fraction);
}
