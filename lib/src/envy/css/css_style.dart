import 'dart:collection';
import 'package:collection/collection.dart';
import 'css_property.dart';

Map<String, CssProperty> defaultProps = <String, CssProperty>{'opacity': new CssNumber(1)};

/// Parallels CssStyleDeclaration.
///
/// Sparse map that holds only set properties.  Values
/// are CssProperty objects to facilitate interpolation.
///
/// { 'opacity': <CssNumber> }
///
class CssStyle extends DelegatingMap<String, CssProperty> {
  CssStyle() : super(new HashMap<String, CssProperty>());

  static CssProperty defaultValueForProp(String prop) => new CssString()..initial = true;
}
