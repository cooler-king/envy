import 'dart:collection';
import 'package:collection/collection.dart';
import 'css_property.dart';

/// The default set of CSS properties.
Map<String, CssProperty> defaultProps = <String, CssProperty>{'opacity': new CssNumber(1)};

/// Parallels CssStyleDeclaration.
///
/// Sparse map that holds only set properties.  Values
/// are CssProperty objects to facilitate interpolation.
///
/// { 'opacity': <CssNumber> }
class CssStyle extends DelegatingMap<String, CssProperty> {
  /// Constructs a new instance.
  CssStyle() : super(new HashMap<String, CssProperty>());

  /// Retrieves the default CssProperty for the named property.
  static CssProperty defaultValueForProp(String prop) => new CssString()..initial = true;
}
