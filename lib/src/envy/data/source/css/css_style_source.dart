import '../../../css/css_style.dart';
import '../data_source.dart';

abstract class CssStyleSource extends DataSource<CssStyle> {}

class CssStyleConstant extends ArrayDataSource<CssStyle> implements CssStyleSource {
  CssStyleConstant(CssStyle style) {
    values.add(style);
  }

  CssStyleConstant.array(List<CssStyle> styles) {
    values.addAll(styles);
  }

  // No-op refresh
  @override
  void refresh() {}
}
