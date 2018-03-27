import '../../../graphic/twod/anchor2d.dart';
import '../data_source.dart';

abstract class Anchor2dSource extends DataSource<Anchor2d> {}

class Anchor2dConstant extends ArrayDataSource<Anchor2d> implements Anchor2dSource {
  Anchor2dConstant(Anchor2d anchor) {
    values.add(anchor);
  }

  Anchor2dConstant.array(List<Anchor2d> anchors) {
    values.addAll(anchors);
  }

  // No-op refresh
  @override
  void refresh() {}
}
