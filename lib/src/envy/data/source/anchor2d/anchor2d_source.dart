part of envy;

abstract class Anchor2dSource extends DataSource<Anchor2d> {}

class Anchor2dConstant extends ArrayDataSource<Anchor2d> implements Anchor2dSource {
  Anchor2dConstant(Anchor2d anchor) {
    this.values.add(anchor);
  }

  Anchor2dConstant.array(List<Anchor2d> anchors) {
    this.values.addAll(anchors);
  }

  // No-op refresh
  void refresh() {}
}
