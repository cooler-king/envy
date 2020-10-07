import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../../source/data_source.dart';
import 'number_source.dart';

/// Retrieves numerical data (a list of numbers or a single number) from a named dataset.
class NumberData extends ArrayDataSource<num> implements NumberSource {
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
  NumberData(this._datasetName, this._node, {DataAccessor dataAccessor, String prop}) {
    if (prop != null && accessor == null) {
      accessor = DataAccessor.prop(prop);
    } else {
      accessor = dataAccessor;
    }
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  NumberData.keyed(KeyedDataset keyedDataset, String prop) {
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

    Object data = _node.getDataset(_datasetName);

    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data == null) return;

    if (data is List<dynamic>) {
      values.addAll(data.whereType<num>());
    } else if (data is num) {
      values.add(data);
    } else {
      // Warn and do best to convert the data to a number.
      logger.warning('Unexpected data type for NumberData: $data');
      if (data is List) {
        values.add(data.length);
      } else if (data is Map) {
        values.add(data.length);
      } else if (data is bool) {
        values.add(data ? 1 : 0);
      } else {
        values.add(data.toString().length);
      }
    }
  }
}
