part of envy;

/// DataAccessor provides a road map into a dataset to select a
/// specific property within a map or index in an array.
///
/// See the [parse] constructor for examples of how to construct
/// a multi-step accessor.
///
class DataAccessor {
  /// A list of [Indices] and/or Strings, where ints indicate an index into
  /// an array and String indicate a property in a map.
  final List steps = [];

  /// Keep track of any keyed property ordering (key prop -> map of key value to index)
  final Map<String, LinkedHashMap<dynamic, int>> propOrderingMap = new Map<String, LinkedHashMap<dynamic, int>>();

  dynamic _lastData;

  DataAccessor.index(int index) {
    if (index != null) steps.add(new Indices.single(index));
  }

  DataAccessor.range(int minIndex, int maxIndex) {
    if (minIndex != null && maxIndex != null) steps.add(new Indices.range(minIndex, maxIndex));
  }

  /// Accesses a value in a map by identifying the [property]
  /// within the map that holds the value.
  ///
  /// If the accessor is used on a List of Maps and a [keyProp]
  /// is provided, then the ordering of the returned data will
  /// be consistent with respect to the values provided by
  /// key property.
  ///
  DataAccessor.prop(String property, {String keyProp}) {
    if (property != null) {
      if (keyProp != null) {
        steps.add(new KeyedProperty(property, keyProp));
      } else {
        steps.add(property);
      }
    }
  }

  /// Parses a String representing an access path.
  ///
  /// Any combination of indices into an array and properties
  /// of a map, separated by dots is supported.
  ///
  /// Indices are specified in square brackets.  Use a dash to indicate
  /// a range of indices, commas to include more than one index or range,
  /// and the asterisk wildcard to indicate an entire array.  Examples:
  /// [5]
  /// [10-100]
  /// [4, 7, 8, 12]
  /// [*]
  /// [5-9, 20-24, 87]
  ///
  /// Map properties are specified by a single String that must
  /// exactly match the property name within the Map.
  ///
  /// If the first accessor step is a map property but the dataset is a
  /// list, a [*] is prepended for convenience.
  ///
  /// If an accessor step indicates a Map property but the data is a List of
  /// Maps (instead of just a Map), a [*] operation is assumed for the list.
  /// That is, as a convenience, [*] may be omitted.
  ///
  /// Full examples:
  ///
  /// Extract the value of "x" from every Map in a List of Maps.
  /// "[*].x"
  /// "x"
  ///
  /// To attempt to preserve the order of values extracted from a List
  /// of Maps that have a key that provides a unique identity, add a slash
  /// after the property name and then the name of the property that
  /// serves as the key for each Map object.
  ///
  /// Example:
  ///
  /// Extract the value for "x" from each Map in a List of Maps, but
  /// preserve ordering of the data based on the value for "id" in each Map:
  /// "x/id"
  ///
  /// The enables smooth transitions of display elements that represent a
  /// specific data element.
  ///
  /// TODO:  allow property lists? (comma separated)
  ///
  DataAccessor.parse(String accessPath) {
    if (accessPath == null) return;
    try {
      List<String> accessSteps = accessPath.split(".");
      for (var step in accessSteps) {
        if (step.startsWith("[") && step.endsWith("]")) {
          var ind = new Indices.parse(step.substring(1, step.length - 1));
          if (ind != null) steps.add(ind);
        } else {
          int slashIndex = step.indexOf("/");
          if (slashIndex == -1) {
            steps.add(step.trim());
          } else {
            steps.add(new KeyedProperty(step.substring(0, slashIndex).trim(), step.substring(slashIndex + 1)));
          }
        }
      }
    } catch (e, s) {
      _LOG.severe("Problem parsing accessPath:  ${accessPath}", e, s);
    }
  }

  /// Returns the data in [dataset] referenced by this accessor.
  ///
  Object getData(Object dataset) {
    if (dataset == null) return null;

    var dataCursor = dataset;
    for (var step in steps) {
      if (dataCursor is List<Map>) {
        List dataList = [];
        if (step is! Indices || step.isAll) {
          // Shortcut! (Assume [*] for List of Maps when
          // no indices are provided)
          if (step is String) {
            for (Map m in dataCursor) {
              dataList.add(m[step]);
            }
            dataCursor = dataList;
          } else if (step is KeyedProperty) {
            String stepProp = step.property;
            String stepKeyProp = step.keyProp;
            var keyValueIndexMap = propOrderingMap[stepProp];
            if (keyValueIndexMap == null) {
              // First time; save the initial ordering
              keyValueIndexMap = new LinkedHashMap<dynamic, int>(); //key value to index???
              propOrderingMap[stepProp] = keyValueIndexMap;

              // List of key values ... null out and append as necessary
              // special value for exited?
              int index = 0;
              for (Map m in dataCursor) {
                keyValueIndexMap[m[stepKeyProp]] = index;
                dataList.add(m[stepProp]);
                index++;
              }
              dataCursor = dataList;
            } else {
              // Populate the values in the data list using previous order
              //TODO create this list as class variable and grow as necessary
              dataList = new List.generate(keyValueIndexMap.length, (i) => dataNotAvailable, growable: true);
              int index;
              for (Map m in dataCursor) {
                var keyValue = m[stepKeyProp];
                index = keyValueIndexMap[keyValue];
                if (index == null) {
                  // Found a new key value, add it to keyValueIndexMap
                  index = keyValueIndexMap.length;
                  keyValueIndexMap[keyValue] = index;
                  dataList.add(m[stepProp]);
                } else {
                  dataList[index] = m[stepProp];
                }
              }
              dataCursor = dataList;
            }
          }
        } else {
          // Indices
          for (int i in step.values) {
            dataList.add(dataCursor[i]);
          }
          dataCursor = dataList;
        }
      } else if (dataCursor is Map) {
        if (step is String) {
          dataCursor = dataCursor[step];
        } else if (step is KeyedProperty) {
          dataCursor = dataCursor[step.property];
        } else {
          throw new StateError("Unable to apply access step (${step}) to data (${dataCursor})");
        }
      } else if (dataCursor is List) {
        List dataList = [];
        if (step is Indices) {
          for (int i in step.values) {
            dataList.add(dataCursor[i]);
          }
          dataCursor = dataList;
        } else {
          throw new StateError("Unable to apply property access step (${step}) to non-Map List");
        }
      } else {
        // primitive (String, num, or bool) -- no accessor allowed
        throw new StateError(
            "Unable to apply access step (${step}) to primitive data type (${dataCursor.runtimeType})");
      }
    }

    _lastData = dataCursor;
    return dataCursor;
  }

  /// Removes any [dataNotAvailable] entries from the propOrderingMaps and adjusts indices
  /// as necessary.
  ///
  void cullUnavailableData() {
    if (propOrderingMap.isEmpty) return;
    List keysToRemove = [];
    for (var propKey in propOrderingMap.keys) {
      Map m = propOrderingMap[propKey];

      // Remove dataNotAvailable entries
      keysToRemove.clear();
      for (var key in m.keys) {
        if (_lastData[m[key]] == dataNotAvailable) {
          keysToRemove.add(key);
        }
      }

      // If no removals no need for compaction
      if (keysToRemove.isEmpty) continue;
      for (var k in keysToRemove) {
        m.remove(k);
      }

      // Sort keys by index
      var list = new List.from(m.keys);
      list.sort((a, b) => m[a].compareTo(m[b]));

      // Change indices to consecutive positive integers
      int index = 0;
      for (var key in list) {
        m[key] = index++;
      }
    }
  }
}

/// Represents some combination of individual indices and index ranges, or all
/// indices.
///
class Indices {
  // Holds ints and/or List<int>
  List _list = [];

  bool _all = false;

  Indices.single(int index) {
    _list.add(index);
  }

  Indices.range(int minIndex, int maxIndex) {
    _list.add([minIndex, maxIndex]);
  }

  Indices.all() {
    _all = true;
  }

  Indices.parse(String str) {
    try {
      List<String> list = str.split(",");
      for (String s in list) {
        List<String> intList = s.split("-");
        if (intList.isEmpty) {
          throw ("No indices found");
        } else if (intList.length == 1) {
          addIndex(int.parse(intList.first.trim()));
        } else if (intList.length == 2) {
          addRange(int.parse(intList.first.trim()), int.parse(intList.last.trim()));
        } else {
          throw "Malformed indices string";
        }
      }
    } catch (e, s) {
      _LOG.severe("Unable to parse indices string '${str}'", e, s);
    }
  }

  bool get isAll => _all;

  List<int> get values {
    List<int> indexList = [];
    for (var v in _list) {
      if (v is int) {
        indexList.add(v);
      } else if (v is List<int>) {
        indexList.addAll(v);
      }
    }
    return indexList;
  }

  void addIndex(int index) {
    _list.add(index);
  }

  void addRange(int minIndex, int maxIndex) {
    _list.add([minIndex, maxIndex]);
  }
}

/// A [KeyedProperty] accessor step provides a way
/// to extract values from a Map while attempting to preserve
/// ordering on subsequent accesses with repect to the
/// Map values for [keyProp].
///
class KeyedProperty {
  final String property;
  final String keyProp;

  KeyedProperty(this.property, this.keyProp);
}
