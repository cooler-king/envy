part of envy;

abstract class AngleSource extends DataSource<Angle> {}

class AngleConstant extends ArrayDataSource<Angle> implements AngleSource {
  AngleConstant(Angle angle) {
    this.values.add(angle);
  }

  AngleConstant.array(List<Angle> angles) {
    this.values.addAll(angles);
  }

  // No-op refresh
  void refresh() {}
}
