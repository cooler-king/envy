import '../data_source.dart';

abstract class BooleanSource extends DataSource<bool> {}

class BooleanConstant extends ArrayDataSource<bool> implements BooleanSource {
  static final BooleanConstant TRUE = new BooleanConstant(true);
  static final BooleanConstant FALSE = new BooleanConstant(false);

  BooleanConstant(bool tf) {
    values.add(tf);
  }

  BooleanConstant.array(List<bool> bools) {
    values.addAll(bools);
  }

  // No-op refresh
  @override
  void refresh() {}
}
