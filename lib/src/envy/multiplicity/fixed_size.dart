import '../envy_property.dart';
import 'multiplicity.dart';

class FixedSize extends Multiplicity {
  FixedSize(this.size);

  final int size;

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) => size;
}
