import 'dart:math';
import 'number_source.dart';

/// Generates a random number in the range defined by two numerical data sources.
class RandomNumber extends NumberSource {
  /// Constructs a instance.
  RandomNumber(this.minSource, this.maxSource);

  final Random _generator = Random(DateTime.now().millisecond);

  /// The numerical data source for the minimum value of the range.
  final NumberSource minSource;

  /// The numerical data source for the maximum value of the range.
  final NumberSource maxSource;

  @override
  num valueAt(int index) {
    final minValue = minSource.valueAt(index) ?? 0;
    return minValue + _generator.nextDouble() * ((maxSource.valueAt(index) ?? 1) - minValue);
  }

  @override
  int get rawSize => max(minSource.rawSize, maxSource.rawSize);

  // No-op refresh.
  @override
  void refresh() {}
}
