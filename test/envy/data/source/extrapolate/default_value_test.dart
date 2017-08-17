@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Default Value', () {
    test('null and empty values', () {
      DefaultValue<num> dv = new DefaultValue<num>(42);
      expect(dv.value, 42);
      expect(dv.valueAt(0, null), 42);
      expect(dv.valueAt(0, []), 42);
    });

    test('index >= values.length', () {
      DefaultValue<num> dv = new DefaultValue<num>(65);
      expect(dv.valueAt(1, [13]), 65);
      expect(dv.valueAt(2, [13, 54]), 65);
      expect(dv.valueAt(123, [2, 7, 12]), 65);
    });
  });
}
