part of envy;

abstract class NumberSource extends DataSource<num> {}

class NumberConstant extends ArrayDataSource<num> implements NumberSource {
  static final NumberConstant zero = new NumberConstant(0);
  static final NumberConstant one = new NumberConstant(1);

  NumberConstant(num number) {
    this.values.add(number);
  }

  NumberConstant.array(List<num> numbers) {
    this.values.addAll(numbers);
  }

  // No-op refresh
  void refresh() {}
}
