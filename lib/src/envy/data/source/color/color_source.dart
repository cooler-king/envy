import '../../../color/color.dart';
import '../data_source.dart';

abstract class ColorSource extends DataSource<Color> {}

class ColorConstant extends ArrayDataSource<Color> implements ColorSource {
  ColorConstant(Color c) {
    values.add(c);
  }

  ColorConstant.array(List<Color> colors) {
    values.addAll(colors);
  }

  static final ColorConstant transparentBlack = new ColorConstant(Color.transparentBlack);

  // No-op refresh
  @override
  void refresh() {}
}
