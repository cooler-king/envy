part of envy;

abstract class FontSource extends DataSource<Font> {}

class FontConstant extends ArrayDataSource<Font> implements FontSource {
  FontConstant(Font c) {
    this.values.add(c);
  }

  FontConstant.array(List<Font> fonts) {
    this.values.addAll(fonts);
  }

  // No-op refresh
  void refresh() {}
}
