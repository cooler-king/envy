part of envy;

abstract class TextBaseline2dSource extends DataSource<TextBaseline2d> {}

class TextBaseline2dConstant extends ArrayDataSource<TextBaseline2d> implements TextBaseline2dSource {
  static final TextBaseline2dConstant middle = new TextBaseline2dConstant(TextBaseline2d.MIDDLE);

  TextBaseline2dConstant(TextBaseline2d baseline) {
    this.values.add(baseline);
  }

  TextBaseline2dConstant.array(List<TextBaseline2d> baselines) {
    this.values.addAll(baselines);
  }

  // No-op refresh
  void refresh() {}
}
