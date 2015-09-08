part of envy;

/// Retrieves drawing style data (a list of drawing styles or a single
/// drawing style) from a named dataset.
///
class DrawingStyle2dData extends ArrayDataSource<DrawingStyle2d> implements DrawingStyle2dSource {
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
  DrawingStyle2dData(this._datasetName, this._node, {this.accessor, String prop}) {
    if (prop != null && accessor == null) {
      accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  DrawingStyle2dData.keyed(KeyedDataset keyedDataset, String prop) {
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

    if (data is List<DrawingStyle2d>) {
      this.values.addAll(data);
    } else if (data is DrawingStyle2d) {
      this.values.add(data);
    } else {
      // warn and do best to convert to number
      _LOG.warning("Unexpected data type for DrawingStyle2dData: ${data}");
    }
  }
}
