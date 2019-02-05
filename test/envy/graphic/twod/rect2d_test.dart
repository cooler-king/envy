@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Rect2d', () {
    test('constructors', () {
      final Rect2d rect = new Rect2d();

      // properties initialized
      expect(rect.properties != null, true);
      expect(rect.properties.isNotEmpty, true);
    });

    test('properties', () {
      final Rect2d rect = new Rect2d();

      // correct property types
      expect(rect.x is NumberProperty, true);
      expect(rect.y is NumberProperty, true);
      expect(rect.width is NumberProperty, true);
      expect(rect.height is NumberProperty, true);
    });
  });
}
