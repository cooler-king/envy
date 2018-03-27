import '../envy_property.dart';
import 'multiplicity.dart';

class FixedSize extends Multiplicity {
  final int size;

  FixedSize(this.size);

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) => size;
}
