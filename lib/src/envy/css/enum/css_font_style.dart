import '../../util/enumeration.dart';

/// CSS font style enumerated values.
class CssFontStyle extends Enumeration<String> {
  /// Construct a instance.
  const CssFontStyle(String value) : super(value);

  /// Normal font style.
  static const CssFontStyle normal = CssFontStyle('normal');

  /// Italic font style.
  static const CssFontStyle italic = CssFontStyle('italic');

  /// Oblique font style.
  static const CssFontStyle oblique = CssFontStyle('oblique');

  /// Inherit font style.
  static const CssFontStyle inherit = CssFontStyle('inherit');

  /// Initial font style.
  static const CssFontStyle initial = CssFontStyle('initial');
}
