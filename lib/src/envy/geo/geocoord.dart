import 'package:quantity/quantity.dart' show Angle;

class GeoCoord {
  final num latRad;
  final num longRad;

  GeoCoord.radians({this.latRad: 0, this.longRad: 0});

  GeoCoord.degrees({num latDeg: 0, num longDeg: 0}) : latRad = new Angle(deg: latDeg).valueSI.toDouble(),
        longRad = new Angle(deg: longDeg).valueSI.toDouble();

  GeoCoord.angles({Angle lat, Angle long}) : latRad = lat?.valueSI?.toDouble() ?? 0,
        longRad = long?.valueSI?.toDouble() ?? 0;


  Angle get latitude => new Angle(rad: latRad);

  num get degreesLatitude => (new Angle(rad: latRad)).valueInUnits(Angle.degrees).toDouble();

  num get radiansLatitude => latRad;

  Angle get longitude => new Angle(rad: longRad);

  num get degreesLongitude => (new Angle(rad: longRad)).valueInUnits(Angle.degrees).toDouble();

  num get radiansLongitude => longRad;

  String toString() {
    var buf = new StringBuffer();
    buf.write(degreesLatitude);
    buf.write(degreesLatitude < 0 ? "S" : "N");
    buf.write(", ");
    buf.write(degreesLongitude);
    buf.write(degreesLongitude < 0 ? "W" : "E");
    return buf.toString();
  }
}