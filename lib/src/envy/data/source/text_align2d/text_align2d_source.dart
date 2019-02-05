import '../../../graphic/twod/enum/text_align2d.dart';
import '../data_source.dart';

abstract class TextAlign2dSource extends DataSource<TextAlign2d> {}

class TextAlign2dConstant extends ArrayDataSource<TextAlign2d> implements TextAlign2dSource {
  TextAlign2dConstant(TextAlign2d alignment) {
    values.add(alignment);
  }

  TextAlign2dConstant.array(List<TextAlign2d> alignments) {
    values.addAll(alignments);
  }

  static final TextAlign2dConstant center = new TextAlign2dConstant(TextAlign2d.center);
  static final TextAlign2dConstant right = new TextAlign2dConstant(TextAlign2d.right);
  static final TextAlign2dConstant left = new TextAlign2dConstant(TextAlign2d.left);

  // No-op refresh
  @override
  void refresh() {}
}
