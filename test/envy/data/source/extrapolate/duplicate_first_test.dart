@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Duplicate First', () {
    test('null and empty values', () {
      DuplicateFirst dv = new DuplicateFirst();
      expect(dv.valueAt(0, null), null);
      expect(dv.valueAt(0, []), null);
    });

    test('index >= values.length', () {
      DuplicateFirst dv = new DuplicateFirst();
      expect(dv.valueAt(1, [13]), 13);
      expect(dv.valueAt(2, [13, 54]), 13);
      expect(dv.valueAt(123, [2, 7, 12]), 2);
    });
  });
}
