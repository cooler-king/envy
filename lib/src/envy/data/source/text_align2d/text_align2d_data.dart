import '../../../envy_node.dart';
import '../../../graphic/twod/enum/text_align2d.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'text_align2d_source.dart';

/// Retrieves text alignment data (a list of text alignments or a single
/// text alignment) from a named dataset.
class TextAlign2dData extends ArrayDataSource<TextAlign2d> implements TextAlign2dSource {
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
  TextAlign2dData(this._datasetName, this._node, {DataAccessor accessor, String prop}) {
    this.accessor = accessor ?? (prop != null ? DataAccessor.prop(prop) : null);
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  TextAlign2dData.keyed(KeyedDataset keyedDataset, String prop) {
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
      values.addAll(data.whereType<TextAlign2d>());
    } else if (data is TextAlign2d) {
      values.add(data);
    } else {
      // warn and do best to convert
      logger.warning('Unexpected data type for TextAlign2dData: $data');
    }
  }

  /// Converts [d] to a `TextAlign2d`, defaulting to `TextAlign2d.left`
  /// if the value is not understood.
  TextAlign2d fromAnything(dynamic d) {
    if (d is String) return TextAlign2d.from(d);
    return TextAlign2d.left;
  }
}
