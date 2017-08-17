import 'dart:math' show Random;
import 'extrapolation.dart';

class RandomSample<T> extends Extrapolation<T> {
  Random r = new Random(new DateTime.now().millisecondsSinceEpoch);

  RandomSample() : super("randomSample", "Randomly sample the existing values");

  /// Returns one of the current [values], randomly selected; [index] is not used.
  ///
  /// If [values] is null or empty, null will be returned.
  ///
  T valueAt(int index, List<T> values) => values != null && values.isNotEmpty ? values[r.nextInt(values.length)] : null;
}
