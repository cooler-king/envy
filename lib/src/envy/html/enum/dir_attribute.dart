import '../../util/enumeration.dart';

/// The dir attribute specifies the text direction of the element's content.
class DirAttribute extends Enumeration<String> {
  /// Constructs a instance.
  const DirAttribute(String value) : super(value);

  /// Left to right.
  static const DirAttribute ltr = DirAttribute('ltr');

  /// Right to left.
  static const DirAttribute rtl = DirAttribute('rtl');

  /// Automatic direction determination.
  static const DirAttribute auto = DirAttribute('auto');
}
