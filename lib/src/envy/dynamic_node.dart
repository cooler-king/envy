import 'dart:collection';
import 'envy_property.dart';
import 'multiplicity/multiplicity.dart';

/// Anything with updatable Envy Properties is Dynamic.
///
/// This class is meant to be used as a Mixin.
///
class DynamicNode {
  // Properties -- self-optimizing
  final HashMap<String, EnvyProperty<dynamic>> properties = new HashMap<String, EnvyProperty<dynamic>>();

  /// Properties may contribute lists of values of various sizes.
  /// The [multiplicity] controls how those lengths are interpreted
  /// when determining how many DOM nodes or graphics are created.
  ///
  Multiplicity _multiplicity;

  int size = 0;
  int prevSize = 0;

  /// Update all property values.
  ///
  void updateProperties(num timeFraction, {bool finish = false}) {
    //print("${this} dynamic update properties ${timeFraction}");
    //int count = size;
    //properties.values.forEach((EnvyProperty prop) {
    for (EnvyProperty<dynamic> prop in properties.values) {
      //print("dynamic update properties prop = ${prop}");
      prop.updateValues(timeFraction, finish: finish);
      //print("dynamic update properties prop = ${prop} DONE");
    }
    //print("dynamic update properties LEAVING");
  }

  Multiplicity get multiplicity => _multiplicity ?? Multiplicity.defaultMultiplicity;

  set multiplicity(Multiplicity m) {
    _multiplicity = m;
  }

  //int get size => multiplicity.sizeOf(properties.values);

  void _refreshDataSources() {
    for (EnvyProperty<dynamic> envyProp in properties.values) {
      envyProp.refreshDataSources();
    }
  }

  void _updateSize() {
    prevSize = size;
    size = multiplicity.sizeOf(properties.values);
    //print("${this} SIZE/PREV... ${_size}/${_prevSize}");
  }

  void preparePropertiesForAnimation() {
    _refreshDataSources();
    _updateSize();
    for (EnvyProperty<dynamic> prop in properties.values) {
      prop.preparePropertyForAnimation(size);
    }
  }
}
