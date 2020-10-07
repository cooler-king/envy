import '../../../graphic/twod/drawing_style2d.dart';
import '../data_source.dart';

/// a common handle for drawing style sources.
abstract class DrawingStyle2dSource extends DataSource<DrawingStyle2d> {}

/// A constant drawing style.
class DrawingStyle2dConstant extends ArrayDataSource<DrawingStyle2d> implements DrawingStyle2dSource {
  /// Constructs a instance from an existing style.
  DrawingStyle2dConstant(DrawingStyle2d drawingStyle) {
    values.add(drawingStyle);
  }

  /// Constructs a instance from a list of existing styles.
  DrawingStyle2dConstant.array(List<DrawingStyle2d> drawingStyles) {
    values.addAll(drawingStyles);
  }

  /// The color black as a drawing style.
  static final DrawingStyle2dConstant black = DrawingStyle2dConstant(DrawingStyle2d.black);

  /// The color white as a drawing style.
  static final DrawingStyle2dConstant white = DrawingStyle2dConstant(DrawingStyle2d.white);

  // No-op refresh.
  @override
  void refresh() {}
}
