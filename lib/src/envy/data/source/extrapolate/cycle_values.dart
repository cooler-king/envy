import 'extrapolation.dart';

class CycleValues<T> extends Extrapolation<T> {
  CycleValues(this.oneWay) : super('cycle', 'Cycle through existing values');

  final bool oneWay;

  /// If index is greater than the length of the values array
  /// the value will be selected using a cycle algorithm.  If [oneWay]
  /// is true, the values will cycle from beginning to end repeatedly.
  /// If [oneWay] is false, the values will cycle from start to end
  /// and then backwards, from end to start.
  ///
  /// If [values] is null or empty, null will be returned.
  ///
  @override
  T valueAt(int index, List<T> values) {
    if (values == null || values.isEmpty) return null;

    if (values.length == 1) return values.first;

    if (oneWay) {
      return values[index % values.length];
    } else {
      int x = index % ((values.length - 1) * 2);
      if (x >= values.length) x = 2 * values.length - 2 - x;
      //print('index/x... ${index}/${x}');
      return values[x];
    }
  }
}
