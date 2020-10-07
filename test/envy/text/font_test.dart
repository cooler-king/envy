@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('FontSize', () {
    test('to css string', () {
      FontSize a = FontSize.px(17);
      expect(a.css, '17px');

      a = FontSize.px(9.3);
      expect(a.css, '9.3px');

      a = FontSize.pt(12);
      expect(a.css, '12pt');

      a = FontSize.pt(39.3);
      expect(a.css, '39.3pt');
    });
  });

  group('FontStyle', () {
    test('to css string', () {
      expect(FontStyle.inherit.css, 'inherit');
      expect(FontStyle.initial.css, 'initial');
      expect(FontStyle.italic.css, 'italic');
      expect(FontStyle.normal.css, '');
      expect(FontStyle.oblique.css, 'oblique');

      final FontStyle a = FontStyle.custom('foobar');
      expect(a.css, 'foobar');
    });
  });

  group('Font', () {
    test('to css string', () {
      Font a = Font(size: FontSize.px(17), family: FontFamily.custom('qwerty asdf'));
      expect(a.css, '17px \'qwerty asdf\'');

      a = Font(style: FontStyle.italic, weight: FontWeight.bold, size: FontSize.px(12), family: FontFamily.monospace);
      expect(a.css, 'italic bold 12px monospace');
    });
  });
}
