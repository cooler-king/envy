part of envy;

class DefaultValue<T> extends Extrapolation<T> {
  final T value;

  DefaultValue(this.value) : super("default", "Use default value");

  /// Provides the default value regardless of the [index]
  /// or current [values].
  ///
  T valueAt(int index, List<T> values) => value;
}
