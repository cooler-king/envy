part of envy;

class CssFontStyle extends Enumeration<String> {
  static const CssFontStyle NORMAL = const CssFontStyle("normal");
  static const CssFontStyle ITALIC = const CssFontStyle("italic");
  static const CssFontStyle OBLIQUE = const CssFontStyle("oblique");
  static const CssFontStyle INHERIT = const CssFontStyle("inherit");
  static const CssFontStyle INITIAL = const CssFontStyle("initial");

  const CssFontStyle(String value) : super(value);
}
