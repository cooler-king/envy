part of envy;

class LargestSize extends Multiplicity {
  LargestSize();

  int sizeOf(Iterable<EnvyProperty> props) {
    int largest = 0;
    for (var prop in props) {
      //print("raw size = ${prop.rawSize}... ${prop}... optional ${prop.optional}... ${prop.payload}");
      if (!prop.optional) largest = Math.max(largest, prop.rawSize);
    }

    return largest;
  }
}
