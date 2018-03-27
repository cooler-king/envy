@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Duplicate Last', () {
    test('null and empty values', () {
      final DuplicateLast<int> dv = new DuplicateLast<int>();
      expect(dv.valueAt(0, null), null);
      expect(dv.valueAt(0, <int>[]), null);
    });

    test('index >= values.length', () {
      final DuplicateLast<int> dv = new DuplicateLast<int>();
      expect(dv.valueAt(1, <int>[13]), 13);
      expect(dv.valueAt(2, <int>[13, 54]), 54);
      expect(dv.valueAt(3, <int>[13, 54]), 54);
      expect(dv.valueAt(897, <int>[2, 7, 12]), 12);
    });
  });
}
