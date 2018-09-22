import '../../../css/css_style.dart';
import '../data_source.dart';

abstract class CssStyleSource extends DataSource<CssStyle> {}

class CssStyleConstant extends ArrayDataSource<CssStyle> implements CssStyleSource {
  /// Constructs a new instance from a single style.
  CssStyleConstant(CssStyle style) {
    values.add(style);
  }

  /// Constructs a new instance from an existing style list.
  CssStyleConstant.array(List<CssStyle> styles) {
    values.addAll(styles);
  }

  // No-op refresh
  @override
  void refresh() {}
}
