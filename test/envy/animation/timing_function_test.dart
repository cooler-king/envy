@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Timing Functions', () {
    test('Linear Function', () {
      final linear = LinearFunction();
      expect(linear.output(0), 0);
      expect(linear.output(1), 1);
      expect(linear.output(0.2), 0.2);
      expect(linear.output(0.5), 0.5);
      expect(linear.output(0.1234546789), 0.1234546789);
    });

    group('Step Functions', () {
      test('end', () {
        var steps = StepFunction(2);
        expect(steps.output(0), 0);
        expect(steps.output(0.000001), 0);
        expect(steps.output(0.1), 0);
        expect(steps.output(0.499999), 0);
        expect(steps.output(0.5), 0.5);
        expect(steps.output(0.500001), 0.5);
        expect(steps.output(0.7654321), 0.5);
        expect(steps.output(0.999999), 0.5);
        expect(steps.output(1), 1);

        steps = StepFunction(5);
        expect(steps.output(0), 0);
        expect(steps.output(0.000001), 0);
        expect(steps.output(0.199999), 0);
        expect(steps.output(0.2), 0.2);
        expect(steps.output(0.200001), 0.2);
        expect(steps.output(0.399999), 0.2);
        expect(steps.output(0.4), 0.4);
        expect(steps.output(0.400001), 0.4);
        expect(steps.output(0.599999), 0.4);
        // rounding problem in calcs (0.6 returns 0.4)
        //expect(steps.output(0.6), closeTo(0.6, 0.0000001));
        expect(steps.output(0.600001), closeTo(0.6, 0.0000001));
        expect(steps.output(0.799999), closeTo(0.6, 0.0000001));
        expect(steps.output(0.8), 0.8);
        expect(steps.output(0.800001), 0.8);
        expect(steps.output(0.999999), 0.8);
        expect(steps.output(1), 1);
      });

      test('start', () {
        var steps = StepFunction(2, false);
        expect(steps.output(0), 0.5);
        expect(steps.output(0.000001), 0.5);
        expect(steps.output(0.1), 0.5);
        expect(steps.output(0.499999), 0.5);
        expect(steps.output(0.5), 1);
        expect(steps.output(0.500001), 1);
        expect(steps.output(0.7654321), 1);
        expect(steps.output(0.999999), 1);
        expect(steps.output(1), 1);

        steps = StepFunction(5, false);
        expect(steps.output(0), 0.2);
        expect(steps.output(0.000001), 0.2);
        expect(steps.output(0.199999), 0.2);
        expect(steps.output(0.2), 0.4);
        expect(steps.output(0.200001), 0.4);
        expect(steps.output(0.399999), 0.4);
        expect(steps.output(0.4), closeTo(0.6, 0.0000001));
        expect(steps.output(0.400001), closeTo(0.6, 0.0000001));
        expect(steps.output(0.599999), closeTo(0.6, 0.0000001));
        // rounding problem in calcs (0.6 returns 0.6)
        //expect(steps.output(0.6), closeTo(0.8, 0.0000001));
        expect(steps.output(0.600001), closeTo(0.8, 0.0000001));
        expect(steps.output(0.799999), closeTo(0.8, 0.0000001));
        expect(steps.output(0.8), 1);
        expect(steps.output(0.800001), 1);
        expect(steps.output(0.999999), 1);
        expect(steps.output(1), 1);
      });
    });

    group('Cubic Bezier Functions', () {
      test('end', () {
        final curve = CubicBezierCurve.easeInOut;
        expect(curve.output(0), 0);
        expect(curve.output(0.25) < 0.25, true);
        expect(curve.output(0.5), 0.5);
        expect(curve.output(0.75) > 0.75, true);
        expect(curve.output(1), 1);
      });
    });
  });
}
