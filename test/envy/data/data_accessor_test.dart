@TestOn('vm || browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart' show DataAccessor;

void main() {
  group('getData', () {
    test('keyed property', () {
      final a = DataAccessor.prop('x', keyProp: 'id');

      final Object dataset = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id1', 'x': 10},
        <String, dynamic>{'id': 'id2', 'x': 20},
        <String, dynamic>{'id': 'id3', 'x': 30},
      ];
      var data = a.getData(dataset);
      expect(data is List, true);
      var dataList = data as List<dynamic>;
      expect(dataList.length, 3);
      expect(dataList[0], 10);
      expect(dataList[1], 20);
      expect(dataList[2], 30);

      // Change order
      final Object dataset2 = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id2', 'x': 10},
        <String, dynamic>{'id': 'id3', 'x': 20},
        <String, dynamic>{'id': 'id1', 'x': 30},
      ];
      data = a.getData(dataset2);
      expect(data is List, true);
      dataList = data as List<dynamic>;
      expect(dataList.length, 3);
      expect(dataList[0], 30);
      expect(dataList[1], 10);
      expect(dataList[2], 20);

      // Expansion and hole
      final Object dataset3 = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id3', 'x': 100},
        <String, dynamic>{'id': 'id4', 'x': 200},
        <String, dynamic>{'id': 'id5', 'x': 300},
        <String, dynamic>{'id': 'id1', 'x': 400},
        <String, dynamic>{'id': 'id6', 'x': 500}
      ];
      data = a.getData(dataset3);
      expect(data is List, true);
      dataList = data as List<dynamic>;
      expect(dataList.length, 6);
      expect(dataList[0], 400);
      expect(a.dataUnavailableIndices.length == 1, true);
      expect(a.dataUnavailableIndices.containsKey(1), true);
      expect(dataList[2], 100);
      expect(dataList[3], 200);
      expect(dataList[4], 300);
      expect(dataList[5], 500);

      // All new
      final Object dataset4 = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id7', 'x': 700},
        <String, dynamic>{'id': 'id8', 'x': 800},
        <String, dynamic>{'id': 'id9', 'x': 900}
      ];
      data = a.getData(dataset4);
      expect(data is List, true);
      dataList = data as List<dynamic>;
      expect(dataList.length, 9);
      expect(a.dataUnavailableIndices.length == 6, true);
      expect(a.dataUnavailableIndices.containsKey(0), true);
      expect(a.dataUnavailableIndices.containsKey(1), true);
      expect(a.dataUnavailableIndices.containsKey(2), true);
      expect(a.dataUnavailableIndices.containsKey(3), true);
      expect(a.dataUnavailableIndices.containsKey(4), true);
      expect(a.dataUnavailableIndices.containsKey(5), true);
      expect(a.dataUnavailableIndices.containsKey(6), false);
      expect(dataList[6], 700);
      expect(dataList[7], 800);
      expect(dataList[8], 900);

      // Reuse some old ones
      final Object dataset5 = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id3', 'x': 333},
        <String, dynamic>{'id': 'id5', 'x': 555},
        <String, dynamic>{'id': 'id1', 'x': 111}
      ];
      data = a.getData(dataset5);
      expect(data is List, true);
      dataList = data as List<dynamic>;
      expect(dataList.length, 9);
      expect(dataList[0], 111);
      expect(dataList[2], 333);
      expect(dataList[4], 555);
      expect(a.dataUnavailableIndices.length == 6, true);
      expect(a.dataUnavailableIndices.containsKey(0), false);
      expect(a.dataUnavailableIndices.containsKey(1), true);
      expect(a.dataUnavailableIndices.containsKey(2), false);
      expect(a.dataUnavailableIndices.containsKey(3), true);
      expect(a.dataUnavailableIndices.containsKey(4), false);
      expect(a.dataUnavailableIndices.containsKey(5), true);
      expect(a.dataUnavailableIndices.containsKey(6), true);
      expect(a.dataUnavailableIndices.containsKey(7), true);
      expect(a.dataUnavailableIndices.containsKey(8), true);
      expect(a.dataUnavailableIndices.containsKey(9), false);
    });

    test('cullUnavailableData', () {
      final a = DataAccessor.prop('x', keyProp: 'id');

      final Object dataset = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id1', 'x': 10},
        <String, dynamic>{'id': 'id2', 'x': 20},
        <String, dynamic>{'id': 'id3', 'x': 30},
        <String, dynamic>{'id': 'id4', 'x': 30},
        <String, dynamic>{'id': 'id5', 'x': 30},
        <String, dynamic>{'id': 'id6', 'x': 30},
        <String, dynamic>{'id': 'id7', 'x': 30},
        <String, dynamic>{'id': 'id8', 'x': 30},
        <String, dynamic>{'id': 'id9', 'x': 30}
      ];
      a.getData(dataset);
      print(a.propOrderingMap['x']);

      // omit 4 and 7
      final Object dataset2 = <Map<String, dynamic>>[
        <String, dynamic>{'id': 'id1', 'x': 1},
        <String, dynamic>{'id': 'id2', 'x': 2},
        <String, dynamic>{'id': 'id3', 'x': 3},
        <String, dynamic>{'id': 'id5', 'x': 4},
        <String, dynamic>{'id': 'id6', 'x': 5},
        <String, dynamic>{'id': 'id8', 'x': 6},
        <String, dynamic>{'id': 'id9', 'x': 7}
      ];
      a.getData(dataset2);
      print(a.propOrderingMap['x']);

      /*
      //print(a.propOrderingMap['x']);
      expect(data is List, true);
      List dataList = data as List;
      expect(dataList.length, 9);
      expect(dataList[0], 10);
      expect(dataList[1], 20);
      expect(dataList[2], 30);
      expect(dataList[3], dataNotAvailable);
      expect(dataList[4], 30);
      expect(dataList[5], 30);
      expect(dataList[6], dataNotAvailable);
      expect(dataList[7], 30);
      expect(dataList[8], 30);*/

      a.cullUnavailableData();
      print(a.propOrderingMap['x']);
    });
  });
}
