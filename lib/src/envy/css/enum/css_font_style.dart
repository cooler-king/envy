import '../../util/enumeration.dart';

/// CSS font style enumerated values.
class CssFontStyle extends Enumeration<String> {
  /// Construct a instance.
  const CssFontStyle(String value) : super(value);

  /// Normal font style.
  static const CssFontStyle normal = const CssFontStyle('normal');

  /// Italic font style.
  static const CssFontStyle italic = const CssFontStyle('italic');

  /// Oblique font style.
  static const CssFontStyle oblique = const CssFontStyle('oblique');

  /// Inherit font style.
  static const CssFontStyle inherit = const CssFontStyle('inherit');

  /// Initial font style.
  static const CssFontStyle initial = const CssFontStyle('initial');
}
