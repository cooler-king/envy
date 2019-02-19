import '../../../graphic/twod/enum/path_interpolation2d.dart';
import '../data_source.dart';

/// A common handle for path interpolation data sources.
abstract class PathInterpolation2dSource extends DataSource<PathInterpolation2d> {}

/// A constant path interpolation value.
class PathInterpolation2dConstant extends ArrayDataSource<PathInterpolation2d> implements PathInterpolation2dSource {
  /// Constructs a new instance from a single interpolation.
  PathInterpolation2dConstant(PathInterpolation2d interpolation) {
    values.add(interpolation);
  }

  /// Constructs a new instance from an existing list of interpolations.
  PathInterpolation2dConstant.array(List<PathInterpolation2d> interpolation) {
    values.addAll(interpolation);
  }

  /// Linear interpolation.
  static final PathInterpolation2dConstant linear = new PathInterpolation2dConstant(PathInterpolation2d.linear);

  // No-op refresh
  @override
  void refresh() {}
}
