part of envy;

abstract class NumberListSource extends DataSource<NumberList> {}

class NumberListConstant extends ArrayDataSource<NumberList> implements NumberListSource {
  NumberListConstant(NumberList numberList) {
    this.values.add(numberList);
  }

  NumberListConstant.array(List<NumberList> numberLists) {
    this.values.addAll(numbers);
  }

  // No-op refresh
  void refresh() {}
}