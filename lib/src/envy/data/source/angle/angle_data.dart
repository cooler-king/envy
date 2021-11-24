import 'package:quantity/quantity.dart' show Angle, angle0;
import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'angle_source.dart';

/// Retrieves angle data (a list of Angles or a single Angle)
/// from a named dataset.
class AngleData extends ArrayDataSource<Angle> implements AngleSource {
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
  AngleData(this._datasetName, this._node, {DataAccessor? accessor, String? prop}) {
    if (prop != null && accessor == null) {
      this.accessor = DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named `keyedDataset.name`, starting with `keyedDataset.node`
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and `keyedDataset.keyProp` to select data from that
  /// dataset.
  ///
  AngleData.keyed(KeyedDataset? keyedDataset, String? prop) {
    if (prop != null && keyedDataset != null) {
      _datasetName = keyedDataset.name;
      _node = keyedDataset.node;
      accessor = DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  String? _datasetName;
  EnvyNode? _node;

  @override
  void refresh() {
    values.clear();

    var data = _node?.getDataset(_datasetName);
    if (accessor != null) {
      accessor!.cullUnavailableData();
      data = accessor!.getData(data);
    }

    if (data is List<dynamic>) {
      values.addAll(data.whereType<Angle>());
    } else if (data is Angle) {
      values.add(data);
    } else {
      // Warn and do best to convert to number
      logger.warning('Unexpected data type for AngleData: $data');
      if (data is List) {
        // try to parse entries as numbers; assume degrees
        for (final dynamic d in data) {
          values.add(_angleFromAnything(d));
        }
      } else {
        values.add(_angleFromAnything(data));
      }
    }
  }

  Angle _angleFromAnything(dynamic d) {
    if (d is Angle) return d;

    if (d is num) {
      // Assume degrees
      return Angle(deg: d);
    } else {
      try {
        final val = num.parse(d.toString());
        return Angle(deg: val);
      } catch (e) {
        return angle0;
      }
    }
  }
}
