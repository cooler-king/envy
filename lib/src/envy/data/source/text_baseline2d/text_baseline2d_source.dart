import '../../../graphic/twod/enum/text_baseline2d.dart';
import '../data_source.dart';

/// A common handle for text baseline data sources.
abstract class TextBaseline2dSource extends DataSource<TextBaseline2d> {}

/// A constant text baseline value.
class TextBaseline2dConstant extends ArrayDataSource<TextBaseline2d> implements TextBaseline2dSource {
  /// Constructs a instance from an existing value.
  TextBaseline2dConstant(TextBaseline2d baseline) {
    values.add(baseline);
  }

  /// Constructs a instance from a list of existing values.
  TextBaseline2dConstant.array(List<TextBaseline2d> baselines) {
    values.addAll(baselines);
  }

  /// Constant middle.
  static final TextBaseline2dConstant middle = TextBaseline2dConstant(TextBaseline2d.middle);

  // No-op refresh.
  @override
  void refresh() {}
}
