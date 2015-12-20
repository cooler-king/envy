part of envy;

/// Retrieves NumberList data from a named dataset.
///
class NumberListData extends ArrayDataSource<NumberList> implements NumberListSource {
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
  NumberListData(this._datasetName, this._node, {this.accessor, String prop}) {
    if (prop != null && accessor == null) {
      accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  NumberListData.keyed(KeyedDataset keyedDataset, String prop) {
    if (prop != null && keyedDataset != null) {
      this._datasetName = keyedDataset.name;
      this._node = keyedDataset.node;
      accessor = new DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  @override
  void refresh() {
    this.values.clear();

    Object data = _node.getDataset(_datasetName);
    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data is List) {
      for(var d in data) {
        if(d is List<num>) {
          this.values.add(new NumberList(d));
        } else if(d is NumberList) {
          this.values.add(d);
        }
      }
    } else if (data is NumberList) {
      this.values.add(data);
    } else if (data is List<num>) {
      this.values.add(new NumberList(data));
    } else {
      // Warn and return empty NumberList
      _LOG.warning("Unexpected data type for NumberListData: ${data}");
      this.values.add(new NumberList());
    }
  }
}
