import '../../../graphic/twod/anchor2d.dart';
import '../data_source.dart';

abstract class Anchor2dSource extends DataSource<Anchor2d> {}

class Anchor2dConstant extends ArrayDataSource<Anchor2d> implements Anchor2dSource {
  /// Constructs a new instance from a single anchor.
  Anchor2dConstant(Anchor2d anchor) {
    values.add(anchor);
  }

  /// Constructs a new instance from an existing list of anchors.
  Anchor2dConstant.array(List<Anchor2d> anchors) {
    values.addAll(anchors);
  }

  // No-op refresh
  @override
  void refresh() {}
}
