import '../../util/enumeration.dart';

/// The dir attribute specifies the text direction of the element's content.
///
class DirAttribute extends Enumeration<String> {
  static const DirAttribute LTR = const DirAttribute("ltr");
  static const DirAttribute RTL = const DirAttribute("rtl");
  static const DirAttribute AUTO = const DirAttribute("auto");

  const DirAttribute(String value) : super(value);
}
