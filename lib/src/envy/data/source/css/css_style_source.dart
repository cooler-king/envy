import '../../../css/css_style.dart';
import '../data_source.dart';

/// A common handle for all CSS style sources.
abstract class CssStyleSource extends DataSource<CssStyle> {}

/// A constant CSS style.
class CssStyleConstant extends ArrayDataSource<CssStyle> implements CssStyleSource {
  /// Constructs a instance from a single style.
  CssStyleConstant(CssStyle style) {
    values.add(style);
  }

  /// Constructs a instance from an existing style list.
  CssStyleConstant.array(List<CssStyle> styles) {
    values.addAll(styles);
  }

  // No-op refresh.
  @override
  void refresh() {}
}
