import '../../util/enumeration.dart';

/// The dir attribute specifies the text direction of the element's content.
///
class DirAttribute extends Enumeration<String> {
  const DirAttribute(String value) : super(value);

  static const DirAttribute ltr = const DirAttribute('ltr');
  static const DirAttribute rtl = const DirAttribute('rtl');
  static const DirAttribute auto = const DirAttribute('auto');
}
