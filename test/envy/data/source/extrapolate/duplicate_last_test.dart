@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Duplicate Last', () {
    test('null and empty values', () {
      DuplicateLast dv = new DuplicateLast();
      expect(dv.valueAt(0, null), null);
      expect(dv.valueAt(0, []), null);
    });

    test('index >= values.length', () {
      DuplicateLast dv = new DuplicateLast();
      expect(dv.valueAt(1, [13]), 13);
      expect(dv.valueAt(2, [13, 54]), 54);
      expect(dv.valueAt(3, [13, 54]), 54);
      expect(dv.valueAt(897, [2, 7, 12]), 12);
    });
  });
}
