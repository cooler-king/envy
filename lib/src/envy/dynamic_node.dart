import 'dart:collection';
import 'envy_property.dart';
import 'multiplicity/multiplicity.dart';

/// Anything with updatable Envy Properties is Dynamic.
/// This class is meant to be used as a Mixin.
mixin DynamicNode {
  /// Properties -- self-optimizing.
  final HashMap<String, EnvyProperty<dynamic>> properties = new HashMap<String, EnvyProperty<dynamic>>();

  /// The size of the values array.
  int size = 0;

  /// The size of the values array in the previous update cycle.
  int prevSize = 0;

  /// Updates all property values.
  void updateProperties(num timeFraction, {bool finish = false}) {
    for (final EnvyProperty<dynamic> prop in properties.values) {
      prop.updateValues(timeFraction, finish: finish);
    }
  }

  /// Properties may contribute lists of values of various sizes.
  /// The [multiplicity] controls how those lengths are interpreted
  /// when determining how many DOM nodes or graphics are created.
  Multiplicity get multiplicity => _multiplicity ?? Multiplicity.defaultMultiplicity;
  Multiplicity _multiplicity;
  set multiplicity(Multiplicity m) {
    _multiplicity = m;
  }

  void _refreshDataSources() {
    for (final EnvyProperty<dynamic> envyProp in properties.values) {
      envyProp.refreshDataSources();
    }
  }

  void _updateSize() {
    prevSize = size;
    size = multiplicity.sizeOf(properties.values);
  }

  /// Prepares the node's properties for the next animation cycle.
  void preparePropertiesForAnimation() {
    _refreshDataSources();
    _updateSize();
    for (final EnvyProperty<dynamic> prop in properties.values) {
      prop.preparePropertyForAnimation(size);
    }
  }
}
