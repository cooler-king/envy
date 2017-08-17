import 'extrapolation.dart';

class DuplicateFirst<T> extends Extrapolation<T> {
  DuplicateFirst() : super("duplicateFirst", "Duplicate the first value");

  /// Returns the first value in set of current [values]
  /// regardless of the [index].
  ///
  /// If [values] is null or empty, null will be returned.
  ///
  T valueAt(int index, List<T> values) => values != null && values.isNotEmpty ? values.first : null;
}
