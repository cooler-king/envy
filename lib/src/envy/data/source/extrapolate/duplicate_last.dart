import 'extrapolation.dart';

/// Extrapolates from existing data by repeating the last value.
class DuplicateLast<T> extends Extrapolation<T> {
  /// Constructs a new instance.
  DuplicateLast() : super('duplicateLast', 'Duplicate the last value');

  /// Returns the last value in set of current [values]
  /// regardless of the [index].
  /// If [values] is null or empty, null will be returned.
  @override
  T valueAt(int index, List<T> values) => values != null && values.isNotEmpty ? values.last : null;
}
