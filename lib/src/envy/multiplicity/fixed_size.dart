part of envy;

class FixedSize extends Multiplicity {
  final int size;

  FixedSize(this.size);

  int sizeOf(Iterable<EnvyProperty> props) => size;
}
