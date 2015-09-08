@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

main() {
  group('Cycle Values', () {
    test('null and empty values', () {
      CycleValues cv = new CycleValues(true);
      expect(cv.valueAt(0, null), null);
      expect(cv.valueAt(0, []), null);
      cv = new CycleValues(false);
      expect(cv.valueAt(0, null), null);
      expect(cv.valueAt(0, []), null);
    });

    test('index >= values.length... one way', () {
      CycleValues<num> cv = new CycleValues<num>(true);
      expect(cv.valueAt(1, [13]), 13);
      expect(cv.valueAt(2, [13]), 13);

      expect(cv.valueAt(2, [13, 54]), 13);
      expect(cv.valueAt(3, [13, 54]), 54);
      expect(cv.valueAt(4, [13, 54]), 13);
      expect(cv.valueAt(5, [13, 54]), 54);
      expect(cv.valueAt(6, [13, 54]), 13);
      expect(cv.valueAt(7, [13, 54]), 54);

      expect(cv.valueAt(3, [1, 2, 3]), 1);
      expect(cv.valueAt(4, [1, 2, 3]), 2);
      expect(cv.valueAt(5, [1, 2, 3]), 3);
      expect(cv.valueAt(6, [1, 2, 3]), 1);
      expect(cv.valueAt(7, [1, 2, 3]), 2);
      expect(cv.valueAt(8, [1, 2, 3]), 3);
      expect(cv.valueAt(9, [1, 2, 3]), 1);
      expect(cv.valueAt(10, [1, 2, 3]), 2);
      expect(cv.valueAt(11, [1, 2, 3]), 3);
    });

    test('index >= values.length... two way', () {
      CycleValues<num> cv = new CycleValues<num>(false);
      expect(cv.valueAt(1, [13]), 13);
      expect(cv.valueAt(2, [13]), 13);

      expect(cv.valueAt(2, [13, 54]), 13);
      expect(cv.valueAt(3, [13, 54]), 54);
      expect(cv.valueAt(4, [13, 54]), 13);
      expect(cv.valueAt(5, [13, 54]), 54);
      expect(cv.valueAt(6, [13, 54]), 13);
      expect(cv.valueAt(7, [13, 54]), 54);

      expect(cv.valueAt(3, [1, 2, 3]), 2);
      expect(cv.valueAt(4, [1, 2, 3]), 1);
      expect(cv.valueAt(5, [1, 2, 3]), 2);
      expect(cv.valueAt(6, [1, 2, 3]), 3);
      expect(cv.valueAt(7, [1, 2, 3]), 2);
      expect(cv.valueAt(8, [1, 2, 3]), 1);
      expect(cv.valueAt(9, [1, 2, 3]), 2);
      expect(cv.valueAt(10, [1, 2, 3]), 3);
      expect(cv.valueAt(11, [1, 2, 3]), 2);
    });
  });
}
