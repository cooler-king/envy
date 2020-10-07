import '../../../envy_node.dart';
import '../../../graphic/twod/enum/path_interpolation2d.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'path_interpolation2d_source.dart';

/// Retrieves text baseline data (a list of text baselines or a single
/// text baseline) from a named dataset.
class PathInterpolation2dData extends ArrayDataSource<PathInterpolation2d> implements PathInterpolation2dSource {
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
  PathInterpolation2dData(this._datasetName, this._node, {DataAccessor accessor, String prop}) {
    this.accessor = accessor ?? (prop != null ? DataAccessor.prop(prop) : null);
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  PathInterpolation2dData.keyed(KeyedDataset keyedDataset, String prop) {
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
      values.addAll(data.whereType<PathInterpolation2d>());
    } else if (data is PathInterpolation2d) {
      values.add(data);
    } else {
      // Warn and do best to convert.
      logger.warning('Unexpected data type for PathInterpolation2dData: $data');
    }
  }

  /// Converts anything into a PathInterpolator2d, defaulting to
  /// `PathInterpolation2d.linear` if [d] is not understood.
  PathInterpolation2d fromAnything(dynamic d) {
    if (d is String) return PathInterpolation2d.from(d);
    return PathInterpolation2d.linear;
  }
}
