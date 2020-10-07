import '../../../graphic/twod/number_list.dart';
import '../data_source.dart';

/// A common handle for numerical list data sources.
abstract class NumberListSource extends DataSource<NumberList> {}

/// A list of constant numerical values.
class NumberListConstant extends ArrayDataSource<NumberList> implements NumberListSource {
  /// Constructs a instance from an existing numerical list.
  NumberListConstant(NumberList numberList) {
    values.add(numberList);
  }

  /// Constructs a instance from a list of existing numerical lists.
  NumberListConstant.array(List<NumberList> numberLists) {
    values.addAll(numberLists);
  }

  // No-op refresh.
  @override
  void refresh() {}
}
