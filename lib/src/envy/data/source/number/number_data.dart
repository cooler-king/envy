import 'number_source.dart';
import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../source/data_source.dart';
import '../../keyed_dataset.dart';

/// Retrieves numerical data (a list of numbers or a single number)
/// from a named dataset.
///
class NumberData extends ArrayDataSource<num> implements NumberSource {
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
  NumberData(this._datasetName, this._node, {this.accessor, String prop}) {
    if (prop != null && accessor == null) {
      accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  NumberData.keyed(KeyedDataset keyedDataset, String prop) {
    if (prop != null && keyedDataset != null) {
      this._datasetName = keyedDataset.name;
      this._node = keyedDataset.node;
      accessor = new DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  void refresh() {
    this.values.clear();

    Object data = _node.getDataset(_datasetName);
    //print(data);
    //if(data == null || (data is List && data.isEmpty) || (data is Map && data.isEmpty)) return;

    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data == null) return;

    if (data is List<num>) {
      this.values.addAll(data);
    } else if (data is num) {
      if(data == 4) {
        print("ADDING 4 to DATA");
      }
      this.values.add(data);
    } else {
      // warn and do best to convert to number
      logger.warning("Unexpected data type for NumberData: ${data}");
      if (data is List) {
        this.values.add(data.length);
        if(data.length == 4) {
          print("ADDING 4 to DATA *** LENGTH");
        }
      } else if (data is Map) {
        if(data.length == 4) {
          print("ADDING 4 to DATA *** MAP LENGTH");
        }
        this.values.add(data.length);
      } else if (data is bool) {
        this.values.add(data ? 1 : 0);
      } else {
        if(data.toString().length == 4) {
          print("ADDING 4 to DATA *** STRING LENGTH ${data.toString()}");
        }

        this.values.add(data.toString().length);
      }
    }
  }
}
