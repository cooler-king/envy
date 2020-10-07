import '../../../text/font.dart';
import '../data_source.dart';

/// A common handle for font data sources.
abstract class FontSource extends DataSource<Font> {}

/// A constant font value.
class FontConstant extends ArrayDataSource<Font> implements FontSource {
  /// Constructs a instance from an existing value.
  FontConstant(Font c) {
    values.add(c);
  }

  /// Constructs a instance from a list of existing values.
  FontConstant.array(List<Font> fonts) {
    values.addAll(fonts);
  }

  // No-op refresh.
  @override
  void refresh() {}
}
