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
///
class GeoJson {

  // Will only be one of these
  GeoJsonFeatureCollection featureCollection;
  GeoJsonFeature feature;
  GeoJsonGeometry geometry;

  GeoJsonBoundingBox _bbox;

  factory GeoJson.string(String str) => new GeoJson.map(JSON.decode(str) as Map);

  GeoJson.map(Map m) {
    applyMap(m);
  }

  void applyMap(Map m) {
    if (m == null) return;
    if (m["type"] == "FeatureCollection") {
      featureCollection = new GeoJsonFeatureCollection.fromJson(m);
    } else if (m["type"] == "Feature") {
      feature = new GeoJsonFeature.fromJson(m);
    } else {
      // Must be a geometry of some kind
      geometry = new GeoJsonGeometry.fromJson(m);
    }
  }

  Map toJson() {
    if (featureCollection != null) return featureCollection.toJson();
    if (feature != null) return feature.toJson();
    if (geometry != null) return geometry.toJson() as Map;
    return null;
  }

  /// Returns the bounding box for the geometry, calculating it if necessary.
  ///
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
    var box = this.boundingBox;
    return new AngleRange(
        new Angle(deg: box.minLatitude), new Angle(deg: box.maxLatitude));
  }

  AngleRange get longitudeRange {
    var box = this.boundingBox;
    return new AngleRange(
        new Angle(deg: box.minLongitude), new Angle(deg: box.maxLongitude));
  }

  GeoCoord get center {
    var box = this.boundingBox;
    return new GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2,
        longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}

class GeoJsonCoordinate {
  num longitude;
  num latitude;

  GeoJsonCoordinate(this.longitude, this.latitude);

  GeoJsonCoordinate.fromJson(List<num> longLat) {
    longitude = longLat[0];
    latitude = longLat[1];
  }

  List<num> toJson() => [longitude ?? 0, latitude ?? 0];
}

class GeoJsonBoundingBox {
  num minLongitude;
  num minLatitude;
  num maxLongitude;
  num maxLatitude;

  /// Angles are in degrees.
  ///
  GeoJsonBoundingBox(
      [this.minLongitude, this.minLatitude, this.maxLongitude, this.maxLatitude]);

  List<num> toJson() => <num>[minLongitude, minLatitude, maxLongitude, maxLatitude];

  /// Combine two bounding boxes such that returned bounding box contains them both.
  ///
  static GeoJsonBoundingBox merge(GeoJsonBoundingBox box1,
      GeoJsonBoundingBox box2) {
    num minLatDeg = min(box1.minLatitude, box2.minLatitude);
    num minLongDeg = min(box1.minLongitude, box2.minLongitude);
    num maxLatDeg = max(box1.maxLatitude, box2.maxLatitude);
    num maxLongDeg = max(box1.maxLongitude, box2.maxLongitude);
    return new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }

}


class GeoJsonFeatureCollection {

  final List<GeoJsonFeature> features = [];

  GeoJsonBoundingBox _bbox;


  GeoJsonFeatureCollection.fromJson(Map m) {
    if (m == null) return;
    dynamic list = m["features"];
    if (list is List) {
      for (var x in list) {
        if (x is Map) features.add(new GeoJsonFeature.fromJson(x));
      }
    }
    if (m["bbox"] is List<num>) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }

  Map toJson() {
    Map m = <String, dynamic>{"type": "FeatureCollection"};
    List list = <dynamic>[];
    for (var f in features) {
      list.add(f.toJson());
    }
    m["features"] = list;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

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
    for (var f in features) {
      box = box == null ? f.boundingBox : GeoJsonBoundingBox.merge(
          box, f.boundingBox);
    }
    _bbox = box;
  }


}

class GeoJsonFeature {

  GeoJsonGeometry geometry;

  Map properties;

  GeoJsonBoundingBox _bbox;

  GeoJsonFeature([this.geometry, this.properties]);

  GeoJsonFeature.fromJson(Map m) {
    applyMap(m);
  }

  void applyMap(Map m) {
    if (m == null) return;
    if (m["geometry"] is Map)
      geometry = new GeoJsonGeometry.fromJson(m["geometry"] as Map<dynamic, dynamic>);
    if (m["properties"] is Map) properties = m["properties"] as Map;
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }

  Map toJson() {
    Map m = <String, dynamic>{"type":"Feature", "geometry": geometry?.toJson()};
    if (properties != null) m["properties"] = properties;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  /// Returns the bounding box for the geometry, calculating it if necessary.
  ///
  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null)
      _bbox = geometry?.boundingBox ?? new GeoJsonBoundingBox(0, 0, 0, 0);
    return _bbox;
  }


  AngleRange get latitudeRange {
    var box = this.boundingBox;
    return new AngleRange(
        new Angle(deg: box.minLatitude), new Angle(deg: box.maxLatitude));
  }

  AngleRange get longitudeRange {
    var box = this.boundingBox;
    return new AngleRange(
        new Angle(deg: box.minLongitude), new Angle(deg: box.maxLongitude));
  }

  GeoCoord get center {
    var box = this.boundingBox;
    return new GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2,
        longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}


abstract class GeoJsonGeometry {

  GeoJsonBoundingBox _bbox;

  GeoJsonGeometry();

  factory GeoJsonGeometry.fromJson(Map<dynamic, dynamic> m) {
    String type = m["type"] as String;
    if (type == "Point") return new GeoJsonPoint.fromJson(m);
    if (type == "MultiPoint") return new GeoJsonMultiPoint.fromJson(m);
    if (type == "LineString") return new GeoJsonLineString.fromJson(m);
    if (type == "MultiLineString") return new GeoJsonMultiLineString.fromJson(
        m);
    if (type == "Polygon") return new GeoJsonPolygon.fromJson(m);
    if (type == "MultiPolygon") return new GeoJsonMultiPolygon.fromJson(m);
    if (type == "GeometryCollection") return new GeoJsonGeometryCollection
        .fromJson(m);
    return null;
  }

  dynamic toJson();

  /// Returns the bounding box for the geometry, calculating it if necessary.
  ///
  GeoJsonBoundingBox get boundingBox {
    if (_bbox == null) _calculateBoundingBox();
    return _bbox;
  }

  void _calculateBoundingBox();

  AngleRange get latitudeRange {
    var box = this.boundingBox;
    return new AngleRange(
        new Angle(deg: box.minLatitude), new Angle(deg: box.maxLatitude));
  }

  AngleRange get longitudeRange {
    var box = this.boundingBox;
    return new AngleRange(
        new Angle(deg: box.minLongitude), new Angle(deg: box.maxLongitude));
  }

  GeoCoord get center {
    var box = this.boundingBox;
    return new GeoCoord.degrees(
        latDeg: (box.maxLatitude + box.minLatitude) / 2,
        longDeg: (box.maxLongitude + box.minLongitude) / 2);
  }
}


class GeoJsonPoint extends GeoJsonGeometry {
  GeoJsonCoordinate coordinate;

  GeoJsonPoint([this.coordinate]);

  GeoJsonPoint.fromJson(Map m) {
    if (m["coordinates"] is List) {
      coordinate =
      new GeoJsonCoordinate(m["coordinates"][0] as num, m["coordinates"][1] as num);
    }
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }

  GeoJsonPoint.longLat(List<num> array)
      : coordinate = new GeoJsonCoordinate(array[0], array[1]);

  Map toJson() {
    var m = {"type": "Point", "coordinates": coordinate.toJson()};
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    _bbox =
    new GeoJsonBoundingBox(
        coordinate.latitude, coordinate.longitude, coordinate.latitude,
        coordinate.longitude);
  }

}

class GeoJsonMultiPoint extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonMultiPoint();

  GeoJsonMultiPoint.fromJson(Map m) {
    if (m["coordinates"] is List) {
      for (var c in m["coordinates"]) {
        if (c is List && c.length > 1) coordinates.add(
            new GeoJsonCoordinate(c[0] as num, c[1] as num));
      }
    }
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }


  Map<String, dynamic> toJson() {
    var m = <String, dynamic>{
      "type": "MultiPoint"
    };
    List<List<num>> coordJson = [];
    for (var coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m["coordinates"] = coordJson;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (var c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox =
    new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }

}

class GeoJsonLineString extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonLineString();

  GeoJsonLineString.fromJson(Map m) {
    if (m["coordinates"] is List) {
      for (var c in m["coordinates"]) {
        if (c is List && c.length > 1) coordinates.add(
            new GeoJsonCoordinate(c[0] as num, c[1] as num));
      }
    }
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }


  Map<String, dynamic> toJson() {
    var m = <String, dynamic>{
      "type": "LineString"
    };
    List<List<num>> coordJson = [];
    for (var coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m["coordinates"] = coordJson;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (var c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox =
    new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}

class GeoJsonMultiLineString extends GeoJsonGeometry {
  final List<GeoJsonLineString> lineStrings = <GeoJsonLineString>[];

  GeoJsonMultiLineString();

  GeoJsonMultiLineString.fromJson(Map m) {
    if (m["coordinates"] is List) {
      for (var lineString in m["coordinates"]) {
        if (lineString is List) {
          List<GeoJsonCoordinate> coords = [];
          for (var c in lineString) {
            coords.add(new GeoJsonCoordinate(c[0] as num, c[1] as num));
          }
          lineStrings.add(new GeoJsonLineString()
            ..coordinates.addAll(coords));
        }
      }
    }
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }


  Map<String, dynamic> toJson() {
    var m = <String, dynamic>{
      "type": "MultiLineString"
    };
    List<List<List<num>>> coordJson = <List<List<num>>>[];
    for (var lineString in lineStrings) {
      List<List<num>> list = <List<num>>[];
      for (GeoJsonCoordinate coord in lineString.coordinates) {
        list.add(coord.toJson());
      }
      coordJson.add(list);
    }
    m["coordinates"] = coordJson;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    if (lineStrings.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    GeoJsonBoundingBox box;
    for (var ls in lineStrings) {
      box = (box == null) ? ls.boundingBox : GeoJsonBoundingBox.merge(
          box, ls.boundingBox);
    }
    _bbox = box;
  }
}

/// A LinearRing is a closed LineString with 4 or more positions. The first and last
/// positions are equivalent (they represent equivalent points). Though a LinearRing
/// is not explicitly represented as a GeoJSON geometry type, it is referred to in
/// the Polygon geometry type definition.
///
class GeoJsonLinearRing extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = <GeoJsonCoordinate>[];

  GeoJsonLinearRing();

  GeoJsonLinearRing.fromJson(List jsonList) {
    if (jsonList == null) return;
    for (var x in jsonList) {
      if (x is List && x.length > 1) coordinates.add(
          new GeoJsonCoordinate(x[0] as num, x[1] as num));
    }
  }

  List<List<num>> toJson() {
    List<List<num>> list = <List<num>>[];
    for (GeoJsonCoordinate c in coordinates) {
      list.add(c.toJson());
    }
    return list;
  }

  void _calculateBoundingBox() {
    if (coordinates.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }

    num minLatDeg = 1000;
    num minLongDeg = 1000;
    num maxLatDeg = -1000;
    num maxLongDeg = -1000;
    for (var c in coordinates) {
      minLongDeg = min(minLongDeg, c.longitude);
      minLatDeg = min(minLatDeg, c.latitude);
      maxLongDeg = max(maxLongDeg, c.longitude);
      maxLatDeg = max(maxLatDeg, c.latitude);
    }
    _bbox =
    new GeoJsonBoundingBox(minLongDeg, minLatDeg, maxLongDeg, maxLatDeg);
  }
}


/// Coordinates of a Polygon are an array of LinearRing coordinate arrays.
/// The first element in the array represents the exterior ring. Any subsequent
/// elements represent interior rings (or holes).
///
class GeoJsonPolygon extends GeoJsonGeometry {

  GeoJsonLinearRing exteriorRing;
  final List<GeoJsonLinearRing> interiorRings = [];

  GeoJsonPolygon([this.exteriorRing, List<GeoJsonLinearRing> holes]) {
    if (holes?.isNotEmpty ?? false) interiorRings.addAll(holes);
  }

  GeoJsonPolygon.fromJson(Map m) {
    if (m["coordinates"] is List) {
      List<List<dynamic>> rings = m["coordinates"] as List<List<dynamic>>;
      if (rings.isEmpty) return;
      exteriorRing = new GeoJsonLinearRing.fromJson(rings.first);
      for (int i = 1; i < rings.length; i++) {
        interiorRings.add(new GeoJsonLinearRing.fromJson(rings[i]));
      }
    }
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }

  Map toJson() {
    Map m = <String, dynamic>{
      "type": "Polygon"
    };
    List rings = <dynamic>[];
    if (exteriorRing != null) rings.add(exteriorRing.toJson());
    for (var hole in interiorRings) {
      rings.add(hole.toJson());
    }
    m["coordinates"] = rings;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    GeoJsonBoundingBox box = exteriorRing != null
        ? exteriorRing.boundingBox
        : new GeoJsonBoundingBox(0, 0, 0, 0);
    for (var ir in interiorRings) {
      box = GeoJsonBoundingBox.merge(box, ir.boundingBox);
    }
    _bbox = box;
  }
}


class GeoJsonMultiPolygon extends GeoJsonGeometry {

  final List<GeoJsonPolygon> polygons = [];

  GeoJsonMultiPolygon([List<GeoJsonPolygon> polys]) {
    if (polys != null) this.polygons.addAll(polys);
  }

  GeoJsonMultiPolygon.fromJson(Map m) {
    if (m["coordinates"] is List) {
      List<List> polys = m["coordinates"] as List<List>;
      if (polys.isEmpty) return;
      for (List poly in polys) {
        var holes = poly.length > 1
            ? poly.where((dynamic ring) => ring != poly.first)
            : <dynamic>[];
        var exterior = new GeoJsonLinearRing();
        for (var c in poly.first) {
          exterior.coordinates.add(new GeoJsonCoordinate(c[0] as num, c[1] as num));
        }
        List<GeoJsonLinearRing> interior = [];
        for (var h in holes) {
          var inRing = new GeoJsonLinearRing();
          for (var hc in h) {
            inRing.coordinates.add(new GeoJsonCoordinate(hc[0] as num, hc[1] as num));
          }
          interior.add(inRing);
        }
        polygons.add(new GeoJsonPolygon(exterior, interior));
      }
    }
    if (m["bbox"] is List<num>) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }

  Map toJson() {
    Map m = <String, dynamic>{
      "type": "MultiPolygon"
    };
    List<dynamic> list = <dynamic>[];
    for (var p in polygons) {
      var polyJson = p.toJson();
      list.add(polyJson["coordinates"]);
    }
    m["coordinates"] = list;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    if (polygons.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (var p in polygons) {
      box = box == null ? p.boundingBox : GeoJsonBoundingBox.merge(
          box, p.boundingBox);
    }
    _bbox = box;
  }
}


class GeoJsonGeometryCollection extends GeoJsonGeometry {

  final List<GeoJsonGeometry> geometries = [];

  GeoJsonGeometryCollection();

  GeoJsonGeometryCollection.fromJson(Map m) {
    if (m["geometries"] is List) {
      for (Map g in m["geometries"]) {
        geometries.add(new GeoJsonGeometry.fromJson(g));
      }
    }
    if (m["bbox"] is List) _bbox = new GeoJsonBoundingBox(
        m["bbox"][0] as num, m["bbox"][1] as num, m["bbox"][2] as num, m["bbox"][3] as num);
  }

  Map<String, dynamic> toJson() {
    var m = <String, dynamic>{"type": "GeometryCollection"};
    List<dynamic> list = <dynamic>[];
    for (var g in geometries) {
      list.add(g.toJson());
    }
    m["geometries"] = list;
    if (_bbox != null) m["bbox"] = _bbox.toJson();
    return m;
  }

  void _calculateBoundingBox() {
    if (geometries.isEmpty) {
      _bbox = new GeoJsonBoundingBox(0, 0, 0, 0);
      return;
    }
    GeoJsonBoundingBox box;
    for (var g in geometries) {
      box = box == null ? g.boundingBox : GeoJsonBoundingBox.merge(
          box, g.boundingBox);
    }
    _bbox = box;
  }
}