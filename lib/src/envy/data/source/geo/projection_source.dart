import '../data_source.dart';
import '../../../geo/projections.dart';

abstract class ProjectionSource extends DataSource<Projection> {}

class ProjectionConstant extends ArrayDataSource<Projection> implements ProjectionSource {
  ProjectionConstant(Projection proj) {
    this.values.add(proj);
  }

  ProjectionConstant.array(List<Projection> projList) {
    this.values.addAll(projList);
  }

  // No-op refresh
  void refresh(){
    // No-op
  }
}
