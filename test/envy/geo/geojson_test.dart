import 'package:envy/envy.dart';
@TestOn('browser')
import 'package:test/test.dart';

void main() {
  group('GeoJson', () {
    test('Point', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'Point',
        'coordinates': <num>[100.0, 0.0]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonPoint, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonPoint).coordinate.latitude, 0);
      expect((g.geometry as GeoJsonPoint).coordinate.longitude, 100);

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'Point');
      expect(json['coordinates'] is List, true);
      expect(json['coordinates'], <num>[100, 0]);
    });

    test('MultiPoint', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'MultiPoint',
        'coordinates': <List<num>>[
          <num>[100.0, 0.0],
          <num>[101.0, 1.0]
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonMultiPoint, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonMultiPoint).coordinates.length, 2);
      expect((g.geometry as GeoJsonMultiPoint).coordinates[0].latitude, 0);
      expect((g.geometry as GeoJsonMultiPoint).coordinates[0].longitude, 100);
      expect((g.geometry as GeoJsonMultiPoint).coordinates[1].latitude, 1);
      expect((g.geometry as GeoJsonMultiPoint).coordinates[1].longitude, 101);

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'MultiPoint');
      expect(json['coordinates'] is List, true);
      expect(json['coordinates'], <List<num>>[
        <num>[100.0, 0.0],
        <num>[101.0, 1.0]
      ]);
    });

    test('LineString', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'LineString',
        'coordinates': <List<num>>[
          <num>[100.0, 0.0],
          <num>[101.0, 1.0],
          <num>[102.0, 2.0]
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonLineString, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonLineString).coordinates.length, 3);
      expect((g.geometry as GeoJsonLineString).coordinates[0].latitude, 0);
      expect((g.geometry as GeoJsonLineString).coordinates[0].longitude, 100);
      expect((g.geometry as GeoJsonLineString).coordinates[1].latitude, 1);
      expect((g.geometry as GeoJsonLineString).coordinates[1].longitude, 101);
      expect((g.geometry as GeoJsonLineString).coordinates[2].latitude, 2);
      expect((g.geometry as GeoJsonLineString).coordinates[2].longitude, 102);

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'LineString');
      expect(json['coordinates'] is List, true);
      expect(json['coordinates'], <List<num>>[
        <num>[100.0, 0.0],
        <num>[101.0, 1.0],
        <num>[102.0, 2.0]
      ]);
    });

    test('MultiLineString', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'MultiLineString',
        'coordinates': <List<List<num>>>[
          <List<num>>[
            <num>[100.0, 0.0],
            <num>[101.0, 1.0]
          ],
          <List<num>>[
            <num>[102.0, 2.0],
            <num>[103.0, 3.0]
          ]
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonMultiLineString, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings.length, 2);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[0].coordinates[0].latitude, 0);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[0].coordinates[0].longitude, 100);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[0].coordinates[1].latitude, 1);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[0].coordinates[1].longitude, 101);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[1].coordinates[0].latitude, 2);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[1].coordinates[0].longitude, 102);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[1].coordinates[1].latitude, 3);
      expect((g.geometry as GeoJsonMultiLineString).lineStrings[1].coordinates[1].longitude, 103);

      final dynamic json = g.toJson();
      expect(json is Map, true);
      expect(json['type'], 'MultiLineString');
      expect(json['coordinates'].length, 2);
      expect(json['coordinates'], <List<List<num>>>[
        <List<num>>[
          <num>[100.0, 0.0],
          <num>[101.0, 1.0]
        ],
        <List<num>>[
          <num>[102.0, 2.0],
          <num>[103.0, 3.0]
        ]
      ]);
    });

    test('Polygon', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'Polygon',
        'coordinates': <List<List<num>>>[
          <List<num>>[
            <num>[100.0, 0.0],
            <num>[101.0, 0.0],
            <num>[107.0, 7.0],
            <num>[100.0, 1.0],
            <num>[100.0, 0.0]
          ]
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonPolygon, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonPolygon).exteriorRing, isNotNull);
      expect((g.geometry as GeoJsonPolygon).interiorRings, isEmpty);
      expect((g.geometry as GeoJsonPolygon).exteriorRing.coordinates.length, 5);
      expect((g.geometry as GeoJsonPolygon).exteriorRing.coordinates[2].latitude, 7);
      expect((g.geometry as GeoJsonPolygon).exteriorRing.coordinates[2].longitude, 107);

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'Polygon');
      expect(json['coordinates'] is List, true);
      expect(json['coordinates'], <List<List<num>>>[
        <List<num>>[
          <num>[100.0, 0.0],
          <num>[101.0, 0.0],
          <num>[107.0, 7.0],
          <num>[100.0, 1.0],
          <num>[100.0, 0.0]
        ]
      ]);
    });

    test('MultiPolygon', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'MultiPolygon',
        'coordinates': <List<List<List<num>>>>[
          <List<List<num>>>[
            <List<num>>[
              <num>[102.0, 2.0],
              <num>[103.0, 2.0],
              <num>[103.0, 3.0],
              <num>[102.0, 3.0],
              <num>[102.0, 2.0]
            ]
          ],
          <List<List<num>>>[
            <List<num>>[
              <num>[100.0, 0.0],
              <num>[101.0, 0.0],
              <num>[101.0, 1.0],
              <num>[100.0, 1.0],
              <num>[100.0, 0.0]
            ],
            <List<num>>[
              <num>[100.2, 0.2],
              <num>[100.8, 0.2],
              <num>[100.8, 0.8],
              <num>[100.2, 0.8],
              <num>[100.2, 0.2]
            ]
          ]
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonMultiPolygon, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonMultiPolygon).polygons.length, 2);
      expect((g.geometry as GeoJsonMultiPolygon).polygons[0].exteriorRing.coordinates.length, 5);
      expect((g.geometry as GeoJsonMultiPolygon).polygons[0].exteriorRing.coordinates[0].latitude, 2);
      expect((g.geometry as GeoJsonMultiPolygon).polygons[0].exteriorRing.coordinates[0].longitude, 102);
      expect((g.geometry as GeoJsonMultiPolygon).polygons[0].interiorRings, isEmpty);

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'MultiPolygon');
      expect(json['coordinates'].length, 2);
      expect(json['coordinates'], <List<List<List<num>>>>[
        <List<List<num>>>[
          <List<num>>[
            <num>[102.0, 2.0],
            <num>[103.0, 2.0],
            <num>[103.0, 3.0],
            <num>[102.0, 3.0],
            <num>[102.0, 2.0]
          ]
        ],
        <List<List<num>>>[
          <List<num>>[
            <num>[100.0, 0.0],
            <num>[101.0, 0.0],
            <num>[101.0, 1.0],
            <num>[100.0, 1.0],
            <num>[100.0, 0.0]
          ],
          <List<num>>[
            <num>[100.2, 0.2],
            <num>[100.8, 0.2],
            <num>[100.8, 0.8],
            <num>[100.2, 0.8],
            <num>[100.2, 0.2]
          ]
        ]
      ]);
    });

    test('GeometryCollection', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'GeometryCollection',
        'geometries': <Map<String, dynamic>>[
          <String, dynamic>{
            'type': 'Point',
            'coordinates': <num>[100.0, 0.0]
          },
          <String, dynamic>{
            'type': 'LineString',
            'coordinates': <List<num>>[
              <num>[101.0, 0.0],
              <num>[102.0, 1.0]
            ]
          }
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.geometry is GeoJsonGeometryCollection, true);
      expect(g.feature, isNull);
      expect(g.featureCollection, isNull);
      expect((g.geometry as GeoJsonGeometryCollection).geometries.length, 2);
      expect((g.geometry as GeoJsonGeometryCollection).geometries[0] is GeoJsonPoint, true);
      expect((g.geometry as GeoJsonGeometryCollection).geometries[1] is GeoJsonLineString, true);

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'GeometryCollection');
      expect(json['geometries'].length, 2);
      expect(json['geometries'][0], <String, dynamic>{
        'type': 'Point',
        'coordinates': <num>[100.0, 0.0]
      });
      expect(json['geometries'][1], <String, dynamic>{
        'type': 'LineString',
        'coordinates': <List<num>>[
          <num>[101.0, 0.0],
          <num>[102.0, 1.0]
        ]
      });
    });

    test('Feature', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'Feature',
        'geometry': <String, dynamic>{
          'type': 'Polygon',
          'coordinates': <List<List<num>>>[
            <List<num>>[
              <num>[100.0, 0.0],
              <num>[101.0, 0.0],
              <num>[101.0, 1.0],
              <num>[100.0, 1.0],
              <num>[100.0, 0.0]
            ]
          ]
        },
        'properties': <String, dynamic>{
          'prop0': 'value0',
          'prop1': <String, dynamic>{'this': 'that'}
        }
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.feature is GeoJsonFeature, true);
      expect(g.geometry, isNull);
      expect(g.featureCollection, isNull);
      expect(g.feature.geometry is GeoJsonPolygon, true);
      expect((g.feature.geometry as GeoJsonPolygon).exteriorRing.coordinates.length, 5);
      expect((g.feature.geometry as GeoJsonPolygon).interiorRings, isEmpty);
      expect(g.feature.properties, <String, dynamic>{
        'prop0': 'value0',
        'prop1': <String, dynamic>{'this': 'that'}
      });

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'Feature');
      expect(json['geometry'], <String, dynamic>{
        'type': 'Polygon',
        'coordinates': <List<List<num>>>[
          <List<num>>[
            <num>[100.0, 0.0],
            <num>[101.0, 0.0],
            <num>[101.0, 1.0],
            <num>[100.0, 1.0],
            <num>[100.0, 0.0]
          ]
        ]
      });
      expect(json['properties'], <String, dynamic>{
        'prop0': 'value0',
        'prop1': <String, dynamic>{'this': 'that'}
      });
    });

    test('FeatureCollection', () {
      final Map<String, dynamic> m = <String, dynamic>{
        'type': 'FeatureCollection',
        'features': <Map<String, dynamic>>[
          <String, dynamic>{
            'type': 'Feature',
            'geometry': <String, dynamic>{
              'type': 'Point',
              'coordinates': <num>[102.0, 0.5]
            },
            'properties': <String, dynamic>{'prop0': 'value0'}
          },
          <String, dynamic>{
            'type': 'Feature',
            'geometry': <String, dynamic>{
              'type': 'LineString',
              'coordinates': <List<num>>[
                <num>[102.0, 0.0],
                <num>[103.0, 1.0],
                <num>[104.0, 0.0],
                <num>[105.0, 1.0]
              ]
            },
            'properties': <String, dynamic>{'prop0': 'value0', 'prop1': 0.0}
          },
          <String, dynamic>{
            'type': 'Feature',
            'geometry': <String, dynamic>{
              'type': 'Polygon',
              'coordinates': <List<List<num>>>[
                <List<num>>[
                  <num>[100.0, 0.0],
                  <num>[101.0, 0.0],
                  <num>[101.0, 1.0],
                  <num>[100.0, 1.0],
                  <num>[100.0, 0.0]
                ]
              ]
            },
            'properties': <String, dynamic>{
              'prop0': 'value0',
              'prop1': <String, dynamic>{'this': 'that'}
            }
          }
        ]
      };
      final GeoJson g = new GeoJson.map(m);
      expect(g is GeoJson, true);
      expect(g.featureCollection is GeoJsonFeatureCollection, true);
      expect(g.geometry, isNull);
      expect(g.feature, isNull);
      expect(g.featureCollection.features.length, 3);
      expect(g.featureCollection.features[0].geometry is GeoJsonPoint, true);
      expect(g.featureCollection.features[0].properties, <String, dynamic>{'prop0': 'value0'});
      expect(g.featureCollection.features[1].geometry is GeoJsonLineString, true);
      expect(g.featureCollection.features[1].properties, <String, dynamic>{'prop0': 'value0', 'prop1': 0.0});
      expect(g.featureCollection.features[2].geometry is GeoJsonPolygon, true);
      expect(g.featureCollection.features[2].properties, <String, dynamic>{
        'prop0': 'value0',
        'prop1': <String, dynamic>{'this': 'that'}
      });

      final Map<dynamic, dynamic> json = g.toJson() as Map<dynamic, dynamic>;
      expect(json is Map, true);
      expect(json['type'], 'FeatureCollection');
      expect(json['features'], <Map<String, dynamic>>[
        <String, dynamic>{
          'type': 'Feature',
          'geometry': <String, dynamic>{
            'type': 'Point',
            'coordinates': <num>[102.0, 0.5]
          },
          'properties': <String, dynamic>{'prop0': 'value0'}
        },
        <String, dynamic>{
          'type': 'Feature',
          'geometry': <String, dynamic>{
            'type': 'LineString',
            'coordinates': <List<num>>[
              <num>[102.0, 0.0],
              <num>[103.0, 1.0],
              <num>[104.0, 0.0],
              <num>[105.0, 1.0]
            ]
          },
          'properties': <String, dynamic>{'prop0': 'value0', 'prop1': 0.0}
        },
        <String, dynamic>{
          'type': 'Feature',
          'geometry': <String, dynamic>{
            'type': 'Polygon',
            'coordinates': <List<List<num>>>[
              <List<num>>[
                <num>[100.0, 0.0],
                <num>[101.0, 0.0],
                <num>[101.0, 1.0],
                <num>[100.0, 1.0],
                <num>[100.0, 0.0]
              ]
            ]
          },
          'properties': <String, dynamic>{
            'prop0': 'value0',
            'prop1': <String, dynamic>{'this': 'that'}
          }
        }
      ]);
    });
  });
}
