part of envy;

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

  factory GeoJson.string(String str) => new GeoJson.map(JSON.decode(str));

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
    if (geometry != null) return geometry.toJson();
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

  GeoJsonBoundingBox([this.minLongitude, this.minLatitude, this.maxLongitude, this.maxLatitude]);

  List toJson() => [minLongitude, minLatitude, maxLongitude, maxLatitude];
}


class GeoJsonFeatureCollection {

  final List<GeoJsonFeature> features = [];

  GeoJsonBoundingBox bbox;

  GeoJsonFeatureCollection.fromJson(Map m) {
    if (m == null) return;
    var list = m["features"];
    if (list is List) {
      for (var x in list) {
        features.add(new GeoJsonFeature.fromJson(x));
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }

  Map toJson() {
    Map m = {"type": "FeatureCollection"};
    List list = [];
    for (var f in features) {
      list.add(f.toJson());
    }
    m["features"] = list;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }

}

class GeoJsonFeature {

  GeoJsonGeometry geometry;

  Map properties;

  GeoJsonBoundingBox bbox;

  GeoJsonFeature([this.geometry, this.properties]);

  GeoJsonFeature.fromJson(Map m) {
    applyMap(m);
  }

  void applyMap(Map m) {
    if (m == null) return;
    if (m["geometry"] is Map) geometry = new GeoJsonGeometry.fromJson(m["geometry"]);
    if (m["properties"] is Map) properties = m["properties"];
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }

  Map toJson() {
    Map m = {"type":"Feature", "geometry": geometry?.toJson()};
    if (properties != null) m["properties"] = properties;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }

}


abstract class GeoJsonGeometry {

  GeoJsonBoundingBox bbox;

  GeoJsonGeometry();

  factory GeoJsonGeometry.fromJson(Map m) {
    String type = m["type"];
    if (type == "Point") return new GeoJsonPoint.fromJson(m);
    if (type == "MultiPoint") return new GeoJsonMultiPoint.fromJson(m);
    if (type == "LineString") return new GeoJsonLineString.fromJson(m);
    if (type == "MultiLineString") return new GeoJsonMultiLineString.fromJson(m);
    if (type == "Polygon") return new GeoJsonPolygon.fromJson(m);
    if (type == "MultiPolygon") return new GeoJsonMultiPolygon.fromJson(m);
    if (type == "GeometryCollection") return new GeoJsonGeometryCollection.fromJson(m);
    return null;
  }

  dynamic toJson();
}


class GeoJsonPoint extends GeoJsonGeometry {
  GeoJsonCoordinate coordinate;

  GeoJsonPoint([this.coordinate]);

  GeoJsonPoint.fromJson(Map m) {
    if (m["coordinates"] is List) {
      coordinate = new GeoJsonCoordinate(m["coordinates"][0], m["coordinates"][1]);
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }

  GeoJsonPoint.longLat(List<num> array) : coordinate = new GeoJsonCoordinate(array[0], array[1]);

  Map toJson() {
    var m = {"type": "Point", "coordinates": coordinate.toJson()};
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}

class GeoJsonMultiPoint extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonMultiPoint();

  GeoJsonMultiPoint.fromJson(Map m) {
    if (m["coordinates"] is List) {
      for (var c in m["coordinates"]) {
        if (c is List && c.length > 1) coordinates.add(new GeoJsonCoordinate(c[0], c[1]));
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }


  Map toJson() {
    var m = {
      "type": "MultiPoint"
    };
    List<List<num>> coordJson = [];
    for (var coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m["coordinates"] = coordJson;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}

class GeoJsonLineString extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonLineString();

  GeoJsonLineString.fromJson(Map m) {
    if (m["coordinates"] is List) {
      for (var c in m["coordinates"]) {
        if (c is List && c.length > 1) coordinates.add(new GeoJsonCoordinate(c[0], c[1]));
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }


  Map toJson() {
    var m = {
      "type": "LineString"
    };
    List<List<num>> coordJson = [];
    for (var coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m["coordinates"] = coordJson;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}

class GeoJsonMultiLineString extends GeoJsonGeometry {
  final List<GeoJsonLineString> lineStrings = [];

  GeoJsonMultiLineString();

  GeoJsonMultiLineString.fromJson(Map m) {
    if (m["coordinates"] is List) {
      for (var lineString in m["coordinates"]) {
        if (lineString is List) {
          List<GeoJsonCoordinate> coords = [];
          for (var c in lineString) {
            coords.add(new GeoJsonCoordinate(c[0], c[1]));
          }
          lineStrings.add(new GeoJsonLineString()
            ..coordinates.addAll(coords));
        }
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }


  Map toJson() {
    var m = {
      "type": "MultiLineString"
    };
    List<List<num>> coordJson = [];
    for (var lineString in lineStrings) {
      List list = [];
      for (var coord in lineString.coordinates) {
        list.add(coord.toJson());
      }
      coordJson.add(list);
    }
    m["coordinates"] = coordJson;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}

/// A LinearRing is closed LineString with 4 or more positions. The first and last
/// positions are equivalent (they represent equivalent points). Though a LinearRing
/// is not explicitly represented as a GeoJSON geometry type, it is referred to in
/// the Polygon geometry type definition.
///
class GeoJsonLinearRing {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonLinearRing();

  GeoJsonLinearRing.fromJson(List jsonList) {
    if (jsonList == null) return;
    for (var x in jsonList) {
      if (x is List && x.length > 1) coordinates.add(new GeoJsonCoordinate(x[0], x[1]));
    }
  }

  List<List<num>> toJson() {
    var list = [];
    for (var c in coordinates) {
      list.add(c.toJson());
    }
    return list;
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
      List rings = m["coordinates"];
      if (rings.isEmpty) return;
      exteriorRing = new GeoJsonLinearRing.fromJson(rings.first);
      for (int i = 1; i < rings.length; i++) {
        interiorRings.add(new GeoJsonLinearRing.fromJson(rings[i]));
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }

  Map toJson() {
    Map m = {
      "type": "Polygon"
    };
    List rings = [];
    if (exteriorRing != null) rings.add(exteriorRing.toJson());
    for (var hole in interiorRings) {
      rings.add(hole.toJson());
    }
    m["coordinates"] = rings;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}


class GeoJsonMultiPolygon extends GeoJsonGeometry {

  final List<GeoJsonPolygon> polygons = [];

  GeoJsonMultiPolygon([List<GeoJsonPolygon> polys]) {
    if (polys != null) this.polygons.addAll(polys);
  }

  GeoJsonMultiPolygon.fromJson(Map m) {
    if (m["coordinates"] is List) {
      List polys = m["coordinates"];
      if (polys.isEmpty) return;
      for (var poly in polys) {
        var holes = poly.length > 1 ? poly.where((ring) => ring != poly.first) : [];
        var exterior = new GeoJsonLinearRing();
        for (var c in poly.first) {
          exterior.coordinates.add(new GeoJsonCoordinate(c[0], c[1]));
        }
        List<GeoJsonLinearRing> interior = [];
        for (var h in holes) {
          var inRing = new GeoJsonLinearRing();
          for (var hc in h) {
            inRing.coordinates.add(new GeoJsonCoordinate(hc[0], hc[1]));
          }
          interior.add(inRing);
        }
        polygons.add(new GeoJsonPolygon(exterior, interior));
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }

  Map toJson() {
    Map m = {
      "type": "MultiPolygon"
    };
    List list = [];
    for (var p in polygons) {
      var polyJson = p.toJson();
      list.add(polyJson["coordinates"]);
    }
    m["coordinates"] = list;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}

class GeoJsonGeometryCollection extends GeoJsonGeometry {
  GeoJsonBoundingBox bbox;

  final List<GeoJsonGeometry> geometries = [];

  GeoJsonGeometryCollection();

  GeoJsonGeometryCollection.fromJson(Map m) {
    if(m["geometries"] is List) {
      for(var g in m["geometries"]) {
        geometries.add(new GeoJsonGeometry.fromJson(g));
      }
    }
    if (m["bbox"] is List) bbox = new GeoJsonBoundingBox(m["bbox"][0], m["bbox"][1], m["bbox"][2], m["bbox"][3]);
  }

  Map toJson() {
    var m = {"type": "GeometryCollection"};
    List list = [];
    for(var g in geometries) {
      list.add(g.toJson());
    }
    m["geometries"] = list;
    if (bbox != null) m["bbox"] = bbox.toJson();
    return m;
  }
}