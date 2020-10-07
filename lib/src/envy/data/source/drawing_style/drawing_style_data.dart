import '../../../envy_node.dart';
import '../../../graphic/twod/drawing_style2d.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'drawing_style_source.dart';

/// Retrieves drawing style data (a list of drawing styles or a single
/// drawing style) from a named dataset.
class DrawingStyle2dData extends ArrayDataSource<DrawingStyle2d> implements DrawingStyle2dSource {
  /// Find the dataset named [_datasetName], starting with [_node] and working
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
  DrawingStyle2dData(this._datasetName, this._node, {DataAccessor dataAccessor, String prop}) {
    accessor = dataAccessor;
    if (prop != null && accessor == null) {
      accessor = DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  DrawingStyle2dData.keyed(KeyedDataset keyedDataset, String prop) {
    if (prop != null && keyedDataset != null) {
      _datasetName = keyedDataset.name;
      _node = keyedDataset.node;
      accessor = DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  String _datasetName;
  EnvyNode _node;

  @override
  void refresh() {
    values.clear();

    var data = _node.getDataset(_datasetName);
    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data is List<dynamic>) {
      values.addAll(data.whereType<DrawingStyle2d>());
    } else if (data is DrawingStyle2d) {
      values.add(data);
    } else {
      logger.warning('Unexpected data type for DrawingStyle2dData: $data');
    }
  }
}
