import 'dart:math' show Point;
import 'package:quantity/quantity.dart';
import 'geocoord.dart';

/// The base class for specific types of geographic projections.
abstract class Projection {
  /// The scale of the projection
  num _scale = 1;

  /// An offset, in pixels
  Point<num> _offset = const Point<num>(0, 0);

  /// The scale of the projection may be set indirectly by specifying the
  /// desired width of the projection in pixels (at 0 latitude).
  void setPixelWidth(num width) {
    final left = degreesToPoint(latDeg: 0, longDeg: -180);
    final right = degreesToPoint(latDeg: 0, longDeg: 180);
    _scale = width / (right.x - left.x).abs();
  }

  /// The scale of the projection may be set indirectly by specifying the
  /// desired height of the projection in pixels (at 0 longitude).
  void setPixelHeight(num height) {
    final top = degreesToPoint(latDeg: 89.99, longDeg: 0);
    final bottom = degreesToPoint(latDeg: -89.99, longDeg: 0);
    _scale = height / (bottom.x - top.x).abs();
  }

  /// The anchor coordinate, if specified, will be at pixel location 0, 0.
  void setAnchorCoord(GeoCoord coord) {
    final anchor = toPoint(latRad: coord.latRad, longRad: coord.longRad);
    _offset = Point<num>(-anchor.x, -anchor.y);
  }

  /// Concrete implementations need to provide this method that converts
  /// a latitude and longitude, provided in radians, to a point.
  Point<num> toPoint({num latRad, num longRad});

  /// Converts a latitude and longitude to a point by applying the projection.
  Point<num> anglesToPoint({Angle lat, Angle long}) =>
      toPoint(latRad: lat.valueSI.toDouble(), longRad: long.valueSI.toDouble());

  /// Converts a latitude and longitude, in degrees, to a point by applying the projection.
  Point<num> degreesToPoint({num latDeg, num longDeg}) =>
      toPoint(latRad: degToRad(latDeg.toDouble()), longRad: degToRad(longDeg.toDouble()));

  /// Converts a geocoordinate to a point by applying the projection.
  Point<num> geocoordToPoint(GeoCoord geoCoord) => toPoint(latRad: geoCoord.latRad, longRad: geoCoord.longRad);

  /// Concrete implementations need to provide this method that converts
  /// a projected Point back to a geocoordinate.
  GeoCoord toGeo(Point<num> pt);
}

/// Equirectangular projections map meridians to vertical straight lines of constant spacing
/// (for meridional intervals of constant spacing), and circles of latitude to
/// horizontal straight lines of constant spacing (for constant intervals of parallels).
/// The projection is neither equal area nor conformal.
class Equirectangular extends Projection {
  /// Constructs a instance.
  Equirectangular(Angle standardParallel, {num width = 500, GeoCoord anchor})
      : cosParallel = standardParallel.cosine() {
    if (width != null) setPixelWidth(width);
    if (anchor != null) setAnchorCoord(anchor);
  }

  @override
  Point<num> toPoint({num latRad, num longRad}) =>
      Point<num>(longRad * cosParallel * _scale + _offset.x, -latRad * _scale + _offset.y);

  /// The cosine of the standard parallel.
  final num cosParallel;

  //TODO equirectangular projection toGeo
  @override
  GeoCoord toGeo(Point<num> pt) => null;
}

/// PlateCarree is the special case of an Equirectangular projection where the equator is
/// used as the standard parallel.
class PlateCarree extends Equirectangular {
  /// Constructs a instance.
  PlateCarree() : super(Angle(rad: 0));
}
