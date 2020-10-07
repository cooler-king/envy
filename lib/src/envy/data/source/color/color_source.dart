import '../../../color/color.dart';
import '../data_source.dart';

/// The common handle for all color data sources.
abstract class ColorSource extends DataSource<Color> {}

/// A constant color value.
class ColorConstant extends ArrayDataSource<Color> implements ColorSource {
  /// Constructs a instance from an existing color.
  ColorConstant(Color c) {
    values.add(c);
  }

  /// Constructs a instance from an existing color.
  ColorConstant.array(List<Color> colors) {
    values.addAll(colors);
  }

  /// Transparent black.
  static final ColorConstant transparentBlack = ColorConstant(Color.transparentBlack);

  // No-op refresh
  @override
  void refresh() {}
}
