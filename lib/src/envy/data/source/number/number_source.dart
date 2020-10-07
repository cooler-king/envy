import '../data_source.dart';

/// A common handle for numerical data sources.
abstract class NumberSource extends DataSource<num> {}

/// A constant numerical value.
class NumberConstant extends ArrayDataSource<num> implements NumberSource {
  /// Constructs a instance from an existing value.
  NumberConstant(num number) {
    values.add(number);
  }

  /// Constructs a instance from a list of existing values.
  NumberConstant.array(List<num> numbers) {
    values.addAll(numbers);
  }

  /// Constant zero.
  static final NumberConstant zero = NumberConstant(0);

  /// Constant one.
  static final NumberConstant one = NumberConstant(1);

  // No-op refresh.
  @override
  void refresh() {}
}
