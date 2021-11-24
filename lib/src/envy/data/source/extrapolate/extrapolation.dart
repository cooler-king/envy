/// The abstract base class for providing missing values at the end of property arrays.
abstract class Extrapolation<T> {
  /// Constructs a instance.
  Extrapolation(this.key, this.displayName);

  /// A unique identifier.
  final String key;

  /// How the extrapolation is presented.
  final String displayName;

  /// Provides a value for [index] given a current set of values.
  T? valueAt(int index, List<T>? values);
}
