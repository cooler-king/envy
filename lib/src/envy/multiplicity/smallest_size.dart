import 'dart:math' show min;
import '../envy_property.dart';
import 'multiplicity.dart';

class SmallestSize extends Multiplicity {
  SmallestSize();

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) {
    if (props.isEmpty) return 0;

    int smallest = 99999999;
    for (EnvyProperty<dynamic> prop in props) {
      smallest = min(smallest, prop.rawSize);
    }

    return smallest;
  }
}
