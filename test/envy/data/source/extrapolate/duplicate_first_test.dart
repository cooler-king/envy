@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Duplicate First', () {
    test('null and empty values', () {
      DuplicateFirst<int> dv = new DuplicateFirst<int>();
      expect(dv.valueAt(0, null), null);
      expect(dv.valueAt(0, <int>[]), null);
    });

    test('index >= values.length', () {
      DuplicateFirst<int> dv = new DuplicateFirst<int>();
      expect(dv.valueAt(1, <int>[13]), 13);
      expect(dv.valueAt(2, <int>[13, 54]), 13);
      expect(dv.valueAt(123, <int>[2, 7, 12]), 2);
    });
  });
}
