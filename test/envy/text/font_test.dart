@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('FontSize', () {
    test('to css string', () {
      var a = new FontSize.px(17);
      expect(a.css, "17px");

      a = new FontSize.px(9.3);
      expect(a.css, "9.3px");

      a = new FontSize.pt(12);
      expect(a.css, "12pt");

      a = new FontSize.pt(39.3);
      expect(a.css, "39.3pt");
    });
  });

  group('FontStyle', () {
    test('to css string', () {
      expect(FontStyle.inherit.css, "inherit");
      expect(FontStyle.initial.css, "initial");
      expect(FontStyle.italic.css, "italic");
      expect(FontStyle.normal.css, "");
      expect(FontStyle.oblique.css, "oblique");

      var a = new FontStyle.custom("foobar");
      expect(a.css, "foobar");
    });
  });

  group('Font', () {
    test('to css string', () {
      var a = new Font(size: new FontSize.px(17), family: new FontFamily.custom("qwerty asdf"));
      expect(a.css, "17px 'qwerty asdf'");

      a = new Font(
          style: FontStyle.italic, weight: FontWeight.bold, size: new FontSize.px(12), family: FontFamily.monospace);
      expect(a.css, "italic bold 12px monospace");
    });
  });
}
