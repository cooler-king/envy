import '../../../geo/projections.dart';
import '../data_source.dart';

/// A common handle for all projection data sources.
abstract class ProjectionSource extends DataSource<Projection> {}

/// A constant projection.
class ProjectionConstant extends ArrayDataSource<Projection> implements ProjectionSource {
  /// Constructs a instance from an existing projection.
  ProjectionConstant(Projection proj) {
    values.add(proj);
  }

  /// Constructs a instance from a list of existing projections.
  ProjectionConstant.array(List<Projection> projList) {
    values.addAll(projList);
  }

  // No-op refresh
  @override
  void refresh() {
    // No-op
  }
}
