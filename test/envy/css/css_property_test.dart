@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

main() {
  group('css properties', () {
    group('CssLength', () {
      test('to css string', () {
        var a = new CssLength(22, CssLengthUnits.px);
        expect(a.css, "22px");
      });
    });
  });
}
