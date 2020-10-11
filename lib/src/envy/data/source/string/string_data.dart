import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'string_source.dart';

/// Retrieves numerical data (a list of numbers or a single number)
/// from a named dataset.
///
class StringData extends ArrayDataSource<String> implements StringSource {
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
  StringData(this._datasetName, this._node, {DataAccessor accessor, String prop}) {
    this.accessor = accessor ?? (prop != null ? DataAccessor.prop(prop) : null);
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  StringData.keyed(KeyedDataset keyedDataset, String prop) {
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
      for (final dynamic entry in data) {
        if (entry is String) {
          values.add(entry);
        } else if (entry == null) {
          // Add an empty string for null.
          values.add('');
        } else {
          // Warn and convert to string.
          logger.warning('Unexpected data type for StringData: $entry');
          values.add('$entry');
        }
      }
    } else if (data is String) {
      values.add(data);
    } else if (data == null) {
      // Add an empty string for null.
      values.add('');
    } else {
      // Warn and convert to string.
      logger.warning('Unexpected data type for StringData: $data');
      values.add(data.toString());
    }
  }
}
