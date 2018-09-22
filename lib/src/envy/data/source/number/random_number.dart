import 'dart:math';
import 'number_source.dart';

class RandomNumber extends NumberSource {
  final Random generator = new Random(new DateTime.now().millisecond);

  NumberSource minSource;
  NumberSource maxSource;

  RandomNumber(this.minSource, this.maxSource);

  @override
  num valueAt(int index) {
    final num minValue = minSource.valueAt(index);
    return minValue + generator.nextDouble() * (maxSource.valueAt(index) - minValue);
  }

  @override
  int get rawSize => max(minSource.rawSize, maxSource.rawSize);

  // No-op refresh
  @override
  void refresh() {}
}
