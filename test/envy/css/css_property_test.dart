@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('css properties', () {
    group('CssLength', () {
      test('to css string', () {
        final CssLength a = new CssLength(22, CssLengthUnits.px);
        expect(a.css, '22px');
      });
    });
  });
}
