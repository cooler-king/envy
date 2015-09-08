part of envy;

Map<String, CssProperty> defaultProps = {"opacity": new CssNumber(1)};

/// Parallels CssStyleDeclaration.
///
/// Sparse map that holds only set properties.  Values
/// are CssProperty objects to facilitate interpolation.
///
/// { "opacity": <CssNumber> }
///
class CssStyle extends DelegatingMap<String, CssProperty> {
  CssStyle() : super(new HashMap<String, CssProperty>()) {}

  static CssProperty defaultValueForProp(String prop) {
    // Default
    return new CssString()..initial = true;
  }
}
