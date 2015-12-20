part of envy;

abstract class Projection {
  /// Concrete implementations need to provide this method that converts
  /// a latitude and longitude, provided in radians, to a Point.
  ///
  Point<num> toPoint({num latRad, num longRad, num scale: 1});

  Point<num> anglesToPoint({Angle lat, Angle long, num scale: 1}) =>
    toPoint(latRad: lat.valueSI.toDouble(), longRad: long.valueSI.toDouble(), scale: scale);


  Point<num> degreesToPoint({num latDeg, num longDeg, num scale: 1}) =>
    toPoint(latRad: degToRad(latDeg.toDouble()), longRad: degToRad(longDeg.toDouble()), scale: scale);


  Point<num> geocoordToPoint(GeoCoord geoCoord, {num scale: 1}) =>
    toPoint(latRad: geoCoord.latRad, longRad: geoCoord.longRad, scale: scale);

  /// Concrete implementations need to provide this method that converts
  /// a projected Point back to a geocoordinate.
  ///
  GeoCoord toGeo(Point<num> pt);
}

/// Equirectangular projections map meridians to vertical straight lines of constant spacing
/// (for meridional intervals of constant spacing), and circles of latitude to
/// horizontal straight lines of constant spacing (for constant intervals of parallels).
/// The projection is neither equal area nor conformal.
///
class Equirectangular extends Projection {
  final num cosParallel;

  Equirectangular(Angle standardParallel) : cosParallel = standardParallel.cosine();

  Point<num> toPoint({num latRad, num longRad, num scale: 1}) {
    scale = 120; // test
    return new Point<num>(longRad * cosParallel * scale, -latRad * scale);
  }

  GeoCoord toGeo(Point<num> pt) {
    //TODO toGeo
    return null;
  }
}


/// PlateCarree is the special case of an Equirectangular projection where the equator is
/// used as the standard parallel.
///
class PlateCarree extends Equirectangular {
  PlateCarree() : super(new Angle(rad: 0));
}