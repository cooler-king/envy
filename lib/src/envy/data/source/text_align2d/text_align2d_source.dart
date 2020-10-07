import '../../../graphic/twod/enum/text_align2d.dart';
import '../data_source.dart';

/// A common handle for text alignment data sources.
abstract class TextAlign2dSource extends DataSource<TextAlign2d> {}

/// A constant text alignment value.
class TextAlign2dConstant extends ArrayDataSource<TextAlign2d> implements TextAlign2dSource {
  /// Constructs a instance from an existing [alignment].
  TextAlign2dConstant(TextAlign2d alignment) {
    values.add(alignment);
  }

  /// Constructs a instance from an existing list of [alignments].
  TextAlign2dConstant.array(List<TextAlign2d> alignments) {
    values.addAll(alignments);
  }

  /// Aligns text to the center.
  static final TextAlign2dConstant center = TextAlign2dConstant(TextAlign2d.center);

  /// Aligns text to the right.
  static final TextAlign2dConstant right = TextAlign2dConstant(TextAlign2d.right);

  /// Aligns text to the left.
  static final TextAlign2dConstant left = TextAlign2dConstant(TextAlign2d.left);

  // No-op refresh.
  @override
  void refresh() {}
}
