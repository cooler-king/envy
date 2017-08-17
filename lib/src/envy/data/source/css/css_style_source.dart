import '../data_source.dart';
import '../../../css/css_style.dart';

abstract class CssStyleSource extends DataSource<CssStyle> {}

class CssStyleConstant extends ArrayDataSource<CssStyle> implements CssStyleSource {
  CssStyleConstant(CssStyle style) {
    this.values.add(style);
  }

  CssStyleConstant.array(List<CssStyle> styles) {
    this.values.addAll(styles);
  }

  // No-op refresh
  void refresh() {}
}
