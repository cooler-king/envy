part of envy;

/// Retrieves angle data (a list of Angles or a single Angle)
/// from a named dataset.
///
class AngleData extends ArrayDataSource<Angle> implements AngleSource {
  String _datasetName;
  EnvyNode _node;
  DataAccessor accessor;

  /// Find the dataset named [datasetName], starting with [node] and working
  /// up the ancestor chain, and use the [accessor] to select data from that
  /// dataset.
  ///
  /// If [prop] is provided instead of [accessor] then a property DataAccessor
  /// will be constructed and used.
  ///
  /// If both [accessor] and [prop] are provided, [accessor] is used.
  ///
  /// If neither [accessor] and [prop] are provided then the dataset is used
  /// as a whole.
  ///
  AngleData(this._datasetName, this._node, {this.accessor, String prop}) {
    if (prop != null && accessor == null) {
      accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  AngleData.keyed(KeyedDataset keyedDataset, String prop) {
    if (prop != null && keyedDataset != null) {
      this._datasetName = keyedDataset.name;
      this._node = keyedDataset.node;
      accessor = new DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  void refresh() {
    this.values.clear();

    Object data = _node.getDataset(_datasetName);
    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data is List<Angle>) {
      this.values.addAll(data);
    } else if (data is Angle) {
      this.values.add(data);
    } else {
      // Warn and do best to convert to number
      _LOG.warning("Unexpected data type for AngleData: ${data}");
      if (data is List) {
        // try to parse entires as numbers; assume degrees
        for (var d in data) {
          this.values.add(_angleFromAnything(d));
        }
      } else {
        this.values.add(_angleFromAnything(data));
      }
    }
  }

  Angle _angleFromAnything(dynamic d) {
    if (d is Angle) return d;

    if (d is num) {
      // Assume degrees
      return new Angle(deg: d);
    } else {
      try {
        num val = num.parse(d.toString());
        return new Angle(deg: val);
      } catch (e) {
        return angle0;
      }
    }
  }
}
