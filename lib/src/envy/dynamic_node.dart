part of envy;

/// Anything with updatable Envy Properties is Dynamic.
///
/// This class is meant to be used as a Mixin.
///
class DynamicNode {

  // Properties -- self-optimizing
  final HashMap<String, EnvyProperty> properties = new HashMap<String, EnvyProperty>();

  /// Properties may contribute lists of values of various sizes.
  /// The [multiplicity] controls how those lengths are interpreted
  /// when determining how many DOM nodes or graphics are created.
  ///
  Multiplicity _multiplicity;

  int _size = 0;
  int _prevSize = 0;

  /// Update all property values.
  ///
  void updateProperties(num timeFraction, {bool finish: false}) {
    //print("${this} dynamic update properties ${timeFraction}");
    //int count = size;
    //properties.values.forEach((EnvyProperty prop) {
    for (var prop in properties.values) {
      //print("dynamic update properties prop = ${prop}");
      prop.updateValues(timeFraction, finish: finish);
      //print("dynamic update properties prop = ${prop} DONE");
    }
    //print("dynamic update properties LEAVING");

  }

  Multiplicity get multiplicity => _multiplicity != null ? _multiplicity : Multiplicity.defaultMultiplicity;

  void set multiplicity(Multiplicity m) {
    _multiplicity = m;
  }

  int get size => _size;

  //int get size => multiplicity.sizeOf(properties.values);

  void _refreshDataSources() {
    for (var envyProp in properties.values) {
      envyProp._refreshDataSources();
    }
  }

  void _updateSize() {
    _prevSize = _size;
    _size = multiplicity.sizeOf(properties.values);
    //print("${this} SIZE/PREV... ${_size}/${_prevSize}");
  }

  void _preparePropertiesForAnimation() {
    _refreshDataSources();
    _updateSize();
    for (var prop in properties.values) {
      prop._preparePropertyForAnimation(_size);
    }
  }
}
