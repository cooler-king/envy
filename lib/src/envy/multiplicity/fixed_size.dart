import '../envy_property.dart';
import 'multiplicity.dart';

/// Implements a fixed size multiplicity that returns the same size
/// regardless of the raw sizes of a set of properties.
class FixedSize extends Multiplicity {
  /// Constructs a instance.
  FixedSize(this.size);

  /// The fixed size.
  final int size;

  @override
  int sizeOf(Iterable<EnvyProperty<dynamic>> props) => size;
}
