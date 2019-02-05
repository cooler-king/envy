import '../../../text/font.dart';
import '../data_source.dart';

abstract class FontSource extends DataSource<Font> {}

class FontConstant extends ArrayDataSource<Font> implements FontSource {
  FontConstant(Font c) {
    values.add(c);
  }

  FontConstant.array(List<Font> fonts) {
    values.addAll(fonts);
  }

  // No-op refresh
  @override
  void refresh() {}
}
