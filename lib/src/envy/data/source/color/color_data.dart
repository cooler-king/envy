import '../../../color/color.dart';
import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'color_source.dart';

/// Retrieves color data (a list of Colors or a single Color)
/// from a named dataset.
class ColorData extends ArrayDataSource<Color> implements ColorSource {
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
  ///
  ColorData(this._datasetName, this._node, {DataAccessor dataAccessor, String prop}) {
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
  ColorData.keyed(KeyedDataset keyedDataset, String prop) {
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
      values.addAll(data.whereType<Color>());
    } else if (data is Color) {
      values.add(data);
    } else {
      // warn and do best to convert to color
      logger.warning('Unexpected data type for ColorData: $data');
      if (data is List) {
        // try to parse entries as numbers; assume degrees
        for (final dynamic d in data) {
          values.add(_colorFromAnything(d));
        }
      } else {
        values.add(_colorFromAnything(data));
      }
    }
  }

  Color _colorFromAnything(dynamic d) {
    if (d is Color) return d;

    if (d is String) {
      if (d.startsWith('#')) return Color.hex(d);
      return Color.black.fromCss(d);
    }

    return Color.black;
  }
}
