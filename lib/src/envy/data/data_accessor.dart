import 'dart:collection';
import '../util/logger.dart';

/// DataAccessor provides a road map into a dataset to select a
/// specific property within a map or index in an array.
///
/// See the `parse` constructor for examples of how to construct
/// a multi-step accessor.
class DataAccessor {
  /// Constructs a new instance, with a single index.
  DataAccessor.index(int index) {
    if (index != null) steps.add(new Indices.single(index));
  }

  /// Constructs a new instance, with an index range.
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
  ///
  /// ```
  /// [5]
  /// [10-100]
  /// [4, 7, 8, 12]
  /// [*]
  /// [5-9, 20-24, 87]
  /// ```
  ///
  /// Map properties are specified by a single String that must
  /// exactly match the property name within the Map.
  ///
  /// If the first accessor step is a map property but the dataset is a
  /// list, a [`*`] is prepended for convenience.
  ///
  /// If an accessor step indicates a Map property but the data is a List of
  /// Maps (instead of just a Map), a [`*`] operation is assumed for the list.
  /// That is, as a convenience, [`*`] may be omitted.
  ///
  /// Full examples:
  ///
  /// Extract the value of 'x' from every Map in a List of Maps.
  /// '[`*`].x'
  /// 'x'
  ///
  /// To attempt to preserve the order of values extracted from a List
  /// of Maps that have a key that provides a unique identity, add a slash
  /// after the property name and then the name of the property that
  /// serves as the key for each Map object.
  ///
  /// Example:
  ///
  /// Extract the value for 'x' from each Map in a List of Maps, but
  /// preserve ordering of the data based on the value for 'id' in each Map:
  /// 'x/id'
  ///
  /// The enables smooth transitions of display elements that represent a
  /// specific data element.
  /// TODO:  allow property lists? (comma separated)
  DataAccessor.parse(String accessPath) {
    if (accessPath == null) return;
    try {
      final List<String> accessSteps = accessPath.split('.');
      for (String step in accessSteps) {
        if (step.startsWith('[') && step.endsWith(']')) {
          final Indices ind = new Indices.parse(step.substring(1, step.length - 1));
          if (ind != null) steps.add(ind);
        } else {
          final int slashIndex = step.indexOf('/');
          if (slashIndex == -1) {
            steps.add(step.trim());
          } else {
            steps.add(new KeyedProperty(step.substring(0, slashIndex).trim(), step.substring(slashIndex + 1)));
          }
        }
      }
    } catch (e, s) {
      logger.severe('Problem parsing accessPath:  $accessPath', e, s);
    }
  }

  /// A list of [Indices], [KeyedProperty]s and/or Strings, where ints indicate an index into
  /// an array and String indicate a property in a map.
  final List<dynamic> steps = <dynamic>[];

  /// Keep track of any keyed property ordering (key prop -> map of key value to index).
  /// Note that Map literals are ordered (not necessary to use LinkedHashMap).
  final Map<String, Map<dynamic, int>> propOrderingMap = <String, Map<dynamic, int>>{};

  /// Keeps a record of which indices lack data.
  /// Implemented as a Map for efficient lookup (the value is not used).
  final Map<int, bool> dataUnavailableIndices = <int, bool>{};

  /// Returns the data in [dataset] referenced by this accessor.
  Object getData(Object dataset) {
    if (dataset == null) return null;

    dynamic dataCursor = dataset;
    for (dynamic step in steps) {
      if (dataCursor is List<Map<dynamic, dynamic>>) {
        List<dynamic> dataList = <dynamic>[];
        if (step is! Indices || (step as Indices).isAll) {
          // Shortcut! (Assume [*] for List of Maps when
          // no indices are provided)
          if (step is String) {
            for (Map<dynamic, dynamic> m in dataCursor) {
              dataList.add(m[step]);
            }
            dataCursor = dataList;
          } else if (step is KeyedProperty) {
            final String stepProp = step.property;
            final String stepKeyProp = step.keyProp;
            Map<dynamic, int> keyValueIndexMap = propOrderingMap[stepProp];
            if (keyValueIndexMap == null) {
              // First time; save the initial ordering
              keyValueIndexMap = <dynamic, int>{}; // Map literals are ordered  //key value to index???
              propOrderingMap[stepProp] = keyValueIndexMap;

              // List of key values ... null out and append as necessary
              // special value for exited?
              int index = 0;
              for (Map<dynamic, dynamic> m in dataCursor) {
                keyValueIndexMap[m[stepKeyProp]] = index;
                dataList.add(m[stepProp]);
                index++;
              }
              dataCursor = dataList;
            } else {
              // Populate the values in the data list using previous order
              //TODO create this list as class variable and grow as necessary
              //dataList = new List<dynamic>.filled(keyValueIndexMap.length, null, growable: true);

              dataList = <dynamic>[];
              for (int i = 0; i < keyValueIndexMap.length; i++) {
                dataList.add(null);
              }

              dataUnavailableIndices.clear();
              for (int i = 0; i < dataList.length; i++) {
                dataUnavailableIndices[i] = true;
              }

              int index;
              for (Map<dynamic, dynamic> m in dataCursor) {
                final dynamic keyValue = m[stepKeyProp];
                index = keyValueIndexMap[keyValue];
                if (index == null) {
                  // Found a new key value, add it to keyValueIndexMap
                  index = keyValueIndexMap.length;
                  keyValueIndexMap[keyValue] = index;
                  dataList.add(m[stepProp]);
                } else {
                  dataList[index] = m[stepProp];
                  dataUnavailableIndices.remove(index);
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
          throw new StateError('Unable to apply access step ($step) to data ($dataCursor)');
        }
      } else if (dataCursor is List) {
        final List<dynamic> dataList = <dynamic>[];
        if (step is Indices) {
          for (int i in step.values) {
            dataList.add(dataCursor[i]);
          }
          dataCursor = dataList;
        } else {
          throw new StateError('Unable to apply property access step ($step) to non-Map List');
        }
      } else {
        // primitive (String, num, or bool) -- no accessor allowed
        throw new StateError('Unable to apply access step ($step) to primitive data type (${dataCursor.runtimeType})');
      }
    }

    //_lastData = dataCursor;
    return dataCursor;
  }

  /// Removes any `dataNotAvailable` entries from the propOrderingMaps and adjusts indices as necessary.
  void cullUnavailableData() {
    for (String propKey in propOrderingMap.keys) {
      final LinkedHashMap<dynamic, int> m = propOrderingMap[propKey];

      final Iterable<dynamic> keysToRemove = m.keys.where((dynamic key) => dataUnavailableIndices.containsKey(m[key]));

      // If no removals, no need for compaction.
      if (keysToRemove.isEmpty) continue;

      //new List<dynamic>.from(keysToRemove).forEach(m.remove);
      keysToRemove.forEach(m.remove);

      // Sort keys by index
      final List<dynamic> list = new List<dynamic>.from(m.keys)..sort((dynamic a, dynamic b) => m[a].compareTo(m[b]));

      // Change indices to consecutive positive integers
      int index = 0;
      for (dynamic key in list) {
        m[key] = index++;
      }
    }
  }
}

/// Represents some combination of individual indices and index ranges, or all indices.
class Indices {
  /// Constructs a new instance, with a single index.
  Indices.single(int index) {
    _list.add(index);
  }

  /// Constructs a new instance, with an index range.
  Indices.range(int minIndex, int maxIndex) {
    _list.add(<int>[minIndex, maxIndex]);
  }

  /// Constructs a new instance that indicates the full collection should be used.
  Indices.all() {
    _all = true;
  }

  /// Constructs a new instance by parsing an Indices string.
  Indices.parse(String str) {
    try {
      final List<String> list = str.split(',');
      for (String s in list) {
        final List<String> intList = s.split('-');
        if (intList.isEmpty) {
          throw new Exception('No indices found');
        } else if (intList.length == 1) {
          addIndex(int.parse(intList.first.trim()));
        } else if (intList.length == 2) {
          addRange(int.parse(intList.first.trim()), int.parse(intList.last.trim()));
        } else {
          throw new Exception('Malformed indices string');
        }
      }
    } catch (e, s) {
      logger.severe('Unable to parse indices string \'$str\'', e, s);
    }
  }

  /// Holds integers and/or List<int> objects.
  final List<dynamic> _list = <dynamic>[];

  bool _all = false;

  /// Whether all values should be used.
  bool get isAll => _all;

  /// Returns a flat list of all of the indices.
  List<int> get values {
    final List<int> indexList = <int>[];
    for (dynamic v in _list) {
      if (v is int) {
        indexList.add(v);
      } else if (v is List<int>) {
        indexList.addAll(v);
      }
    }
    return indexList;
  }

  /// Adds a single index.
  void addIndex(int index) {
    _list.add(index);
  }

  /// Adds a new index range.
  void addRange(int minIndex, int maxIndex) {
    _list.add(<int>[minIndex, maxIndex]);
  }
}

/// A [KeyedProperty] accessor step provides a way to extract values from a Map while attempting to preserve
/// ordering on subsequent accesses with respect to the Map values for [keyProp].
class KeyedProperty {
  /// Constructs a new instance.
  KeyedProperty(this.property, this.keyProp);

  /// The name of the property.
  final String property;

  /// The key property used to access a single entry in a list of maps.
  final String keyProp;
}
