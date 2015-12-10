part of envy;

class GeoPointListAngles extends ArrayDataSource<PointList> implements PointListSource {
  ProjectionSource projSource;
  AngleSource latSource;
  AngleSource longSource;

  GeoPointListAngles(this.projSource, this.latSource, this.longSource );

  Point<num> valueAt(int i) {

    projSource.valueAt(i).toPoint(latSource.valueAt(i));

    //TODO check for nulls?
    return new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));
  }

  int get rawSize => Math.max(Math.max(projSource.rawSize, latSource.rawSize), longSource.rawSize);

  // No-op refresh
  void refresh();

}


class GeoPointListDegrees extends ArrayDataSource<PointList> implements PointListSource {
  ProjectionSource projSource;
  NumberSource latSource;
  NumberSource longSource;

  GeoPointListDegrees(this.projSource, this.latSource, this.longSource );
}