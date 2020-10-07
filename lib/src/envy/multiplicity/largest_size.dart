import 'dart:math' show max;
import '../envy_property.dart';
import 'multiplicity.dart';

/// Finds the largest raw size of a set of properties.
/// Implemented as a singleton.
class LargestSize extends Multiplicity {
  /// Returns the singleton instance.
  factory LargestSize() => _instance ??= LargestSize._internal();

  LargestSize._internal();

  // The singleton instance.
  static LargestSize _instance;

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) {
    int largest = 0;
    for (final EnvyProperty<dynamic> prop in props) {
      if (prop.optional != true) largest = max(largest, prop.rawSize);
    }

    return largest;
  }
}
