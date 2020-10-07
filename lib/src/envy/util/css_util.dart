import 'dart:html';
import '../util/logger.dart';

// ignore_for_file: avoid_classes_with_only_static_members

/// CSS-related utilities.
class CssUtil {
  /// Calculated conversions.
  static final Map<String, num> convert = <String, num>{};

  /// Useful conversions.
  static final List<num> conversions = <num>[1 / 25.4, 1 / 2.54, 1 / 72, 1 / 6];

  /// Unit regular expression.
  static const String runit = r'/^(-?[\d+\.\-]+)([a-z]+|%)$/i';

  static void _initAbsoluteUnitConversions() {
    final units = <String>['mm', 'cm', 'pt', 'pc', 'in', 'mozmm'];

    // Create a test element and add it to the DOM.
    var testElem = document.createElement('test');
    document.documentElement.append(testElem);

    // Pre-calculate absolute unit conversions.
    for (var i = units.length - 1; i >= 0; i--) {
      convert['${units[i]}toPx'] = i < 4 ? conversions[i] * convert['inToPx'] : toPixels(testElem, '1${units[i]}');
    }

    // Remove the test element from the DOM and delete it.
    testElem.remove();
    testElem = null;
  }

  /// Converts a [value] to pixels.
  /// Uses width as the property when checking computed style by default.
  static num toPixels(Element element, String value, [String prop = 'width', bool force = false]) {
    CssStyleDeclaration style;
    num pixels;

    // Initialize conversion values if necessary.
    if (convert.isEmpty) CssUtil._initAbsoluteUnitConversions();

    // If no element is provided, create a test element and add to DOM
    var elem = element;
    var dummyElement = false;
    if (elem == null) {
      elem = document.createElement('test');
      document.documentElement.append(elem);
      dummyElement = true;
    }

    final matches = List<Match>.from(runit.allMatches(value));
    final unit = matches.isNotEmpty ? matches.first.group(0)[2] : '';
    //String unit = (value.match(runit)||[])[2],
    var conversion = (unit == 'px') ? 1 : convert['${unit}toPx'];

    if (conversion != null) {
      pixels = _parsePixels(value) * conversion;
    } else if ((unit == 'em' || unit == 'rem') && !force) {
      // use the correct element for rem or fontSize + em or em
      elem = (unit == 'rem') ? document.documentElement : (prop == 'font-size') ? (elem.parent ?? elem) : elem;

      // use fontSize of the element for rem and em
      conversion = _parsePixels(CssUtil.curCSS(elem, 'font-size'));

      // multiply the value by the conversion
      pixels = num.parse(value) * conversion;
    } else {
      // remember the current style
      style = elem.style;
      final inlineValue = style.getPropertyValue(prop);

      // set the style on the target element
      try {
        style.setProperty(prop, value);
      } catch (e) {
        // IE 8 and below throw an exception when setting unsupported units
        return 0;
      }

      // read the computed value
      // if style is nothing we probably set an unsupported unit
      final computedValue = style.getPropertyValue(prop);
      pixels = (computedValue == null || computedValue.isEmpty) ? 0 : _parsePixels(curCSS(elem, prop));

      // reset the style back to what it was or blank it out
      style.setProperty(prop, inlineValue);
    }

    // Remove dummy elememt
    if (dummyElement) {
      elem.remove();
      elem = null;
    }

    // return a number
    return pixels;
  }

  static num _parsePixels(String pxCss) {
    try {
      if (pxCss.endsWith('px')) {
        return num.parse(pxCss.substring(0, pxCss.length - 2));
      } else {
        return num.parse(pxCss);
      }
    } catch (e, s) {
      logger.severe('Unable to parse pixel value: $pxCss', e, s);
      return 0;
    }
  }

  /// Returns the computed value of a CSS property.
  static String curCSS(Element elem, String prop) {
    // Init computedValuesBug flag if first time.
    if (convert.isEmpty) CssUtil._initAbsoluteUnitConversions();

    // FireFox, Chrome/Safari, Opera and IE9+
    var value = elem.getComputedStyle().getPropertyValue(prop);

    // check the unit
    final matches = List<Match>.from(runit.allMatches(value));
    final unit = matches.isNotEmpty ? matches.first.group(0) : '';
    if (value == 'auto' || (unit != null && unit != 'px')) {
      // WebKit and Opera will return auto in some cases
      // Firefox will pass back an unaltered value when it can't be set, like top on a static element
      value = '0';
    }
    return value;
  }
}
