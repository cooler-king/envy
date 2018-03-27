@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Fixed Size Multiplicity', () {
    test('Constructors', () {
      final FixedSize fs = new FixedSize(3);
      expect(fs != null, true);
    });

    test('Values', () {
      final FixedSize fs = new FixedSize(5);

      final List<EnvyProperty<dynamic>> props = <EnvyProperty<dynamic>>[]..add(new NumberProperty());

      expect(fs != null, true);
    });
  });
}
