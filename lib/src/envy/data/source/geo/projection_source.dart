import '../../../geo/projections.dart';
import '../data_source.dart';

abstract class ProjectionSource extends DataSource<Projection> {}

class ProjectionConstant extends ArrayDataSource<Projection> implements ProjectionSource {
  ProjectionConstant(Projection proj) {
    values.add(proj);
  }

  ProjectionConstant.array(List<Projection> projList) {
    values.addAll(projList);
  }

  // No-op refresh
  @override
  void refresh() {
    // No-op
  }
}
