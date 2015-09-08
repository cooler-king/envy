part of envy;

class LargestSize extends Multiplicity {
  LargestSize();

  int sizeOf(Iterable<EnvyProperty> props) {
    int largest = -1;
    for (var prop in props) {
      //print("raw size = ${prop.rawSize}... ${prop}");
      largest = Math.max(largest, prop.rawSize);
    }

    return largest;
  }
}
