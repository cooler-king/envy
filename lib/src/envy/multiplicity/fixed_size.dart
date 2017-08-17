import 'multiplicity.dart';
import '../envy_property.dart';

class FixedSize extends Multiplicity {
  final int size;

  FixedSize(this.size);

  int sizeOf(Iterable<EnvyProperty> props) => size;
}
