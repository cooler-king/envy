import '../../../graphic/twod/enum/text_baseline2d.dart';
import '../data_source.dart';

abstract class TextBaseline2dSource extends DataSource<TextBaseline2d> {}

class TextBaseline2dConstant extends ArrayDataSource<TextBaseline2d> implements TextBaseline2dSource {
  static final TextBaseline2dConstant middle = new TextBaseline2dConstant(TextBaseline2d.middle);

  TextBaseline2dConstant(TextBaseline2d baseline) {
    values.add(baseline);
  }

  TextBaseline2dConstant.array(List<TextBaseline2d> baselines) {
    values.addAll(baselines);
  }

  // No-op refresh
  @override
  void refresh() {}
}
