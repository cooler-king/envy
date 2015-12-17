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
    if(m == null) return;
    if(m["type"] == "FeatureCollection") {
      featureCollection = new GeoJsonFeatureCollection.fromJson(m);
    } else if(m["type"] == "Feature") {
      feature = new GeoJsonFeature.fromJson(m);
    } else {
      // Must be a geometry of some kind
      geometry = new GeoJsonGeometry.fromJson(m);
    }
  }

  Map toJson() {
    if(featureCollection != null) return {"features": featureCollection.toJson()};
    if(feature != null) return feature.toJson();
    if(geometry != null) return geometry.toJson();
  }

}

class GeoJsonCoordinate {
  num longitude;
  num latitude;

  GeoJsonCoordinate(this.longitude, this.latitude);

  GeoJsonCoordinate.array(List<num> longLat) {
    longitude = longLat[0];
    latitude = longLat[1];
  }

  List<num> toJson() => [longitude ?? 0, latitude ?? 0];
}



class GeoJsonFeatureCollection {

  final List<GeoJsonFeature> features = [];

  GeoJsonFeatureCollection.fromJson(Map m) {
    if(m == null) return;
    var list = m["features"];
    if(list is List) {
      for(var x in list) {
        features.add(new GeoJsonFeature.fromJson(x));
      }
    }
  }

  Map toJson() {
    Map m = {"type": "FeatureCollection"};
    List list = [];
    for(var f in features) {
      list.add(f.toJson());
    }
    m["features"] = list;
    return m;
  }

}

class GeoJsonFeature {

  GeoJsonGeometry geometry;

  Map properties;

  GeoJsonFeature([this.geometry, this.properties]);

  GeoJsonFeature.fromJson(Map m) {
    applyMap(m);
  }

  void applyMap(Map m) {
    if(m == null) return;
    if(m["geometry"] is Map) geometry = new GeoJsonGeometry.fromJson(m["geometry"]);
  }

  Map toJson() {
    Map m = {"geometry": geometry?.toJson()};
    if(properties != null) m["properties"] = properties;
    return m;
  }

}


abstract class GeoJsonGeometry {

  GeoJsonGeometry();

  factory GeoJsonGeometry.fromJson(Map m) {
    String type = m["type"];
    if(type == "Polygon") return new GeoJsonPolygon.fromJson(m);
    return null;
  }

  void applyMap(Map m) {
    if(m == null ) return;
  }

  dynamic toJson();
}


class GeoJsonPoint extends GeoJsonGeometry {
  GeoJsonCoordinate coordinate;

  GeoJsonPoint([this.coordinate]);

  GeoJsonPoint.longLat(List<num> array) : coordinate = new GeoJsonCoordinate(array[0], array[1]);

  Map toJson() => {"type": "Point", "coordinates": coordinate.toJson()};
}

class GeoJsonMultiPoint extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonMultiPoint();

  GeoJsonMultiPoint.fromJson(Map m) {
    if(m["coordinates"] is List) {
      for(var c in m["coordinates"]) {
        if(c is List && c.length > 1) coordinates.add(new GeoJsonCoordinate(c[0], c[1]));
      }
    }
  }


  Map toJson() {
    var m = {"type": "MultiPoint"};
    List<List<num>> coordJson = [];
    for(var coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m["coordinates"] = coordJson;
    return m;
  }
}

class GeoJsonLineString extends GeoJsonGeometry {
  final List<GeoJsonCoordinate> coordinates = [];

  GeoJsonLineString();

  GeoJsonLineString.fromJson(Map m) {
    if(m["coordinates"] is List) {
      for(var c in m["coordinates"]) {
        if(c is List && c.length > 1) coordinates.add(new GeoJsonCoordinate(c[0], c[1]));
      }
    }
  }


  Map toJson() {
    var m = {"type": "LineString"};
    List<List<num>> coordJson = [];
    for(var coord in coordinates) {
      coordJson.add(coord.toJson());
    }
    m["coordinates"] = coordJson;
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
    if(jsonList == null) return;
    for(var x in jsonList) {
      if(x is List && x.length > 1) coordinates.add(new GeoJsonCoordinate(x[0], x[1]));
    }
  }

  List<List<num>> toJson() {
    var list = [];
    for(var c in coordinates) {
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
    if(holes != null) interiorRings.addAll(holes);
  }

  GeoJsonPolygon.fromJson(Map m) {
    if(m["coordinates"] is List) {
      List rings = m["coordinates"];
      if(rings.isEmpty) return;
      exteriorRing = new GeoJsonLinearRing.fromJson(rings.first);
      for(int i=1; i<rings.length; i++) {
        interiorRings.add(new GeoJsonLinearRing.fromJson(rings[i]));
      }
    }
  }

  Map toJson() {
    Map m = {"type": "Polygon"};
    List rings = [];
    if(exteriorRing != null) rings.add(exteriorRing.toJson());
    for(var hole in interiorRings) {
      rings.add(hole.toJson());
    }
    return m;
  }
}

class GeoJsonGeometryCollection {
  final List<GeoJsonGeometry> geometries = [];

  GeoJsonGeometryCollection();

  GeoJsonGeometryCollection.fromJson(List list) {

  }
}