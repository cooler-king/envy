@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Fixed Size Multiplicity', () {
    test('Constructors', () {
      final FixedSize fs = FixedSize(3);
      expect(fs, isNotNull);
      expect(fs.size, 3);
    });

    test('Values', () {
      final FixedSize fs = FixedSize(5);

      //final List<EnvyProperty<dynamic>> props = <EnvyProperty<dynamic>>[]..add(NumberProperty());

      expect(fs != null, true);
    });
  });
}
