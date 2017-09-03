import '../../../envy_node.dart';
import '../../../util/logger.dart';
import '../../data_accessor.dart';
import '../../keyed_dataset.dart';
import '../data_source.dart';
import 'anchor2d_source.dart';
import '../../../graphic/twod/anchor2d.dart';
import '../../../graphic/twod/enum/anchor_mode2d.dart';

/// Retrieves drawing style data (a list of drawing styles or a single
/// drawing style) from a named dataset.
///
class Anchor2dData extends ArrayDataSource<Anchor2d> implements Anchor2dSource {
  final String datasetName;
  final EnvyNode node;

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
  Anchor2dData(this.datasetName, this.node, {DataAccessor accessor, String prop}) {
    if (prop != null && accessor == null) {
      this.accessor = new DataAccessor.prop(prop);
    }
  }

  /// Find the dataset named [keyedDataset.name], starting with [keyedDataset.node]
  /// and working up the ancestor chain, and use a keyed property data accessor
  /// constructed from [prop] and [keyedDataset.keyProp] to select data from that
  /// dataset.
  ///
  Anchor2dData.keyed(KeyedDataset keyedDataset, String prop) : datasetName = keyedDataset?.name, node = keyedDataset?.node {
    if (prop != null && keyedDataset != null) {
      accessor = new DataAccessor.prop(prop, keyProp: keyedDataset.keyProp);
    }
  }

  void refresh() {
    this.values.clear();

    Object data = node.getDataset(datasetName);
    if (accessor != null) {
      accessor.cullUnavailableData();
      data = accessor.getData(data);
    }

    if (data is List<Anchor2d>) {
      this.values.addAll(data);
    } else if (data is Anchor2d) {
      this.values.add(data);
    } else {
      logger.warning("Unexpected data type for Anchor2dData: ${data}");
    }
  }

  Anchor2d fromAnything(dynamic d) {
    return new Anchor2d(mode: d is String ? new AnchorMode2d(d) : AnchorMode2d.DEFAULT );
  }
}
