import '../data_source.dart';

/// A common handle for Boolean data sources.
abstract class BooleanSource extends DataSource<bool> {}

/// A constant Boolean value.
class BooleanConstant extends ArrayDataSource<bool> implements BooleanSource {
  /// Constructs a instance from an existing value.
  BooleanConstant(bool tf) {
    values.add(tf);
  }

  /// Constructs a instance from a list of existing values.
  BooleanConstant.array(List<bool> bools) {
    values.addAll(bools);
  }

  /// Constant true.
  static final BooleanConstant trueValue = BooleanConstant(true);

  /// Constant false.
  static final BooleanConstant falseValue = BooleanConstant(false);

  // No-op refresh.
  @override
  void refresh() {}
}
