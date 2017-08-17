import '../data_source.dart';
import '../../../color/color.dart';

abstract class ColorSource extends DataSource<Color> {}

class ColorConstant extends ArrayDataSource<Color> implements ColorSource {
  static final ColorConstant transparentBlack = new ColorConstant(Color.TRANSPARENT_BLACK);

  ColorConstant(Color c) {
    this.values.add(c);
  }

  ColorConstant.array(List<Color> colors) {
    this.values.addAll(colors);
  }

  // No-op refresh
  void refresh() {}
}
