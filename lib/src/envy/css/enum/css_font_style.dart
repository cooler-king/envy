import '../../util/enumeration.dart';

class CssFontStyle extends Enumeration<String> {
  static const CssFontStyle normal = const CssFontStyle("normal");
  static const CssFontStyle italic = const CssFontStyle("italic");
  static const CssFontStyle oblique = const CssFontStyle("oblique");
  static const CssFontStyle inherit = const CssFontStyle("inherit");
  static const CssFontStyle initial = const CssFontStyle("initial");

  const CssFontStyle(String value) : super(value);
}
