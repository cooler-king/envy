import 'dart:math' show Random;
import 'extrapolation.dart';

/// Extrapolates from existing data by randomly sampling existing values
/// for each new index and returning one of them .
class RandomSample<T> extends Extrapolation<T> {
  /// Constructs a new instance.
  RandomSample() : super('randomSample', 'Randomly sample the existing values');

  final Random _r = new Random(new DateTime.now().millisecondsSinceEpoch);

  /// Returns one of the current [values], randomly selected; [index] is not used.
  /// If [values] is null or empty, null will be returned.
  @override
  T valueAt(int index, List<T> values) =>
      values != null && values.isNotEmpty ? values[_r.nextInt(values.length)] : null;
}
