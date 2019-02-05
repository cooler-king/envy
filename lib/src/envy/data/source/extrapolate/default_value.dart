import 'extrapolation.dart';

class DefaultValue<T> extends Extrapolation<T> {
  /// Constructs a new instance.
  DefaultValue(this.value) : super('default', 'Use default value');

  final T value;

  /// Provides the default value regardless of the [index]
  /// or current [values].
  ///
  @override
  T valueAt(int index, List<T> values) => value;
}
