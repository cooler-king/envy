import '../../../util/enumeration.dart';
import '../data_source.dart';

abstract class StringSource extends DataSource<String> {}

class StringConstant extends ArrayDataSource<String> implements StringSource {
  static final StringConstant empty = new StringConstant('');

  StringConstant(String str) {
    values.add(str);
  }

  StringConstant.array(List<String> strings) {
    values.addAll(strings);
  }

  StringConstant.enumerationValue(Enumeration<String> e) {
    values.add(e.value);
  }

  // No-op refresh
  @override
  void refresh() {}
}
