import '../../../envy_node.dart';
import '../../../graphic/twod/number_list.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'number_list_source.dart';

/// Retrieves NumberList data from a named dataset.
///
class NumberListData extends ArrayDataSource<NumberList> implements NumberListSource {
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
  ///
  NumberListData(this._datasetName, this._node, {DataAccessor accessor, String prop}) {
    this.accessor = accessor ?? (prop != null ? DataAccessor.prop(prop) : null);
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  ///
  NumberListData.keyed(KeyedDataset keyedDataset, String prop) {
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

    if (data is List) {
      for (final dynamic d in data) {
        if (d is List<dynamic>) {
          values.add(NumberList(d as List<num>));
        } else if (d is NumberList) {
          values.add(d);
        }
      }
    } else if (data is NumberList) {
      values.add(data);
    } else if (data is List<num>) {
      values.add(NumberList(data));
    } else {
      // Warn and return empty NumberList
      logger.warning('Unexpected data type for NumberListData: $data');
      values.add(NumberList());
    }
  }
}
