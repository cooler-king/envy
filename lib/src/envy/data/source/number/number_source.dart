import '../data_source.dart';

abstract class NumberSource extends DataSource<num> {}

class NumberConstant extends ArrayDataSource<num> implements NumberSource {
  NumberConstant(num number) {
    values.add(number);
  }

  NumberConstant.array(List<num> numbers) {
    values.addAll(numbers);
  }

  static final NumberConstant zero = new NumberConstant(0);
  static final NumberConstant one = new NumberConstant(1);

  // No-op refresh
  @override
  void refresh() {}
}
