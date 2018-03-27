import '../../../color/color.dart';
import '../data_source.dart';

abstract class ColorSource extends DataSource<Color> {}

class ColorConstant extends ArrayDataSource<Color> implements ColorSource {
  static final ColorConstant transparentBlack = new ColorConstant(Color.transparentBlack);

  ColorConstant(Color c) {
    values.add(c);
  }

  ColorConstant.array(List<Color> colors) {
    values.addAll(colors);
  }

  // No-op refresh
  @override
  void refresh() {}
}
