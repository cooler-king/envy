@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

main() {
  group('Timed Item Group', () {
    test('constructor', () {
      GenericTimedItemGroup tig = new GenericTimedItemGroup();
      expect(tig != null, true);
    });
  });
}

class GenericTimedItemGroup extends TimedItemGroup {}
