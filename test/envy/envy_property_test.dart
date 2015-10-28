@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

main() {
  group('Envy Property', () {
    test('Contructors', () {
      var p = new GenericProperty(defaultValue: "someValue");
      expect(p is EnvyProperty, true);
      expect(p.defaultValue, "someValue");

      p = new GenericProperty(defaultValue: 42);
      expect(p.defaultValue, 42);
    });

    var p = new NakedProperty(defaultValue: 1234);

    p.enter = new NumberConstant.array([1, 2, 3, 4, 5]);
    p.update = new NumberConstant.array([66, 77, 88, 99, 110]);
    p.exit = new NumberConstant.array([-99, -98, -97, -96, -95]);

    test('_preparePropertyForAnimation', () {
      p.preparePropertyForAnimation(5);
      expect(p.defaultValue, 1234);
      expect(p.startValues[0], 1);
      expect(p.startValues[1], 2);
      expect(p.startValues[2], 3);
      expect(p.startValues[3], 4);
      expect(p.startValues[4], 5);
      expect(p.targetValues[0], 66);
      expect(p.targetValues[1], 77);
      expect(p.targetValues[2], 88);
      expect(p.targetValues[3], 99);
      expect(p.targetValues[4], 110);
    });

    test('updateValues', () {
      p.preparePropertyForAnimation(5);
      p.updateValues(0);
      expect(p.currentValues[0], 1);
      expect(p.currentValues[1], 2);
      expect(p.currentValues[2], 3);
      expect(p.currentValues[3], 4);
      expect(p.currentValues[4], 5);
      p.updateValues(0.49);
      expect(p.currentValues[0], 1);
      expect(p.currentValues[1], 2);
      expect(p.currentValues[2], 3);
      expect(p.currentValues[3], 4);
      expect(p.currentValues[4], 5);
      p.updateValues(0.51);
      expect(p.currentValues[0], 66);
      expect(p.currentValues[1], 77);
      expect(p.currentValues[2], 88);
      expect(p.currentValues[3], 99);
      expect(p.currentValues[4], 110);
      p.updateValues(0.5);
      expect(p.currentValues[0], 66);
      expect(p.currentValues[1], 77);
      expect(p.currentValues[2], 88);
      expect(p.currentValues[3], 99);
      expect(p.currentValues[4], 110);
      p.updateValues(1);
      expect(p.currentValues[0], 66);
      expect(p.currentValues[1], 77);
      expect(p.currentValues[2], 88);
      expect(p.currentValues[3], 99);
      expect(p.currentValues[4], 110);
    });
  });
}
