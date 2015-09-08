part of envy;

abstract class PathInterpolation2dSource extends DataSource<PathInterpolation2d> {}

class PathInterpolation2dConstant extends ArrayDataSource<PathInterpolation2d> implements PathInterpolation2dSource {
  static final PathInterpolation2dConstant linear = new PathInterpolation2dConstant(PathInterpolation2d.LINEAR);

  PathInterpolation2dConstant(PathInterpolation2d interpolation) {
    this.values.add(interpolation);
  }

  PathInterpolation2dConstant.array(List<PathInterpolation2d> interpolation) {
    this.values.addAll(interpolation);
  }

  // No-op refresh
  void refresh() {}
}
