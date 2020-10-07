import '../../../envy_node.dart';
import '../../../graphic/twod/enum/text_baseline2d.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'text_baseline2d_source.dart';

/// Retrieves text baseline data (a list of text baselines or a single
/// text baseline) from a named dataset.
class TextBaseline2dData extends ArrayDataSource<TextBaseline2d> implements TextBaseline2dSource {
  /// Find the dataset named [_datasetName], starting with [_node] and working
  /// up the ancestor chain, and use the [accessor] to select data from that
  /// dataset.
  ///
  /// If [prop] is provided instead of [accessor] then a property DataAccesor
  /// will be constructed and used.
  ///
  /// If both [accessor] and [prop] are provided, [accessor] is used.
  ///
  /// If neither [accessor] and [prop] are provided then the dataset is used
  /// as a whole.
  TextBaseline2dData(this._datasetName, this._node, {DataAccessor accessor, String prop}) {
    this.accessor = accessor ?? (prop != null ? DataAccessor.prop(prop) : null);
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  TextBaseline2dData.keyed(KeyedDataset keyedDataset, String prop) {
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

    if (data is List<dynamic>) {
      values.addAll(data.whereType<TextBaseline2d>());
    } else if (data is TextBaseline2d) {
      values.add(data);
    } else {
      // warn and do best to convert
      logger.warning('Unexpected data type for TextBaseline2dData: $data');
    }
  }

  /// Converts [d] to a `TextBaseline2d`, defaulting to `TextBaseline2d.alphabetic`
  /// if the value is not understood.
  TextBaseline2d fromAnything(dynamic d) {
    if (d is String) return TextBaseline2d.from(d);
    return TextBaseline2d.alphabetic;
  }
}
