import 'package:quantity/quantity.dart' show Angle;

/// Represents a geographic coordinate (that is a latitude and longitude).
class GeoCoord {
  /// Constructs a instance with latitude and longitude in radians.
  GeoCoord.radians({this.latRad = 0, this.longRad = 0});

  /// Constructs a instance with latitude and longitude in degrees.
  GeoCoord.degrees({num latDeg = 0, num longDeg = 0})
      : latRad = Angle(deg: latDeg).valueSI.toDouble(),
        longRad = Angle(deg: longDeg).valueSI.toDouble();

  /// Constructs a instance with latitude and longitude Angles.
  GeoCoord.angles({Angle? lat, Angle? long})
      : latRad = lat?.valueSI.toDouble() ?? 0,
        longRad = long?.valueSI.toDouble() ?? 0;

  /// The latitude, in radians.
  final num latRad;

  /// The longitude, in radians.
  final num longRad;

  /// Gets the latitude, as an Angle.
  Angle get latitude => Angle(rad: latRad);

  /// Gets the latitude in degrees.
  num get degreesLatitude => Angle(rad: latRad).valueInUnits(Angle.degrees).toDouble();

  /// Gets the longitude, as an Angle.
  Angle get longitude => Angle(rad: longRad);

  /// Gets the longitude in degrees.
  num get degreesLongitude => Angle(rad: longRad).valueInUnits(Angle.degrees).toDouble();

  @override
  String toString() {
    final buf = StringBuffer()
      ..write(degreesLatitude)
      ..write(degreesLatitude < 0 ? 'S' : 'N')
      ..write(', ')
      ..write(degreesLongitude)
      ..write(degreesLongitude < 0 ? 'W' : 'E');
    return buf.toString();
  }
}
