part of envy;

abstract class BooleanSource extends DataSource<bool> {}

class BooleanConstant extends ArrayDataSource<bool> implements BooleanSource {
  static final BooleanConstant TRUE = new BooleanConstant(true);
  static final BooleanConstant FALSE = new BooleanConstant(false);

  BooleanConstant(bool tf) {
    this.values.add(tf);
  }

  BooleanConstant.array(List<bool> bools) {
    this.values.addAll(bools);
  }

  // No-op refresh
  void refresh() {}
}
