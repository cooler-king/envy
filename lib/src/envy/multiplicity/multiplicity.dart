import '../envy_property.dart';
import 'largest_size.dart';

/// The abstract base class for all multiplicity strategies.
abstract class Multiplicity {
  /// The default multiplicity takes the largest raw size of all
  /// of its properties and uses that as the size.
  static final Multiplicity defaultMultiplicity = new LargestSize();

  /// Finds the effective size of a set of properties, applying specific rules.
  int sizeOf(Iterable<EnvyProperty<dynamic>> props);
}
