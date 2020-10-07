import 'dart:convert';
import 'dart:math' show min, max;
import 'package:quantity/quantity.dart';
import 'geocoord.dart';

/// GeoJSON is a format for encoding a variety of geographic data structures.
/// A GeoJson object may represent a geometry, a feature, or a collection of
/// features. GeoJSON supports the following geometry types: Point, LineString,
/// Polygon, MultiPoint, MultiLineString, MultiPolygon, and GeometryCollection.
/// Features in GeoJSON contain a geometry object and additional properties,
/// and a feature collection represents a list of features.
class GeoJson {
  /// Constructs a instance by parsing [str].
  factory GeoJson.string(String str) => GeoJson.map(json.decode(str) as Map<String, dynamic>);

  /// Constructs a instance from the value in a [map].
  GeoJson.map(Map<String, dynamic> map) {
    applyMap(map);
  }

  // Will only be one of these.

  /// A feature collection.
  GeoJsonFeatureCollection featureCollection;

  /// A single feature.
  GeoJsonFeature feature;

  /// A single geometry.
  GeoJsonGeometry geometry;

  GeoJsonBoundingBox _bbox;

  /// Applies the values in a [map] to this instance.
  void applyMap(Map<String, dynamic> map) {
    if (map == null) return;
    if (map['type'] == 'FeatureCollection') {
      featureCollection = GeoJsonFeatureCollection.fromJson(map);
    } else if (map['type'] == 'Feature') {
      feature = GeoJsonFeature.fromJson(map);
    } else {
      // Must be a geometry of some kind.
      geometry = GeoJsonGeometry.fromJson(map);
    }
  }

  /// Returns a valid JSON object for the geometry, feature or feature collection
  /// held by this instance.
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
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
    }
  }

  /// The range of latitudes spanned by the feature collection, feature or geometry.
  AngleRange get latitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return AngleRange(Angle(deg: box.minLatitude), Angle(deg: box.maxLatitude));
  }

  /// The range of longitudes spanned by the feature collection, feature or geometry.
  AngleRange get longitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return AngleRange(Angle(deg: box.minLongitude), Angle(deg: box.maxLongitude));
  }

  /// The center of the bounding box of the feature collection, feature or geometry.
  GeoCoord get center {
    final GeoJsonBoundingBox box = boundingBox;
    return GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2, longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

/// A GeoJSON geographic coordinate.
class GeoJsonCoordinate {
  /// Constructs a instance from a latitude and longitude.
  GeoJsonCoordinate(this.longitude, this.latitude);

  /// Constructs a instance from a two-member numerical list
  /// (the JSON format that GeoJSON uses to model a coordinate).
  GeoJsonCoordinate.fromJson(List<num> longLat) {
    longitude = longLat[0];
    latitude = longLat[1];
  }

  /// The longitude.
  num longitude;

  /// The latitude.
  num latitude;

  /// Returns a list of two numbers, the JSON format that GeoJSON uses to model a coordinate.
  List<num> toJson() => <num>[longitude ?? 0, latitude ?? 0];
}

/// Geographic bounds.
class GeoJsonBoundingBox {
  /// Constructs a instance.  Angles are in degrees and the order is minimum longitude and
  /// latitude then maximum longitude and latitude.
  GeoJsonBoundingBox([this.minLongitude, this.minLatitude, this.maxLongitude, this.maxLatitude]);

  /// Combine two bounding boxes such that returned bounding box contains them both.
  factory GeoJsonBoundingBox.merge(GeoJsonBoundingBox box1, GeoJsonBoundingBox box2) {
    final num minLatDeg = min(box1.minLatitude, box2.minLatitude);
    final num minLongDeg = min(box1.minLongitude, box2.minLongitude);
    final num maxLatDeg = max(box1.maxLatitude, box2.maxLatitude);
    final num maxLongDeg = max(box1.maxLongitude, box2.maxLongitude);
    return GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }

  /// The minimum longitude.
  num minLongitude;

  /// The minimum latitude.
  num minLatitude;

  /// The maximum longitude.
  num maxLongitude;

  /// The maximum latitude.
  num maxLatitude;

  /// Returns a list of four angles, the JSON format that GeoJSON uses to model a bounding box.
  /// The angles are in degrees and the order is minimum longitude and
  /// latitude then maximum longitude and latitude.
  List<num> toJson() => <num>[minLongitude, minLatitude, maxLongitude, maxLatitude];
}

/// A GeoJSON feature collection.
class GeoJsonFeatureCollection {
  /// Constructs a instance by using the values in a [map].
  GeoJsonFeatureCollection.fromJson(Map<String, dynamic> map) {
    if (map == null) return;
    final dynamic list = map['features'];
    if (list is List) {
      for (final dynamic x in list) {
        if (x is Map<String, dynamic>) features.add(GeoJsonFeature.fromJson(x));
      }
    }
    if (map['bbox'] is List<num>) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// Returns the JSON format that GeoJSON uses to model a feature collection.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'FeatureCollection'};
    final List<dynamic> list = <dynamic>[];
    for (final GeoJsonFeature f in features) {
      list.add(f.toJson());
    }
    m['features'] = list;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  /// The feature collection.
  final List<GeoJsonFeature> features = <GeoJsonFeature>[];

  GeoJsonBoundingBox _bbox;

  /// Gets the bounding box that surrounds the features.
  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null) _calculateBoundingBox();
    return _bbox;
  }

  void _calculateBoundingBox() {
    if (features.isEmpty) {
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (final GeoJsonFeature f in features) {
      box = box == null ? f.boundingBox : GeoJsonBoundingBox.merge(box, f.boundingBox);
    }
    _bbox = box;
  }
}

/// A GeoJSON feature.
class GeoJsonFeature {
  /// Constructs a instance, optionally with an existing geometry and properties.
  GeoJsonFeature([this.geometry, this.properties]);

  /// Constructs a instance from a map.
  GeoJsonFeature.fromJson(Map<String, dynamic> m) {
    applyMap(m);
  }

  /// The feature's geometry.
  GeoJsonGeometry geometry;

  /// The feature's properties.
  Map<String, dynamic> properties;

  GeoJsonBoundingBox _bbox;

  /// Applies the values in [map] to this feature.
  void applyMap(Map<String, dynamic> map) {
    if (map == null) return;
    if (map['geometry'] is Map) geometry = GeoJsonGeometry.fromJson(map['geometry'] as Map<String, dynamic>);
    if (map['properties'] is Map) properties = map['properties'] as Map<String, dynamic>;
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// Returns a map, the JSON format that GeoJSON uses to model a feature.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'Feature', 'geometry': geometry?.toJson()};
    if (properties != null) m['properties'] = properties;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  /// Returns the bounding box for the geometry, calculating it if necessary.
  GeoJsonBoundingBox get boundingBox => _bbox ??= geometry?.boundingBox ?? GeoJsonBoundingBox(0, 0, 0, 0);

  /// The range of latitudes spanned by the feature.
  AngleRange get latitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return AngleRange(Angle(deg: box.minLatitude), Angle(deg: box.maxLatitude));
  }

  /// The range of longitudes spanned by the feature.
  AngleRange get longitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return AngleRange(Angle(deg: box.minLongitude), Angle(deg: box.maxLongitude));
  }

  /// The center of the bounding box of the feature.
  GeoCoord get center {
    final GeoJsonBoundingBox box = boundingBox;
    return GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2, longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

/// An abstract base class for GeoJSON geometries.
abstract class GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonGeometry();

  /// This factory constructor creates a typed instance of a particular
  /// GeoJSON geometry based on the values in [map].
  factory GeoJsonGeometry.fromJson(Map<String, dynamic> map) {
    final String type = map['type'] as String;
    if (type == 'Point') return GeoJsonPoint.fromJson(map);
    if (type == 'MultiPoint') return GeoJsonMultiPoint.fromJson(map);
    if (type == 'LineString') return GeoJsonLineString.fromJson(map);
    if (type == 'MultiLineString') return GeoJsonMultiLineString.fromJson(map);
    if (type == 'Polygon') return GeoJsonPolygon.fromJson(map);
    if (type == 'MultiPolygon') return GeoJsonMultiPolygon.fromJson(map);
    if (type == 'GeometryCollection') return GeoJsonGeometryCollection.fromJson(map);
    return null;
  }

  GeoJsonBoundingBox _bbox;

  /// Geometries must be able to provide themselves in GeoJSON format.
  dynamic toJson();

  /// Returns the bounding box for the geometry, calculating it if necessary.
  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null) _calculateBoundingBox();
    return _bbox;
  }

  void _calculateBoundingBox();

  /// The range of latitudes that the geometry spans.
  AngleRange get latitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return AngleRange(Angle(deg: box.minLatitude), Angle(deg: box.maxLatitude));
  }

  /// The range of longitudes that the geometry spans.
  AngleRange get longitudeRange {
    final GeoJsonBoundingBox box = boundingBox;
    return AngleRange(Angle(deg: box.minLongitude), Angle(deg: box.maxLongitude));
  }

  /// The center of the geometry's bounding box.
  GeoCoord get center {
    final GeoJsonBoundingBox box = boundingBox;
    return GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2, longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

/// A GeoJSON point geometry.
class GeoJsonPoint extends GeoJsonGeometry {
  /// Constructs a instance, optionally with an existing coordinate.
  GeoJsonPoint([this.coordinate]);

  /// Construct a instance, applying the values in [map].
  GeoJsonPoint.fromJson(Map<dynamic, dynamic> map) {
    if (map['coordinates'] is List) {
      coordinate = GeoJsonCoordinate(map['coordinates'][0] as num, map['coordinates'][1] as num);
    }
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// Construct a instance, using the values in [array], .
  GeoJsonPoint.longLat(List<num> array) : coordinate = GeoJsonCoordinate(array[0], array[1]);

  /// The point's geocoordinate.
  GeoJsonCoordinate coordinate;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'Point', 'coordinates': coordinate.toJson()};
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    _bbox = GeoJsonBoundingBox(coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude);
  }
}

/// A GeoJSON multipoint geometry.
class GeoJsonMultiPoint extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonMultiPoint();

  /// Constructs a instance from the values in [map].
  GeoJsonMultiPoint.fromJson(Map<dynamic, dynamic> map) {
    if (map['coordinates'] is List) {
      for (final dynamic c in map['coordinates']) {
        if (c is List && c.length > 1) coordinates.add(GeoJsonCoordinate(c[0] as num, c[1] as num));
      }
    }
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// The point coordinates.
  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'MultiPoint'};
    final List<List<num>> coordJson = <List<num>>[];
    for (final GeoJsonCoordinate coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m['coordinates'] = coordJson;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (final GeoJsonCoordinate c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox = GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

/// A GeoJSON line string geometry.
class GeoJsonLineString extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonLineString();

  /// Constructs a instance from the values in [map].
  GeoJsonLineString.fromJson(Map<dynamic, dynamic> map) {
    if (map['coordinates'] is List) {
      for (final dynamic c in map['coordinates']) {
        if (c is List && c.length > 1) coordinates.add(GeoJsonCoordinate(c[0] as num, c[1] as num));
      }
    }
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// The line coordinates.
  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'LineString'};
    final List<List<num>> coordJson = <List<num>>[];
    for (final GeoJsonCoordinate coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m['coordinates'] = coordJson;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (final GeoJsonCoordinate c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox = GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

/// A GeoJSON multiline string geometry.
class GeoJsonMultiLineString extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonMultiLineString();

  /// Constructs a instance from the values in [map].
  GeoJsonMultiLineString.fromJson(Map<String, dynamic> map) {
    if (map['coordinates'] is List) {
      for (final dynamic lineString in map['coordinates']) {
        if (lineString is List) {
          final List<GeoJsonCoordinate> coords = <GeoJsonCoordinate>[];
          for (final dynamic c in lineString) {
            coords.add(GeoJsonCoordinate(c[0] as num, c[1] as num));
          }
          lineStrings.add(GeoJsonLineString()..coordinates.addAll(coords));
        }
      }
    }
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// This geometry's component line string geometry's.
  final List<GeoJsonLineString> lineStrings = <GeoJsonLineString>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'MultiLineString'};
    final List<List<List<num>>> coordJson = <List<List<num>>>[];
    for (final GeoJsonLineString lineString in lineStrings) {
      final List<List<num>> list = <List<num>>[];
      for (final GeoJsonCoordinate coord in lineString.coordinates) {
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
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    GeoJsonBoundingBox box;
    for (final GeoJsonLineString ls in lineStrings) {
      box = (box == null) ? ls.boundingBox : GeoJsonBoundingBox.merge(box, ls.boundingBox);
    }
    _bbox = box;
  }
}

/// A LinearRing is a closed LineString with 4 or more positions. The first and last
/// positions are equivalent (they represent equivalent points). Though a LinearRing
/// is not explicitly represented as a GeoJSON geometry type, it is referred to in
/// the Polygon geometry type definition.
class GeoJsonLinearRing extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonLinearRing();

  /// Constructs a instance from the values in [jsonList].
  GeoJsonLinearRing.fromJson(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (final dynamic x in jsonList) {
      if (x is List && x.length > 1) coordinates.add(GeoJsonCoordinate(x[0] as num, x[1] as num));
    }
  }

  /// The linear ring's coordinates.
  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  @override
  List<List<num>> toJson() {
    final List<List<num>> list = <List<num>>[];
    for (final GeoJsonCoordinate c in coordinates) {
      list.add(c.toJson());
    }
    return list;
  }

  @override
  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (final GeoJsonCoordinate c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox = GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

/// Coordinates of a Polygon are an array of LinearRing coordinate arrays.
/// The first element in the array represents the exterior ring. Any subsequent
/// elements represent interior rings (or holes).
class GeoJsonPolygon extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonPolygon([this.exteriorRing, List<GeoJsonLinearRing> holes]) {
    if (holes?.isNotEmpty == true) interiorRings.addAll(holes);
  }

  /// Constructs a instance from the values in [map].
  GeoJsonPolygon.fromJson(Map<String, dynamic> map) {
    if (map['coordinates'] is List) {
      final List<List<dynamic>> rings = map['coordinates'] as List<List<dynamic>>;
      if (rings.isEmpty) return;
      exteriorRing = GeoJsonLinearRing.fromJson(rings.first);
      for (int i = 1; i < rings.length; i++) {
        interiorRings.add(GeoJsonLinearRing.fromJson(rings[i]));
      }
    }
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// A single exterior ring.
  GeoJsonLinearRing exteriorRing;

  /// Any number of interior rings.
  final List<GeoJsonLinearRing> interiorRings = <GeoJsonLinearRing>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'Polygon'};
    final List<List<List<num>>> rings = <List<List<num>>>[];
    if (exteriorRing != null) rings.add(exteriorRing.toJson());
    for (final GeoJsonLinearRing hole in interiorRings) {
      rings.add(hole.toJson());
    }
    m['coordinates'] = rings;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    GeoJsonBoundingBox box = exteriorRing != null ? exteriorRing.boundingBox : GeoJsonBoundingBox(0, 0, 0, 0);
    for (final GeoJsonLinearRing ir in interiorRings) {
      box = GeoJsonBoundingBox.merge(box, ir.boundingBox);
    }
    _bbox = box;
  }
}

/// A GeoJSON multipolygon geometry.
class GeoJsonMultiPolygon extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonMultiPolygon([List<GeoJsonPolygon> polys]) {
    if (polys != null) polygons.addAll(polys);
  }

  /// Constructs a instance from the values in [map].
  GeoJsonMultiPolygon.fromJson(Map<String, dynamic> map) {
    if (map['coordinates'] is List) {
      final List<dynamic> polys = map['coordinates'] as List<dynamic>;
      if (polys.isEmpty) return;
      for (final dynamic poly in polys) {
        polygons.add(GeoJsonPolygon.fromJson(<String, dynamic>{'coordinates': poly}));
      }
    }
    if (map['bbox'] is List<num>) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// This geometry's component polygon geometries.
  final List<GeoJsonPolygon> polygons = <GeoJsonPolygon>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'MultiPolygon'};
    final List<dynamic> list = <dynamic>[];
    for (final GeoJsonPolygon p in polygons) {
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
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (final GeoJsonPolygon p in polygons) {
      box = box == null ? p.boundingBox : GeoJsonBoundingBox.merge(box, p.boundingBox);
    }
    _bbox = box;
  }
}

/// A GeoJSON geometry collection.
class GeoJsonGeometryCollection extends GeoJsonGeometry {
  /// Constructs a instance.
  GeoJsonGeometryCollection();

  /// Constructs a instance from the values in [map].
  GeoJsonGeometryCollection.fromJson(Map<String, dynamic> map) {
    if (map['geometries'] is List) {
      for (final Map<String, dynamic> g in map['geometries'] as List<Map<String, dynamic>>) {
        geometries.add(GeoJsonGeometry.fromJson(g));
      }
    }
    if (map['bbox'] is List) {
      _bbox = GeoJsonBoundingBox(
          map['bbox'][0] as num, map['bbox'][1] as num, map['bbox'][2] as num, map['bbox'][3] as num);
    }
  }

  /// This geometry's component geometries.
  final List<GeoJsonGeometry> geometries = <GeoJsonGeometry>[];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> m = <String, dynamic>{'type': 'GeometryCollection'};
    final List<dynamic> list = <dynamic>[];
    for (final GeoJsonGeometry g in geometries) {
      list.add(g.toJson());
    }
    m['geometries'] = list;
    if (_bbox != null) m['bbox'] = _bbox.toJson();
    return m;
  }

  @override
  void _calculateBoundingBox() {
    if (geometries.isEmpty) {
      _bbox = GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (final GeoJsonGeometry g in geometries) {
      box = box == null ? g.boundingBox : GeoJsonBoundingBox.merge(box, g.boundingBox);
    }
    _bbox = box;
  }
}
