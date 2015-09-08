part of envy;

/// Retrieves numerical data (a list of numbers or a single number)
/// from a named dataset.
///
class StringData extends ArrayDataSource<String> implements StringSource {
  String _datasetName;
  EnvyNode _node;
  DataAccessor accessor;

  /// Find the dataset named [datasetName], starting with [node] and working
  /// up the ancestor chain, and use the [accessor] to select data from that
  /// dataset.
  ///
  /// If [prop] is provided instead of [accessor] then a property DataAccesor
  /// will be constructured and used.
  ///
  /// If both [accessor] and [prop] are provided, [accessor] is used.
  ///
  /// If neither [accessor] and [prop] are provided then the dataset is used
  /// as a whole.
  ///
  StringData(this._datasetName, this._node, {this.accessor, String prop}) {
    if (prop != null && accessor == null) {
      accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  StringData.keyed(KeyedDataset keyedDataset, String prop) {
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

    if (data is List<String>) {
      this.values.addAll(data);
    } else if (data is String) {
      this.values.add(data);
    } else {
      // warn and do best to convert to string
      _LOG.warning("Unexpected data type for StringData: ${data}");
      if (data is List) {
        for (Object d in data) {
          this.values.add(d.toString());
        }
      } else {
        this.values.add(data.toString());
      }
    }
  }
}
