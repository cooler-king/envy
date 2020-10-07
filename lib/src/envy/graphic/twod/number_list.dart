import 'package:collection/collection.dart';

/// A numerical list.
class NumberList extends DelegatingList<num> {
  /// Constructs a instance.
  NumberList([Iterable<num> numbers]) : super(List<num>.from(numbers ?? <num>[]));

  /// Adds [value] to the end of the list.
  void addNumber(num value) => add(value);

  /// Adds [numbers] to the end of the list.
  void addNumbers(Iterable<num> numbers) => addAll(numbers);

  /// The minimum value in the list.
  num get min {
    if (isEmpty) return double.nan;
    num x = double.infinity;
    for (final n in this) {
      if (n < x) x = n;
    }
    return x;
  }

  /// The maximum value in the list.
  num get max {
    if (isEmpty) return double.nan;
    num x = double.negativeInfinity;
    for (final num n in this) {
      if (n > x) x = n;
    }
    return x;
  }
}
