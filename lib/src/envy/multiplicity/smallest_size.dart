part of envy;

class SmallestSize extends Multiplicity {
  SmallestSize();

  int sizeOf(Iterable<EnvyProperty> props) {
    if (props.isEmpty) return 0;

    int smallest = 99999999;
    for (var prop in props) {
      smallest = Math.min(smallest, prop.rawSize);
    }

    return smallest;
  }
}
