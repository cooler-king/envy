@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Timed Item Group', () {
    test('constructor', () {
      final tig = GenericTimedItemGroup();
      expect(tig != null, true);
    });
  });
}

class GenericTimedItemGroup extends TimedItemGroup {}
