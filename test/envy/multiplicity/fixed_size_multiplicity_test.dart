@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Fixed Size Multiplicity', () {
    test('Constructors', () {
      FixedSize fs = new FixedSize(3);
      expect(fs != null, true);
    });

    test('Values', () {
      FixedSize fs = new FixedSize(5);

      List<EnvyProperty> props = [];
      props.add(new NumberProperty());

      expect(fs != null, true);
    });
  });
}
