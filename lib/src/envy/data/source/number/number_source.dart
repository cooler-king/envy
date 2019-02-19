import '../data_source.dart';

/// A common handle for numerical data sources.
abstract class NumberSource extends DataSource<num> {}

/// A constant numerical value.
class NumberConstant extends ArrayDataSource<num> implements NumberSource {
  /// Constructs a new instance from an existing value.
  NumberConstant(num number) {
    values.add(number);
  }

  /// Constructs a new instance from a list of existing values.
  NumberConstant.array(List<num> numbers) {
    values.addAll(numbers);
  }

  /// Constant zero.
  static final NumberConstant zero = new NumberConstant(0);

  /// Constant one.
  static final NumberConstant one = new NumberConstant(1);

  // No-op refresh.
  @override
  void refresh() {}
}
