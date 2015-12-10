part of envy;

abstract class Projection {
  Point<num> toPoint({Angle lat, Angle long, this.scale: 1});

  GeoCoord toGeo(Point<num> pt);
}

/// Equirectangular projections map meridians to vertical straight lines of constant spacing
/// (for meridional intervals of constant spacing), and circles of latitude to
/// horizontal straight lines of constant spacing (for constant intervals of parallels).
/// The projection is neither equal area nor conformal.
///
class Equirectangular extends Projection {
  final num cosParallel;

  Equirectangular(Angle standardParallels) : cosParallel = standardParallel.cos();

  Point<num> toPoint({Angle lat, Angle long, num scale: 1}) {
    return new Point<num>(long.valueSI.toDouble() * cosParallel * scale, lat.valueSI.toDouble() * scale);
  }
}


/// PlateCarree is the special case of an Equirectangular projection where the equator is
/// used as teh standard parallel.
///
class PlateCarree extends Equirectangular {
  PlateCarree() : super(new Angle(rad: 0));
}