import '../css/css_adapter.dart';
import '../css/css_property.dart';

/// Represents a Font for rendering text.
class Font implements CssAdapter {
  /// Constructs a new instance.
  Font({this.style, this.variant, this.weight, this.size, this.family});

  /// The font style to apply.
  FontStyle style;

  /// The font variant to apply.
  FontVariant variant;

  /// The font weight to apply.
  FontWeight weight;

  /// The font size in which to render text.
  FontSize size;

  /// The font family to use.
  FontFamily family;

  @override
  String get css {
    final StringBuffer buf = new StringBuffer();
    if (style != null) buf..write(style.css)..write(' ');
    if (variant != null) buf..write(variant.css)..write(' ');
    if (weight != null) buf..write(weight.css)..write(' ');
    if (size != null) {
      buf..write(size.css)..write(' ');
    } else {
      // always write size
      buf..write('10pt')..write(' ');
    }
    if (family != null) {
      if (family.css.contains(' ')) {
        buf.write('\'${family.css}\'');
      } else {
        buf.write(family.css);
      }
    } else {
      // default to sans-serif
      buf.write('sans-serif');
    }
    return buf.toString();
  }
}

/// A font style, such as normal|italic|oblique|initial|inherit.
class FontStyle implements CssAdapter {
  /// Constructs a new instance.
  FontStyle._internal(this.style);

  /// Constructs a new instance with a custom value.
  FontStyle.custom(this.style);

  /// The style value.
  final String style;

  /// Normal font style.
  static final FontStyle normal = new FontStyle._internal('normal');

  /// Italic font style.
  static final FontStyle italic = new FontStyle._internal('italic');

  /// Oblique font style.
  static final FontStyle oblique = new FontStyle._internal('oblique');

  /// The initial font style.
  static final FontStyle initial = new FontStyle._internal('initial');

  /// The inherited font style.
  static final FontStyle inherit = new FontStyle._internal('inherit');

  @override
  String get css => style != 'normal' ? style : '';
}

/// A font variant, such as normal|small-caps|initial|inherit.
class FontVariant implements CssAdapter {
  FontVariant._internal(this.variant);

  /// Constructs a new instance with a custom value.
  FontVariant.custom(this.variant);

  /// The font variant.
  final String variant;

  /// Normal font variant.
  static final FontVariant normal = new FontVariant._internal('normal');

  /// Small caps font variant.
  static final FontVariant smallCaps = new FontVariant._internal('small-caps');

  /// The initial font variant.
  static final FontVariant initial = new FontVariant._internal('initial');

  /// The inherited font variant.
  static final FontVariant inherit = new FontVariant._internal('inherit');

  @override
  String get css => variant != 'normal' ? variant : '';
}

/// A font weight, such as normal|bold|bolder|lighter|number|initial|inherit.
class FontWeight implements CssAdapter {
  FontWeight._internal(this.weight);

  /// Constructs a new instance with a custom value.
  FontWeight.custom(this.weight);

  /// The font weight.
  final String weight;

  /// Normal font weight.
  static final FontWeight normal = new FontWeight._internal('normal');

  /// Bold font weight.
  static final FontWeight bold = new FontWeight._internal('bold');

  /// Bolder font weight.
  static final FontWeight bolder = new FontWeight._internal('bolder');

  /// Lighter font weight.
  static final FontWeight lighter = new FontWeight._internal('lighter');

  /// Number font weight.
  static final FontWeight number = new FontWeight._internal('number');

  /// The initial font weight.
  static final FontWeight initial = new FontWeight._internal('initial');

  /// The inherited font weight.
  static final FontWeight inherit = new FontWeight._internal('inherit');

  @override
  String get css => weight != 'normal' ? weight : '';
}

/// A font size of any valid CSS length or predefined value such as
/// medium|xx-small|x-small|small|large|x-large|xx-large|smaller|larger|length|initial|inherit.
class FontSize implements CssAdapter {
  /// Constructs a new instance from a size string.
  FontSize._internal(this.sizeStr) : length = null;

  /// Constructs a new instance from a CSS length.
  FontSize.cssLength(this.length) : sizeStr = null;

  /// Constructs a new instance with a pixel size.
  FontSize.px(num pixels)
      : sizeStr = null,
        length = new CssLength.px(pixels);

  /// Constructs a new instance with a point size.
  FontSize.pt(num points)
      : sizeStr = null,
        length = new CssLength.pt(points);

  /// The font size value as a string.
  final String sizeStr;

  /// The font size value as a CSS length.
  final CssLength length;

  /// Medium font size.
  static final FontSize medium = new FontSize._internal('medium');

  /// Extra extra small font size.
  static final FontSize extraExtraSmall = new FontSize._internal('xx-small');

  /// Extra small font size.
  static final FontSize extraSmall = new FontSize._internal('x-small');

  /// Small font size.
  static final FontSize small = new FontSize._internal('small');

  /// Large font size.
  static final FontSize large = new FontSize._internal('large');

  /// Extra large font size.
  static final FontSize extraLarge = new FontSize._internal('x-large');

  /// Extra extra large font size.
  static final FontSize extraExtraLarge = new FontSize._internal('xx-large');

  /// Medium font size.
  static final FontSize smaller = new FontSize._internal('smaller');

  /// Medium font size.
  static final FontSize larger = new FontSize._internal('larger');

  /// The initial font size.
  static final FontSize initial = new FontSize._internal('initial');

  /// The inherited font size.
  static final FontSize inherit = new FontSize._internal('inherit');

  @override
  String get css => length?.css ?? ((sizeStr != null && sizeStr != 'medium') ? sizeStr : '');
}

/// A font family, such as *|initial|inherit
/// or generic: 'serif', 'sans-serif', 'cursive', 'fantasy', 'monospace'.
class FontFamily implements CssAdapter {
  FontFamily._internal(this.familyStr);

  /// Constructs a new instance with a custom value.
  FontFamily.custom(this.familyStr);

  /// The font family value.
  final String familyStr;

  /// The generic serif font.
  static final FontFamily serif = new FontFamily._internal('serif');

  /// The generic sans-serif font.
  static final FontFamily sansSerif = new FontFamily._internal('sans-serif');

  /// The generic cursive font.
  static final FontFamily cursive = new FontFamily._internal('cursive');

  /// The generic fantasy font.
  static final FontFamily fantasy = new FontFamily._internal('fantasy');

  /// The generic monospace font.
  static final FontFamily monospace = new FontFamily._internal('monospace');

  /// The initial font.
  static final FontFamily initial = new FontFamily._internal('initial');

  /// The inherited font.
  static final FontFamily inherit = new FontFamily._internal('inherit');

  @override
  String get css => familyStr ?? '';
}
