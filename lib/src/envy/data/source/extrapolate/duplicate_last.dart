import 'extrapolation.dart';

class DuplicateLast<T> extends Extrapolation<T> {
  DuplicateLast() : super('duplicateLast', 'Duplicate the last value');

  /// Returns the last value in set of current [values]
  /// regardless of the [index].
  ///
  /// If [values] is null or empty, null will be returned.
  ///
  @override
  T valueAt(int index, List<T> values) => values != null && values.isNotEmpty ? values.last : null;
}
