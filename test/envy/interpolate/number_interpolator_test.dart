@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Number Interpolation', () {
    test('Fraction of 0', () {
      final NumberInterpolator ni = NumberInterpolator();
      expect(ni.interpolate(3, 4, 0), 3);
      expect(ni.interpolate(5.0, 7.3, 0), 5.0);
      expect(ni.interpolate(6.2, 8.7, 0), 6.2);
      expect(ni.interpolate(1234, 43, 0), 1234);
    });

    test('Fraction of 1', () {
      final NumberInterpolator ni = NumberInterpolator();
      expect(ni.interpolate(3, 4, 1), 4);
      expect(ni.interpolate(2, 5.9, 1), 5.9);
      expect(ni.interpolate(6.2, 8.7, 1), 8.7);
      expect(ni.interpolate(6543, 23, 1), 23);
    });

    test('Regular Fraction Values (0-1)', () {
      final NumberInterpolator ni = NumberInterpolator();
      expect(ni.interpolate(100, 200, 0.01), closeTo(101, 0.00001));
      expect(ni.interpolate(1234.5, 2469, 0.1), closeTo(1234.5 + 123.45, 0.00001));
      expect(ni.interpolate(2469, 1234.5, 0.1), closeTo(2469 - 123.45, 0.00001));
      expect(ni.interpolate(-500, -400, 0.9), closeTo(-410, 0.00001));
      expect(ni.interpolate(-1000, 3000, 0.75), closeTo(2000, 0.00001));
    });

    test('Overflow Fraction Values, Unclamped', () {
      final NumberInterpolator ni = NumberInterpolator();
      expect(ni.interpolate(100, 200, -0.5), closeTo(50, 0.00001));
      expect(ni.interpolate(100, 200, 1.7), closeTo(270, 0.00001));
      expect(ni.interpolate(500, 100, 1.5), closeTo(-100, 0.00001));
      expect(ni.interpolate(-500, -400, -2), closeTo(-700, 0.00001));
      expect(ni.interpolate(-1000, 3000, 5), closeTo(19000, 0.00001));
    });

    test('Overflow Fraction Values, Clamped', () {
      final NumberInterpolator ni = NumberInterpolator()..clamped = true;
      expect(ni.interpolate(100, 200, -0.6), 100);
      expect(ni.interpolate(100, 200, 1.9), 200);
      expect(ni.interpolate(500, 100, 1.5), 100);
      expect(ni.interpolate(-500, -400, -2), -500);
      expect(ni.interpolate(-1000, 3000, 5), 3000);
    });
  });
}
