part of envy;

class Font implements CssAdapter {
  FontStyle style;
  FontVariant variant;
  FontWeight weight;
  FontSize size;
  FontFamily family;

  Font({this.style, this.variant, this.weight, this.size, this.family});

  String get css {
    StringBuffer buf = new StringBuffer();
    if (style != null) {
      buf.write(style.css);
      buf.write(" ");
    }
    if (variant != null) {
      buf.write(variant.css);
      buf.write(" ");
    }
    if (weight != null) {
      buf.write(weight.css);
      buf.write(" ");
    }
    if (size != null) {
      buf.write(size.css);
      buf.write(" ");
    } else {
      // always write size
      buf.write("10pt");
      buf.write(" ");
    }
    if (family != null) {
      if (family.css.contains(" ")) {
        buf.write("'${family.css}'");
      } else {
        buf.write(family.css);
      }
    } else {
      // default to sans-serif
      buf.write("sans-serif");
    }
    return buf.toString();
  }
}

/// normal|italic|oblique|initial|inherit
///
class FontStyle implements CssAdapter {
  final String style;

  static final FontStyle normal = new FontStyle._internal("normal");
  static final FontStyle italic = new FontStyle._internal("italic");
  static final FontStyle oblique = new FontStyle._internal("oblique");
  static final FontStyle initial = new FontStyle._internal("initial");
  static final FontStyle inherit = new FontStyle._internal("inherit");

  FontStyle._internal(this.style);

  FontStyle.custom(this.style);

  String get css => style != "normal" ? style : "";
}

/// normal|small-caps|initial|inherit
///
class FontVariant implements CssAdapter {
  final String variant;

  static final FontVariant normal = new FontVariant._internal("normal");
  static final FontVariant smallCaps = new FontVariant._internal("small-caps");
  static final FontVariant initial = new FontVariant._internal("initial");
  static final FontVariant inherit = new FontVariant._internal("inherit");

  FontVariant._internal(this.variant);

  FontVariant.custom(this.variant);

  String get css => variant != "normal" ? variant : "";
}

/// normal|bold|bolder|lighter|number|initial|inherit
///
class FontWeight implements CssAdapter {
  final String weight;

  static final FontWeight normal = new FontWeight._internal("normal");
  static final FontWeight bold = new FontWeight._internal("bold");
  static final FontWeight bolder = new FontWeight._internal("bolder");
  static final FontWeight lighter = new FontWeight._internal("lighter");
  static final FontWeight number = new FontWeight._internal("number");
  static final FontWeight initial = new FontWeight._internal("initial");
  static final FontWeight inherit = new FontWeight._internal("inherit");

  FontWeight._internal(this.weight);

  FontWeight.custom(this.weight);

  String get css => weight != "normal" ? weight : "";
}

/// medium|xx-small|x-small|small|large|x-large|xx-large|smaller|larger|length|initial|inherit;
///
class FontSize implements CssAdapter {
  final String sizeStr;
  final CssLength length;

  static final FontSize medium = new FontSize._internal("medium");
  static final FontSize extraExtraSmall = new FontSize._internal("xx-small");
  static final FontSize extraSmall = new FontSize._internal("x-small");
  static final FontSize small = new FontSize._internal("small");
  static final FontSize large = new FontSize._internal("large");
  static final FontSize extraLarge = new FontSize._internal("x-large");
  static final FontSize extraExtraLarge = new FontSize._internal("xx-large");
  static final FontSize smaller = new FontSize._internal("smaller");
  static final FontSize larger = new FontSize._internal("larger");
  static final FontSize initial = new FontSize._internal("initial");
  static final FontSize inherit = new FontSize._internal("inherit");

  FontSize._internal(this.sizeStr) : length = null;

  FontSize.cssLength(this.length) : sizeStr = null;

  FontSize.px(num pixels)
      : sizeStr = null,
        length = new CssLength.px(pixels);

  FontSize.pt(num points)
      : sizeStr = null,
        length = new CssLength.pt(points);

  String get css => length != null ? length.css : (sizeStr != null && sizeStr != "medium") ? sizeStr : "";
}

/// *|initial|inherit
/// generic: "serif", "sans-serif", "cursive", "fantasy", "monospace".
///
class FontFamily implements CssAdapter {
  final String familyStr;

  static final FontFamily serif = new FontFamily._internal("serif");
  static final FontFamily sansSerif = new FontFamily._internal("sans-serif");
  static final FontFamily cursive = new FontFamily._internal("cursive");
  static final FontFamily fantasy = new FontFamily._internal("fantasy");
  static final FontFamily monospace = new FontFamily._internal("monospace");
  static final FontFamily initial = new FontFamily._internal("initial");
  static final FontFamily inherit = new FontFamily._internal("inherit");

  FontFamily._internal(this.familyStr);

  FontFamily.custom(this.familyStr);

  String get css => familyStr != null ? familyStr : "";
}
