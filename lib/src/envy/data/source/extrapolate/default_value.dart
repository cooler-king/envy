import 'extrapolation.dart';

/// Extrapolates from existing data providing a default value.
class DefaultValue<T> extends Extrapolation<T> {
  /// Constructs a instance.
  DefaultValue(this.value) : super('default', 'Use default value');

  /// The default value.
  final T value;

  /// Provides the default value regardless of the [index]
  /// or current [values].
  @override
  T? valueAt(int index, List<T>? values) => value;
}
