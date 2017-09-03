import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'color_source.dart';
import '../../../color/color.dart';

/// Retrieves color data (a list of Colors or a single Color)
/// from a named dataset.
///
class ColorData extends ArrayDataSource<Color> implements ColorSource {
  String _datasetName;
  EnvyNode _node;

  /// Find the dataset named [datasetName], starting with [node] and working
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
    if (prop != null && accessor == null) {
      accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  ColorData.keyed(KeyedDataset keyedDataset, String prop) {
    if (prop != null && keyedDataset != null) {
      this._datasetName = keyedDataset.name;
      this._node = keyedDataset.node;
      accessor = new DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  void refresh() {
    this.values.clear();

    Object data = _node.getDataset(_datasetName);
    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data is List<Color>) {
      this.values.addAll(data);
    } else if (data is Color) {
      this.values.add(data);
    } else {
      // warn and do best to convert to color
      logger.warning("Unexpected data type for ColorData: ${data}");
      if (data is List) {
        // try to parse entries as numbers; assume degrees
        for (var d in data) {
          this.values.add(_colorFromAnything(d));
        }
      } else {
        this.values.add(_colorFromAnything(data));
      }
    }
  }

  Color _colorFromAnything(dynamic d) {
    if (d is Color) return d;

    if (d is String) {
      if (d.startsWith("#")) return new Color.hex(d);
      return Color.black.fromCss(d);
    }

    return Color.black;
  }
}
