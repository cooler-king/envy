/// The base class for providing missing values at the end of
/// property arrays.
///
abstract class Extrapolation<T> {
  Extrapolation(this.key, this.displayName);

  final String key;
  final String displayName;

  /// Provide a value for [index] given a current set of values.
  T valueAt(int index, List<T> values);
}
