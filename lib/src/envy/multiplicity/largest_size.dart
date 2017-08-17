import 'dart:math' show max;
import 'multiplicity.dart';
import '../envy_property.dart';

class LargestSize extends Multiplicity {
  LargestSize();

  int sizeOf(Iterable<EnvyProperty> props) {
    int largest = 0;
    for (var prop in props) {
      //print("raw size = ${prop.rawSize}... ${prop}... optional ${prop.optional}... ${prop.payload}");
      if (!prop.optional) largest = max(largest, prop.rawSize);
    }

    return largest;
  }
}
