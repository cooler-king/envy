@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Timed Item Group', () {
    test('constructor', () {
      final GenericTimedItemGroup tig = new GenericTimedItemGroup();
      expect(tig != null, true);
    });
  });
}

class GenericTimedItemGroup extends TimedItemGroup {}
