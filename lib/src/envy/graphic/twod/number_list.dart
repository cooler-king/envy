import 'package:collection/collection.dart';

class NumberList extends DelegatingList<num> {
  NumberList([Iterable<num> numbers]) : super(new List<num>.from(numbers ?? []));

  void addNumber(num value) => add(value);

  void addNumbers(Iterable<num> numbers) => addAll(numbers);

  //----------------

  num get min {
    if (isEmpty) return double.NAN;
    num x = double.INFINITY;
    for (var n in this) {
      if (n < x) x = n;
    }
    return x;
  }

  num get max {
    if (isEmpty) return double.NAN;
    num x = double.NEGATIVE_INFINITY;
    for (var n in this) {
      if (n > x) x = n;
    }
    return x;
  }
}
