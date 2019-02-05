import 'dart:math' show max;
import '../envy_property.dart';
import 'multiplicity.dart';

class LargestSize extends Multiplicity {
  LargestSize();

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) {
    int largest = 0;
    for (EnvyProperty<dynamic> prop in props) {
      //print("raw size = ${prop.rawSize}... ${prop}... optional ${prop.optional}... ${prop.payload}");
      if (!prop.optional) largest = max(largest, prop.rawSize);
    }

    return largest;
  }
}
