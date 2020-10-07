import 'dart:math' show min;
import '../envy_property.dart';
import 'multiplicity.dart';

/// Finds the smallest raw value size of a set of properties.
/// Implemented as a singleton.
class SmallestSize extends Multiplicity {
  /// Returns the singleton instance.
  factory SmallestSize() => _instance ??= SmallestSize._internal();

  SmallestSize._internal();

  // The singleton instance.
  static SmallestSize _instance;

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) {
    var smallest = 99999999;
    for (final prop in props) {
      smallest = min(smallest, prop.rawSize);
    }

    return smallest;
  }
}
