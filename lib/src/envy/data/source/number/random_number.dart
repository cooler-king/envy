import 'dart:math' as Math;
import 'number_source.dart';

class RandomNumber extends NumberSource {
  final Math.Random generator = new Math.Random(new DateTime.now().millisecond);

  NumberSource min;
  NumberSource max;

  RandomNumber(this.min, this.max);

  num valueAt(int i) {
    num minValue = min.valueAt(i);
    return minValue + generator.nextDouble() * (max.valueAt(i) - minValue);
  }

  int get rawSize => Math.max(min.rawSize, max.rawSize);

  // No-op refresh
  void refresh() {}
}
