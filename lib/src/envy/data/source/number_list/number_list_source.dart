import '../../../graphic/twod/number_list.dart';
import '../data_source.dart';

abstract class NumberListSource extends DataSource<NumberList> {}

class NumberListConstant extends ArrayDataSource<NumberList> implements NumberListSource {
  NumberListConstant(NumberList numberList) {
    values.add(numberList);
  }

  NumberListConstant.array(List<NumberList> numberLists) {
    values.addAll(numberLists);
  }

  // No-op refresh
  @override
  void refresh() {}
}
