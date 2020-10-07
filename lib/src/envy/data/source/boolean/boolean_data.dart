import 'package:quantity/quantity.dart' show Quantity;
import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'boolean_source.dart';

/// Retrieves boolean data (a list of bools or a single bool)
/// from a named dataset.
class BooleanData extends ArrayDataSource<bool> implements BooleanSource {
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
  BooleanData(this._datasetName, this._node, {DataAccessor dataAccessor, String prop}) {
    accessor = dataAccessor;
    if (prop != null && accessor == null) {
      accessor = DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  ///
  BooleanData.keyed(KeyedDataset keyedDataset, String prop) {
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
      values.addAll(data.whereType<bool>());
    } else if (data is bool) {
      values.add(data);
    } else {
      // warn and do best to convert to bool
      logger.warning('Unexpected data type for BooleanData: $data');
      if (data is List) {
        for (final dynamic d in data) {
          values.add(_anythingToBool(d));
        }
      } else {
        values.add(_anythingToBool(data));
      }
    }
  }

  bool _anythingToBool(dynamic d) {
    if (d is bool) return d;
    if (d is num) {
      if (d == 0) return false;
      return true;
    } else if (d is String) {
      final String lc = d.trim().toLowerCase();
      if (lc == 'true' || lc == 'yes' || lc == 'y' || lc == 'on' || lc == '1') return true;
      return false;
    } else if (d is Quantity) {
      if (d.mks.toDouble() == 0) return false;
      return true;
    } else {
      return false;
    }
  }
}
