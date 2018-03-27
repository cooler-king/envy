import '../../../graphic/twod/drawing_style2d.dart';
import '../data_source.dart';

abstract class DrawingStyle2dSource extends DataSource<DrawingStyle2d> {}

class DrawingStyle2dConstant extends ArrayDataSource<DrawingStyle2d> implements DrawingStyle2dSource {
  static final DrawingStyle2dConstant black = new DrawingStyle2dConstant(DrawingStyle2d.black);
  static final DrawingStyle2dConstant white = new DrawingStyle2dConstant(DrawingStyle2d.white);

  DrawingStyle2dConstant(DrawingStyle2d drawingStyle) {
    values.add(drawingStyle);
  }

  DrawingStyle2dConstant.array(List<DrawingStyle2d> drawingStyles) {
    values.addAll(drawingStyles);
  }

  // No-op refresh
  @override
  void refresh() {}
}
