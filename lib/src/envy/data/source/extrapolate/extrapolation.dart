part of envy;

/// The base class for providing missing values at the end of
/// property arrays.
///
abstract class Extrapolation<T> {
  final String key;
  final String displayName;

  Extrapolation(this.key, this.displayName);

  /// Provide a value for [index] given a current
  /// set of values.
  ///
  T valueAt(int index, List<T> values);
}
