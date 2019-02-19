import '../../../util/enumeration.dart';
import '../data_source.dart';

/// The abstract handle for all String sources.
abstract class StringSource extends DataSource<String> {}

/// A constant String source.
class StringConstant extends ArrayDataSource<String> implements StringSource {
  /// Constructs a new instance from an existing String.
  StringConstant(String str) {
    values.add(str);
  }

  /// Constructs a new instance from an existing list of String.
  StringConstant.array(List<String> strings) {
    values.addAll(strings);
  }

  /// Constructs a new instance from a specific enumerated String value.
  StringConstant.enumerationValue(Enumeration<String> e) {
    values.add(e.value);
  }

  /// An empty String.
  static final StringConstant empty = new StringConstant('');

  // No-op refresh.
  @override
  void refresh() {}
}
