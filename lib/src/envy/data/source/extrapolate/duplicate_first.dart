import 'extrapolation.dart';

/// Extrapolates from existing data by repeating the first value.
class DuplicateFirst<T> extends Extrapolation<T> {
  /// Constructs a instance.
  DuplicateFirst() : super('duplicateFirst', 'Duplicate the first value');

  /// Returns the first value in set of current [values]
  /// regardless of the [index].
  /// If [values] is null or empty, null will be returned.
  @override
  T valueAt(int index, List<T> values) => values != null && values.isNotEmpty ? values.first : null;
}
