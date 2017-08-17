import '../data_source.dart';
import '../../../graphic/twod/enum/text_align2d.dart';

abstract class TextAlign2dSource extends DataSource<TextAlign2d> {}

class TextAlign2dConstant extends ArrayDataSource<TextAlign2d> implements TextAlign2dSource {
  static final TextAlign2dConstant center = new TextAlign2dConstant(TextAlign2d.CENTER);
  static final TextAlign2dConstant right = new TextAlign2dConstant(TextAlign2d.RIGHT);
  static final TextAlign2dConstant left = new TextAlign2dConstant(TextAlign2d.LEFT);

  TextAlign2dConstant(TextAlign2d alignment) {
    this.values.add(alignment);
  }

  TextAlign2dConstant.array(List<TextAlign2d> alignments) {
    this.values.addAll(alignments);
  }

  // No-op refresh
  void refresh() {}
}
