part of envy;

abstract class ProjectionSource extends DataSource<Projection> {}

class ProjectionConstant extends ArrayDataSource<Projection> implements ProjectionSource {
  ProjectionConstant(Projection proj) {
    this.values.add(proj);
  }

  ProjectionConstant.array(List<Projection> proj) {
    this.values.addAll(proj);
  }

  // No-op refresh
  void refresh();
}
