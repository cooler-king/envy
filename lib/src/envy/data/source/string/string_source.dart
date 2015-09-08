part of envy;

abstract class StringSource extends DataSource<String> {}

class StringConstant extends ArrayDataSource<String> implements StringSource {
  static final StringConstant empty = new StringConstant("");

  StringConstant(String str) {
    this.values.add(str);
  }

  StringConstant.array(List<String> strings) {
    this.values.addAll(strings);
  }

  StringConstant.enumerationValue(Enumeration<String> e) {
    this.values.add(e.value);
  }

  // No-op refresh
  void refresh() {}
}
