import 'dart:collection';
import 'package:collection/collection.dart';
import 'css_property.dart';

/// The default set of CSS properties.
Map<String, CssProperty> defaultProps = <String, CssProperty>{'opacity': CssNumber(1)};

/// Parallels CssStyleDeclaration.
///
/// Sparse map that holds only set properties.  Values
/// are CssProperty objects to facilitate interpolation.
///
/// { 'opacity': <CssNumber> }
class CssStyle extends DelegatingMap<String, CssProperty> {
  /// Constructs a instance.
  CssStyle() : super(HashMap<String, CssProperty>());

  /// Retrieves the default CssProperty for the named property.
  static CssProperty defaultValueForProp(String prop) => CssString()..initial = true;
}
