import 'package:envy/envy.dart';
@TestOn('browser')
import 'package:test/test.dart';

main() {
  group('GeoJson', () {
    test('Point', () {
      var m = { "type": "Point", "coordinates": [100.0, 0.0]};
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonPoint, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect(g.geometry.coordinate.latitude, 0);
      expect(g.geometry.coordinate.longitude, 100);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "Point");
      expect(json["coordinates"] is List, true);
      expect(json["coordinates"], [100, 0]);
    });

    test('MultiPoint', () {
      var m = { "type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0]]};
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonMultiPoint, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect(g.geometry.coordinates.length, 2);
      expect(g.geometry.coordinates[0].latitude, 0);
      expect(g.geometry.coordinates[0].longitude, 100);
      expect(g.geometry.coordinates[1].latitude, 1);
      expect(g.geometry.coordinates[1].longitude, 101);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "MultiPoint");
      expect(json["coordinates"] is List, true);
      expect(json["coordinates"], [ [100.0, 0.0], [101.0, 1.0]]);
    });

    test('LineString', () {
      var m = { "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0], [102.0, 2.0]]};
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonLineString, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect(g.geometry.coordinates.length, 3);
      expect(g.geometry.coordinates[0].latitude, 0);
      expect(g.geometry.coordinates[0].longitude, 100);
      expect(g.geometry.coordinates[1].latitude, 1);
      expect(g.geometry.coordinates[1].longitude, 101);
      expect(g.geometry.coordinates[2].latitude, 2);
      expect(g.geometry.coordinates[2].longitude, 102);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "LineString");
      expect(json["coordinates"] is List, true);
      expect(json["coordinates"], [ [100.0, 0.0], [101.0, 1.0], [102.0, 2.0]]);
    });

    test('MultiLineString', () {
      var m = { "type": "MultiLineString",
        "coordinates": [
          [ [100.0, 0.0], [101.0, 1.0]],
          [ [102.0, 2.0], [103.0, 3.0]]
        ]
      };
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonMultiLineString, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect(g.geometry.lineStrings.length, 2);
      expect(g.geometry.lineStrings[0].coordinates[0].latitude, 0);
      expect(g.geometry.lineStrings[0].coordinates[0].longitude, 100);
      expect(g.geometry.lineStrings[0].coordinates[1].latitude, 1);
      expect(g.geometry.lineStrings[0].coordinates[1].longitude, 101);
      expect(g.geometry.lineStrings[1].coordinates[0].latitude, 2);
      expect(g.geometry.lineStrings[1].coordinates[0].longitude, 102);
      expect(g.geometry.lineStrings[1].coordinates[1].latitude, 3);
      expect(g.geometry.lineStrings[1].coordinates[1].longitude, 103);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "MultiLineString");
      expect(json["coordinates"].length, 2);
      expect(json["coordinates"], [ [ [100.0, 0.0], [101.0, 1.0]], [ [102.0, 2.0], [103.0, 3.0]]]);
    });

    test('Polygon', () {
      var m = { "type": "Polygon",
        "coordinates": [
          [ [100.0, 0.0], [101.0, 0.0], [107.0, 7.0], [100.0, 1.0], [100.0, 0.0]]
        ]
      };
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonPolygon, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect(g.geometry.exteriorRing, isNotNull);
      expect(g.geometry.interiorRings, isEmpty);
      expect(g.geometry.exteriorRing.coordinates.length, 5);
      expect(g.geometry.exteriorRing.coordinates[2].latitude, 7);
      expect(g.geometry.exteriorRing.coordinates[2].longitude, 107);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "Polygon");
      expect(json["coordinates"] is List, true);
      expect(json["coordinates"], [ [ [100.0, 0.0], [101.0, 0.0], [107.0, 7.0], [100.0, 1.0], [100.0, 0.0]]]);
    });

    test('MultiPolygon', () {
      var m = { "type": "MultiPolygon",
        "coordinates": [
          [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
          [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
          [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
          ]
        ]
      };
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonMultiPolygon, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect(g.geometry.polygons.length, 2);
      expect(g.geometry.polygons[0].exteriorRing.coordinates.length, 5);
      expect(g.geometry.polygons[0].exteriorRing.coordinates[0].latitude, 2);
      expect(g.geometry.polygons[0].exteriorRing.coordinates[0].longitude, 102);
      expect(g.geometry.polygons[0].interiorRings, isEmpty);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "MultiPolygon");
      expect(json["coordinates"].length, 2);
      expect(json["coordinates"], [
        [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
        [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
        [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
        ]
      ]);
    });

    test('GeometryCollection', () {
      var m = { "type": "GeometryCollection",
        "geometries": [
          { "type": "Point",
            "coordinates": [100.0, 0.0]
          },
          { "type": "LineString",
            "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
          }
        ]
      };
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonGeometryCollection, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonGeometryCollection).geometries.length, 2);
      expect((g.geometry as GeoJsonGeometryCollection).geometries[0] is GeoJsonPoint, true);
      expect((g.geometry as GeoJsonGeometryCollection).geometries[1] is GeoJsonLineString, true);

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "GeometryCollection");
      expect(json["geometries"].length, 2);
      expect(json["geometries"][0], { "type": "Point", "coordinates": [100.0, 0.0]});
      expect(json["geometries"][1], { "type": "LineString", "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]});
    });


    test('Feature', () {
      var m = { "type": "Feature",
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
            [100.0, 1.0], [100.0, 0.0]
            ]
          ]
        },
        "properties": {
          "prop0": "value0",
          "prop1": {"this": "that"}
        }
      };
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.feature is GeoJsonFeature, true);
      expect(g.geometry, isNull);
      expect(g.featureCollection, isNull);
      expect(g.feature.geometry is GeoJsonPolygon, true);
      expect((g.feature.geometry as GeoJsonPolygon).exteriorRing.coordinates.length, 5);
      expect((g.feature.geometry as GeoJsonPolygon).interiorRings, isEmpty);
      expect(g.feature.properties, {
        "prop0": "value0",
        "prop1": {"this": "that"}
      });

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "Feature");
      expect(json["geometry"], {
        "type": "Polygon",
        "coordinates": [
          [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
          [100.0, 1.0], [100.0, 0.0]
          ]
        ]
      });
      expect(json["properties"], {
        "prop0": "value0",
        "prop1": {"this": "that"}
      });
    });


    test('FeatureCollection', () {
      var m = { "type": "FeatureCollection",
        "features": [
          { "type": "Feature",
            "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
            "properties": {"prop0": "value0"}
          },
          { "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
              ]
            },
            "properties": {
              "prop0": "value0",
              "prop1": 0.0
            }
          },
          { "type": "Feature",
            "geometry": {
              "type": "Polygon",
              "coordinates": [
                [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
                [100.0, 1.0], [100.0, 0.0]
                ]
              ]
            },
            "properties": {
              "prop0": "value0",
              "prop1": {"this": "that"}
            }
          }
        ]
      };
      var g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.featureCollection is GeoJsonFeatureCollection, true);
      expect(g.geometry, isNull);
      expect(g.feature, isNull);
      expect(g.featureCollection.features.length, 3);
      expect(g.featureCollection.features[0].geometry is GeoJsonPoint, true);
      expect(g.featureCollection.features[0].properties, {"prop0": "value0"});
      expect(g.featureCollection.features[1].geometry is GeoJsonLineString, true);
      expect(g.featureCollection.features[1].properties, {"prop0": "value0", "prop1": 0.0});
      expect(g.featureCollection.features[2].geometry is GeoJsonPolygon, true);
      expect(g.featureCollection.features[2].properties, {"prop0": "value0", "prop1": {"this": "that"}});

      var json = g.toJson();
      expect(json is Map, true);
      expect(json["type"], "FeatureCollection");
      expect(json["features"], [
        { "type": "Feature",
          "geometry": {"type": "Point", "coordinates": [102.0, 0.5]},
          "properties": {"prop0": "value0"}
        },
        { "type": "Feature",
          "geometry": {
            "type": "LineString",
            "coordinates": [
              [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]
            ]
          },
          "properties": {
            "prop0": "value0",
            "prop1": 0.0
          }
        },
        { "type": "Feature",
          "geometry": {
            "type": "Polygon",
            "coordinates": [
              [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0],
              [100.0, 1.0], [100.0, 0.0]
              ]
            ]
          },
          "properties": {
            "prop0": "value0",
            "prop1": {"this": "that"}
          }
        }
      ]);
    });
  });
}
