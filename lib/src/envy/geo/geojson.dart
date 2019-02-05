import 'dart:convert';
import 'dart:math' show min, max;
import 'package:quantity/quantity.dart';
import 'geocoord.dart';

/// GeoJSON is a format for encoding a variety of geographic data structures.
/// A GeoJSON object may represent a geometry, a feature, or a collection of
/// features. GeoJSON supports the following geometry types: Point, LineString,
/// Polygon, MultiPoint, MultiLineString, MultiPolygon, and GeometryCollection.
/// Features in GeoJSON contain a geometry object and additional properties,
/// and a feature collection represents a list of features.
class GeoJson {
  factory GeoJson.string(String str) => new GeoJson.map(json.decode(str) as Map<String, dynamic>);

  GeoJson.map(Map<String, dynamic> m) {
    applyMap(m);
  }

  // Will only be one of these
  GeoJsonFeatureCollection featureCollection;
  GeoJsonFeature feature;
  GeoJsonGeometry geometry;

  GeoJsonBoundingBox _bbox;

  void applyMap(Map<String, dynamic> m) {
    if (m == null) return;
    if (m['type'] == 'FeatureCollection') {
      featureCollection = new GeoJsonFeatureCollection.fromJson(m);
    } else if (m['type'] == 'Feature') {
      feature = new GeoJsonFeature.fromJson(m);
    } else {
      // Must be a geometry of some kind
      geometry = new GeoJsonGeometry.fromJson(m);
    }
  }

  dynamic toJson() {
    if (featureCollection != null) return featureCollection.toJson();
    if (feature != null) return feature.toJson();
    if (geometry != null) return geometry.toJson();
    return null;
  }

  /// Returns the bounding box for the geometry, calculating it if necessary.
  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null) _calculateBoundingBox();
    return _bbox;
  }

  void _calculateBoundingBox() {
    if (featureCollection != null) {
      _bbox = featureCollection.boundingBox;
    } else if (feature != null) {
      _bbox = feature.boundingBox;
    } else if (geometry != null) {
      _bbox = geometry.boundingBox;
    } else {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
    }
  }

  AngleRange get latitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return new AngleRange(new Angle(deg: box.minLatitude), new Angle(deg: box.maxLatitude));
  }

  AngleRange get longitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return new AngleRange(new Angle(deg: box.minLongitude), new Angle(deg: box.maxLongitude));
  }

  GeoCoord get center {
    final GeoJsonBoundingBox box = boundingBox;
    return new GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2, longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

class GeoJsonCoordinate {
  GeoJsonCoordinate(this.longitude, this.latitude);

  GeoJsonCoordinate.fromJson(List<num> longLat) {
    longitude = longLat[0];
    latitude = longLat[1];
  }

  num longitude;
  num latitude;

  List<num> toJson() => <num>[longitude ?? 0, latitude ?? 0];
}

class GeoJsonBoundingBox {
  /// Angles are in degrees.
  GeoJsonBoundingBox([this.minLongitude, this.minLatitude, this.maxLongitude, this.maxLatitude]);

  /// Combine two bounding boxes such that returned bounding box contains them both.
  factory GeoJsonBoundingBox.merge(GeoJsonBoundingBox box1, GeoJsonBoundingBox box2) {
    final num minLatDeg = min(box1.minLatitude, box2.minLatitude);
    final num minLongDeg = min(box1.minLongitude, box2.minLongitude);
    final num maxLatDeg = max(box1.maxLatitude, box2.maxLatitude);
    final num maxLongDeg = max(box1.maxLongitude, box2.maxLongitude);
    return new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }

  num minLongitude;
  num minLatitude;
  num maxLongitude;
  num maxLatitude;

  List<num> toJson() => <num>[minLongitude, minLatitude, maxLongitude, maxLatitude];
}

class GeoJsonFeatureCollection {
  GeoJsonFeatureCollection.fromJson(Map<String, dynamic> m) {
    if (m == null) return;
    final dynamic list = m['features'];
    if (list is List) {
      for (dynamic x in list) {
        if (x is Map<String, dynamic>) features.add(new GeoJsonFeature.fromJson(x));
      }
    }
    if (m['bbox'] is List<num>)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'FeatureCollection'};
    final List<dynamic> list = <dynamic>[];
    for (GeoJsonFeature f in features) {
      list.add(f.toJson());
    }
    m['features'] = list;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  final List<GeoJsonFeature> features = <GeoJsonFeature>[];

  GeoJsonBoundingBox _bbox;

  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null) _calculateBoundingBox();
    return _bbox;
  }

  void _calculateBoundingBox() {
    if (features.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (GeoJsonFeature f in features) {
      box = box == null ? f.boundingBox : new GeoJsonBoundingBox.merge(box, f.boundingBox);
    }
    _bbox = box;
  }
}

class GeoJsonFeature {
  GeoJsonFeature([this.geometry, this.properties]);

  GeoJsonFeature.fromJson(Map<String, dynamic> m) {
    applyMap(m);
  }

  GeoJsonGeometry geometry;

  Map<String, dynamic> properties;

  GeoJsonBoundingBox _bbox;

  void applyMap(Map<String, dynamic> m) {
    if (m == null) return;
    if (m['geometry'] is Map) geometry = new GeoJsonGeometry.fromJson(m['geometry'] as Map<String, dynamic>);
    if (m['properties'] is Map) properties = m['properties'] as Map<String, dynamic>;
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'Feature', 'geometry': geometry?.toJson()};
    if (properties != null) m['properties'] = properties;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  /// Returns the bounding box for the geometry, calculating it if necessary.
  GeoJsonBoundingBox get boundingBox => _bbox ??= geometry?.boundingBox ?? new GeoJsonBoundingBox(0, 0, 0, 0);

  AngleRange get latitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return new AngleRange(new Angle(deg: box.minLatitude), new Angle(deg: box.maxLatitude));
  }

  AngleRange get longitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return new AngleRange(new Angle(deg: box.minLongitude), new Angle(deg: box.maxLongitude));
  }

  GeoCoord get center {
    final GeoJsonBoundingBox box = boundingBox;
    return new GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2, longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

abstract class GeoJsonGeometry {
  GeoJsonGeometry();

  factory GeoJsonGeometry.fromJson(Map<String, dynamic> m) {
    final String type = m['type'] as String;
    if (type == 'Point') return new GeoJsonPoint.fromJson(m);
    if (type == 'MultiPoint') return new GeoJsonMultiPoint.fromJson(m);
    if (type == 'LineString') return new GeoJsonLineString.fromJson(m);
    if (type == 'MultiLineString') return new GeoJsonMultiLineString.fromJson(m);
    if (type == 'Polygon') return new GeoJsonPolygon.fromJson(m);
    if (type == 'MultiPolygon') return new GeoJsonMultiPolygon.fromJson(m);
    if (type == 'GeometryCollection') return new GeoJsonGeometryCollection.fromJson(m);
    return null;
  }

  GeoJsonBoundingBox _bbox;

  dynamic toJson();

  /// Returns the bounding box for the geometry, calculating it if necessary.
  ///
  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null) _calculateBoundingBox();
    return _bbox;
  }

  void _calculateBoundingBox();

  AngleRange get latitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return new AngleRange(new Angle(deg: box.minLatitude), new Angle(deg: box.maxLatitude));
  }

  AngleRange get longitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return new AngleRange(new Angle(deg: box.minLongitude), new Angle(deg: box.maxLongitude));
  }

  GeoCoord get center {
    final GeoJsonBoundingBox box = boundingBox;
    return new GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2, longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

class GeoJsonPoint extends GeoJsonGeometry {
  GeoJsonPoint([this.coordinate]);

  GeoJsonPoint.fromJson(Map<dynamic, dynamic> m) {
    if (m['coordinates'] is List) {
      coordinate = new GeoJsonCoordinate(m['coordinates'][0] as num, m['coordinates'][1] as num);
    }
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  GeoJsonPoint.longLat(List<num> array) : coordinate = new GeoJsonCoordinate(array[0], array[1]);

  GeoJsonCoordinate coordinate;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'Point', 'coordinates': coordinate.toJson()};
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    _bbox =
        new GeoJsonBoundingBox(coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude);
  }
}

class GeoJsonMultiPoint extends GeoJsonGeometry {
  GeoJsonMultiPoint();

  GeoJsonMultiPoint.fromJson(Map<dynamic, dynamic> m) {
    if (m['coordinates'] is List) {
      for (dynamic c in m['coordinates']) {
        if (c is List && c.length > 1) coordinates.add(new GeoJsonCoordinate(c[0] as num, c[1] as num));
      }
    }
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'MultiPoint'};
    final List<List<num>> coordJson = <List<num>>[];
    for (GeoJsonCoordinate coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m['coordinates'] = coordJson;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (GeoJsonCoordinate c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox = new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

class GeoJsonLineString extends GeoJsonGeometry {
  GeoJsonLineString();

  GeoJsonLineString.fromJson(Map<dynamic, dynamic> m) {
    if (m['coordinates'] is List) {
      for (dynamic c in m['coordinates']) {
        if (c is List && c.length > 1) coordinates.add(new GeoJsonCoordinate(c[0] as num, c[1] as num));
      }
    }
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'LineString'};
    final List<List<num>> coordJson = <List<num>>[];
    for (GeoJsonCoordinate coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m['coordinates'] = coordJson;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (GeoJsonCoordinate c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox = new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

class GeoJsonMultiLineString extends GeoJsonGeometry {
  GeoJsonMultiLineString();

  GeoJsonMultiLineString.fromJson(Map<String, dynamic> m) {
    if (m['coordinates'] is List) {
      for (dynamic lineString in m['coordinates']) {
        if (lineString is List) {
          final List<GeoJsonCoordinate> coords = <GeoJsonCoordinate>[];
          for (dynamic c in lineString) {
            coords.add(new GeoJsonCoordinate(c[0] as num, c[1] as num));
          }
          lineStrings.add(new GeoJsonLineString()..coordinates.addAll(coords));
        }
      }
    }
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  final List<GeoJsonLineString> lineStrings = <GeoJsonLineString>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'MultiLineString'};
    final List<List<List<num>>> coordJson = <List<List<num>>>[];
    for (GeoJsonLineString lineString in lineStrings) {
      final List<List<num>> list = <List<num>>[];
      for (GeoJsonCoordinate coord in lineString.coordinates) {
        list.add(coord.toJson());
      }
      coordJson.add(list);
    }
    m['coordinates'] = coordJson;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (lineStrings.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    GeoJsonBoundingBox box;
    for (GeoJsonLineString ls in lineStrings) {
      box = (box == null) ? ls.boundingBox : new GeoJsonBoundingBox.merge(box, ls.boundingBox);
    }
    _bbox = box;
  }
}

/// A LinearRing is a closed LineString with 4 or more positions. The first and last
/// positions are equivalent (they represent equivalent points). Though a LinearRing
/// is not explicitly represented as a GeoJSON geometry type, it is referred to in
/// the Polygon geometry type definition.
class GeoJsonLinearRing extends GeoJsonGeometry {
  GeoJsonLinearRing();

  GeoJsonLinearRing.fromJson(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (dynamic x in jsonList) {
      if (x is List && x.length > 1) coordinates.add(new GeoJsonCoordinate(x[0] as num, x[1] as num));
    }
  }

  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  @override
  List<List<num>> toJson() {
    final List<List<num>> list = <List<num>>[];
    for (GeoJsonCoordinate c in coordinates) {
      list.add(c.toJson());
    }
    return list;
  }

  @override
  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (GeoJsonCoordinate c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox = new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

/// Coordinates of a Polygon are an array of LinearRing coordinate arrays.
/// The first element in the array represents the exterior ring. Any subsequent
/// elements represent interior rings (or holes).
///
class GeoJsonPolygon extends GeoJsonGeometry {
  GeoJsonPolygon([this.exteriorRing, List<GeoJsonLinearRing> holes]) {
    if (holes?.isNotEmpty == true) interiorRings.addAll(holes);
  }

  GeoJsonPolygon.fromJson(Map<String, dynamic> m) {
    if (m['coordinates'] is List) {
      final List<List<dynamic>> rings = m['coordinates'] as List<List<dynamic>>;
      if (rings.isEmpty) return;
      exteriorRing = new GeoJsonLinearRing.fromJson(rings.first);
      for (int i = 1; i < rings.length; i++) {
        interiorRings.add(new GeoJsonLinearRing.fromJson(rings[i]));
      }
    }
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  GeoJsonLinearRing exteriorRing;
  final List<GeoJsonLinearRing> interiorRings = <GeoJsonLinearRing>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'Polygon'};
    final List<List<List<num>>> rings = <List<List<num>>>[];
    if (exteriorRing != null) rings.add(exteriorRing.toJson());
    for (GeoJsonLinearRing hole in interiorRings) {
      rings.add(hole.toJson());
    }
    m['coordinates'] = rings;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    GeoJsonBoundingBox box = exteriorRing != null ? exteriorRing.boundingBox : new GeoJsonBoundingBox(0, 0, 0, 0);
    for (GeoJsonLinearRing ir in interiorRings) {
      box = new GeoJsonBoundingBox.merge(box, ir.boundingBox);
    }
    _bbox = box;
  }
}

class GeoJsonMultiPolygon extends GeoJsonGeometry {
  GeoJsonMultiPolygon([List<GeoJsonPolygon> polys]) {
    if (polys != null) polygons.addAll(polys);
  }

  //TODO
  GeoJsonMultiPolygon.fromJson(Map<String, dynamic> m) {
    if (m['coordinates'] is List) {
      /*
      final List<List<GeoJsonPolygon>> polys = m['coordinates'] as List<List<GeoJsonPolygon>>;
      if (polys.isEmpty) return;
      for (List<dynamic> poly in polys) {
        final Iterable<dynamic> holes =
            poly.length > 1 ? poly.where((dynamic ring) => ring != poly.first) : <dynamic>[];
        final GeoJsonLinearRing exterior = new GeoJsonLinearRing();
        for (GeoJsonPolygon c in poly.first) {
          exterior.coordinates.add(new GeoJsonCoordinate(c[0] as num, c[1] as num));
        }
        final List<GeoJsonLinearRing> interior = <GeoJsonLinearRing>[];
        for (dynamic h in holes) {
          final GeoJsonLinearRing inRing = new GeoJsonLinearRing();
          for (dynamic hc in h) {
            inRing.coordinates.add(new GeoJsonCoordinate(hc[0] as num, hc[1] as num));
          }
          interior.add(inRing);
        }
        polygons.add(new GeoJsonPolygon(exterior, interior));
      }*/
    }
    if (m['bbox'] is List<num>)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  final List<GeoJsonPolygon> polygons = <GeoJsonPolygon>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'MultiPolygon'};
    final List<dynamic> list = <dynamic>[];
    for (GeoJsonPolygon p in polygons) {
      final Map<String, dynamic> polyJson = p.toJson();
      list.add(polyJson['coordinates']);
    }
    m['coordinates'] = list;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (polygons.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (GeoJsonPolygon p in polygons) {
      box = box == null ? p.boundingBox : new GeoJsonBoundingBox.merge(box, p.boundingBox);
    }
    _bbox = box;
  }
}

class GeoJsonGeometryCollection extends GeoJsonGeometry {
  GeoJsonGeometryCollection();

  GeoJsonGeometryCollection.fromJson(Map<String, dynamic> m) {
    if (m['geometries'] is List) {
      for (Map<String, dynamic> g in m['geometries']) {
        geometries.add(new GeoJsonGeometry.fromJson(g));
      }
    }
    if (m['bbox'] is List)
      _bbox =
          new GeoJsonBoundingBox(m['bbox'][0] as num, m['bbox'][1] as num, m['bbox'][2] as num, m['bbox'][3] as num);
  }

  final List<GeoJsonGeometry> geometries = <GeoJsonGeometry>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'GeometryCollection'};
    final List<dynamic> list = <dynamic>[];
    for (GeoJsonGeometry g in geometries) {
      list.add(g.toJson());
    }
    m['geometries'] = list;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (geometries.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (GeoJsonGeometry g in geometries) {
      box = box == null ? g.boundingBox : new GeoJsonBoundingBox.merge(box, g.boundingBox);
    }
    _bbox = box;
  }
}
