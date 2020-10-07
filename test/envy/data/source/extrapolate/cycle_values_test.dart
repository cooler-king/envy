@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Cycle Values', () {
    test('null and empty values', () {
      CycleValues<int> cv = CycleValues<int>(true);
      expect(cv.valueAt(0, null), null);
      expect(cv.valueAt(0, <int>[]), null);
      cv = CycleValues<int>(false);
      expect(cv.valueAt(0, null), null);
      expect(cv.valueAt(0, <int>[]), null);
    });

    test('index >= values.length... one way', () {
      final CycleValues<num> cv = CycleValues<num>(true);
      expect(cv.valueAt(1, <num>[13]), 13);
      expect(cv.valueAt(2, <num>[13]), 13);

      expect(cv.valueAt(2, <num>[13, 54]), 13);
      expect(cv.valueAt(3, <num>[13, 54]), 54);
      expect(cv.valueAt(4, <num>[13, 54]), 13);
      expect(cv.valueAt(5, <num>[13, 54]), 54);
      expect(cv.valueAt(6, <num>[13, 54]), 13);
      expect(cv.valueAt(7, <num>[13, 54]), 54);

      expect(cv.valueAt(3, <num>[1, 2, 3]), 1);
      expect(cv.valueAt(4, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(5, <num>[1, 2, 3]), 3);
      expect(cv.valueAt(6, <num>[1, 2, 3]), 1);
      expect(cv.valueAt(7, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(8, <num>[1, 2, 3]), 3);
      expect(cv.valueAt(9, <num>[1, 2, 3]), 1);
      expect(cv.valueAt(10, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(11, <num>[1, 2, 3]), 3);
    });

    test('index >= values.length... two way', () {
      final CycleValues<num> cv = CycleValues<num>(false);
      expect(cv.valueAt(1, <num>[13]), 13);
      expect(cv.valueAt(2, <num>[13]), 13);

      expect(cv.valueAt(2, <num>[13, 54]), 13);
      expect(cv.valueAt(3, <num>[13, 54]), 54);
      expect(cv.valueAt(4, <num>[13, 54]), 13);
      expect(cv.valueAt(5, <num>[13, 54]), 54);
      expect(cv.valueAt(6, <num>[13, 54]), 13);
      expect(cv.valueAt(7, <num>[13, 54]), 54);

      expect(cv.valueAt(3, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(4, <num>[1, 2, 3]), 1);
      expect(cv.valueAt(5, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(6, <num>[1, 2, 3]), 3);
      expect(cv.valueAt(7, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(8, <num>[1, 2, 3]), 1);
      expect(cv.valueAt(9, <num>[1, 2, 3]), 2);
      expect(cv.valueAt(10, <num>[1, 2, 3]), 3);
      expect(cv.valueAt(11, <num>[1, 2, 3]), 2);
    });
  });
}
