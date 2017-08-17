import '../css/css_adapter.dart';
import '../util/logger.dart';

class Color implements CssAdapter {
  static const Color white = const Color(1.0, 1.0, 1.0);
  static const Color black = const Color(0.0, 0.0, 0.0);
  static const Color gray = const Color(0.5, 0.5, 0.5);
  static const Color RED = const Color(1.0, 0.0, 0.0);
  static const Color GREEN = const Color(0.0, 1.0, 0.0);
  static const Color BLUE = const Color(0.0, 0.0, 1.0);
  static const Color yellow = const Color(1.0, 1.0, 0.0);
  static const Color cyan = const Color(0.0, 1.0, 1.0);
  static const Color magenta = const Color(1.0, 0.0, 1.0);

  static const Color grayEEE = const Color(0.9375, 0.9375, 0.9375);
  static const Color grayDDD = const Color(0.875, 0.875, 0.875);
  static const Color grayCCC = const Color(0.8125, 0.8125, 0.8125);
  static const Color grayBBB = const Color(0.75, 0.75, 0.75);
  static const Color grayAAA = const Color(0.6875, 0.6875, 0.6875);
  static const Color gray999 = const Color(0.625, 0.625, 0.625);
  static const Color gray888 = const Color(0.5625, 0.5625, 0.5625);
  static const Color gray777 = const Color(0.5, 0.5, 0.5);
  static const Color gray666 = const Color(0.4375, 0.4375, 0.4375);
  static const Color gray555 = const Color(0.375, 0.375, 0.375);
  static const Color gray444 = const Color(0.3125, 0.3125, 0.3125);
  static const Color gray333 = const Color(0.25, 0.25, 0.25);
  static const Color gray222 = const Color(0.1875, 0.1875, 0.1875);
  static const Color gray111 = const Color(0.0625, 0.0625, 0.0625);

  static const Color TRANSPARENT_BLACK = const Color(0.0, 0.0, 0.0, 0.0);

  static const VALUES = const <Color>[
    white,
    black,
    gray,
    RED,
    GREEN,
    BLUE,
    yellow,
    cyan,
    magenta,
    grayEEE,
    grayDDD,
    grayCCC,
    grayBBB,
    grayAAA,
    gray999,
    gray888,
    gray777,
    gray666,
    gray555,
    gray444,
    gray333,
    gray222,
    gray111
  ];

  // RGB values 0.0 - 1.0 (for alpha, 1 means opaque)
  final double red;
  final double green;
  final double blue;
  final double alpha;

  // Calculate once (lazily) for efficiency
  final double perceptiveLuminance;

  const Color(double r, double g, double b, [double a = 1.0])
      : this.red = r,
        this.green = g,
        this.blue = b,
        this.alpha = a,
        perceptiveLuminance = (0.299 * r) + (0.587 * g) + (0.114 * b);

  Color.rgb(double r, double g, double b)
      : this.red = r,
        this.green = g,
        this.blue = b,
        this.alpha = 1.0,
        perceptiveLuminance = (0.299 * r) + (0.587 * g) + (0.114 * b);

  Color.rgba(double r, double g, double b, double a)
      : this.red = r,
        this.green = g,
        this.blue = b,
        this.alpha = a,
        perceptiveLuminance = a * ((0.299 * r) + (0.587 * g) + (0.114 * b));

  Color.hex(String hexStr)
      : this.red = Color.hexStrToDecimal(hexStr, 0),
        this.green = Color.hexStrToDecimal(hexStr, 1),
        this.blue = Color.hexStrToDecimal(hexStr, 2),
        this.alpha = 1.0,
        perceptiveLuminance = (0.299 * Color.hexStrToDecimal(hexStr, 0)) +
            (0.587 * Color.hexStrToDecimal(hexStr, 1)) +
            (0.114 * Color.hexStrToDecimal(hexStr, 2));

  /// Derives a new color from the this color by modifying its
  /// [brightness] and/or [saturation].
  ///
  Color derive({double brightness, double saturation}) {
    List<double> hueSatBr = hsb;
    double s = saturation ?? hueSatBr[1];
    double b = brightness ?? hueSatBr[2];

    List<double> rgb = hsbToRgb(hueSatBr[0], s, b);
    return new Color.rgb(rgb[0], rgb[1], rgb[2]);
  }

  /// Get the hue [0-360], saturation [0-1] and brightness [0-1] values for
  /// this color.
  ///
  List<double> get hsb {
    int r = red256;
    int g = green256;
    int b = blue256;

    double hue, saturation, brightness;
    int cmax = (r > g) ? r : g;
    if (b > cmax) cmax = b;
    int cmin = (r < g) ? r : g;
    if (b < cmin) cmin = b;
    brightness = cmax.toDouble() / 255.0;
    saturation = (cmax != 0) ? (cmax - cmin).toDouble() / cmax.toDouble() : 0.0;

    if (saturation == 0.0) {
      hue = 0.0;
    } else {
      double redc = (cmax - r).toDouble() / (cmax - cmin).toDouble();
      double greenc = (cmax - g).toDouble() / (cmax - cmin).toDouble();
      double bluec = (cmax - b).toDouble() / (cmax - cmin).toDouble();
      if (r == cmax) hue = bluec - greenc;
      else if (g == cmax) hue = 2.0 + redc - bluec;
      else hue = 4.0 + greenc - redc;
      hue *= 60.0;
      if (hue < 0) hue += 360.0;
    }
    return [hue, saturation, brightness];
  }

  /// Returns a [light] or [dark] color, whichever is easiest to see when
  /// superimposed on this color, based on its perceptive luminance.
  ///
  /// The [threshold] determines the level of perceptive luminince at which
  /// the auto text color switches over from light to dark (default is 0.5).
  ///
  Color autoTextColor({Color light: Color.white, Color dark: Color.black, double threshold: 0.5}) {
    if (perceptiveLuminance > threshold) return dark;
    else return light;
  }

  /// Get the value for the red component as an integer in the range 0-255.
  int get red256 => (255 * red).round();

  /**
   * Returns the hexagonal value of the red component.
   *
   * The String will not have any leading '#' or '0x'.
   *
  String get redHex {
    if(value == null) return "00";
    if(value.length == 4) return "${value[1]}${value[1]}";
    if(value.length == 7) return "${value[1]}${value[2]}";

    logger.warning("Malformed color value: ${value}");
    return "00";
  }*/

  /// Get the value for the green component as an integer in the range 0-255.
  //int get green256 => int.parse(greenHex, radix:16);
  int get green256 => (255 * green).round();

  /**
   * Returns the hexagonal value of the green component.
   *
   * The String will not have any leading '#' or '0x'.
   *
  String get greenHex {
    if(value == null) return "00";
    if(value.length == 4) return "${value[2]}${value[2]}";
    if(value.length == 7) return "${value[3]}${value[4]}";

    logger.warning("Malformed color value: ${value}");
    return "00";
  }*/

  /// Get the value for the blue component as an integer in the range 0-255.
  //int get blue256 => int.parse(blueHex, radix:16);
  int get blue256 => (255 * blue).round();

  /**
   * Returns the hexagonal value of the green component.
   *
   * The String will not have any leading '#' or '0x'.
   *
  String get blueHex {
    if(value == null) return "00";
    if(value.length == 4) return "${value[3]}${value[3]}";
    if(value.length == 7) return "${value[5]}${value[6]}";

    logger.warning("Malformed color value: ${value}");
    return "00";
  }*/

  /// Returns a value within the range 0-1 that represents the preceived
  /// luminance (brightness of this color).
  ///
  /// The human eye favors green over red and red over blue.
  ///
  /// Digital CCIR601:  0.299 R + 0.587 G + 0.114 B
  ///
  static double calcPerceptiveLuminance(double red, double green, double blue) {
    return (0.299 * red) + (0.587 * green) + (0.114 * blue);
  }

  /// Converts the components of a color, as specified by the HSB
  /// model, to an equivalent set of values for the RGB model.
  ///
  /// The [saturation] and [brightness] components
  /// should be between in the range 0.0-1.0, inclusive.  The [hue] component
  /// should be between 0 and 360, inclusive and represents the hue angle in
  /// the HSB color model.
  ///
  /// The integer that is returned by <code>HSBtoRGB</code> encodes the
  /// value of a color in bits 0-23 of an integer value that is the same
  /// format used by the method {@link #getRGB() <code>getRGB</code>}.
  /// This integer can be supplied as an argument to the
  /// <code>Color</code> constructor that takes a single integer argument.
  /// saturation, and brightness.
  ///
  static List<double> hsbToRgb(double hue, double saturation, double brightness) {
    if (saturation == 0) {
      // achromatic (grey)
      return [brightness, brightness, brightness];
    }
    double h = hue / 60.0; // sector 0 to 5
    int i = h.floor();
    double f = h - i; // factorial part of h
    double p = brightness * (1 - saturation);
    double q = brightness * (1 - saturation * f);
    double t = brightness * (1 - saturation * (1 - f));
    switch (i) {
      case 0:
        return [brightness, t, p];
      case 1:
        return [q, brightness, p];
      case 2:
        return [p, brightness, t];
      case 3:
        return [p, q, brightness];
      case 4:
        return [t, p, brightness];
      default: // case 5:
        return [brightness, p, q];
    }
  }

  /// Returns a two character hex string for a decimal value between 0 and 1
  /// projected onto the integer range 0 to 255.
  ///
  static String decimalToHexStr(double dec) {
    String str = (dec.clamp(0.0, 1.0) * 255.0).round().toRadixString(16);
    if (str.length == 1) str = "0${str}";
    return str;
  }

  /// The hex string is assumed to start with '#'.  It may be either 4 or 7
  /// character in length.
  ///
  /// [pos]... 0 extract red, 1 extracts green, 2 extracts blue
  ///
  static double hexStrToDecimal(String hexStr, int pos) {
    try {
      if (hexStr == null) return 0.0;
      if (hexStr.length == 4) return int.parse("${hexStr[pos+1]}${hexStr[pos+1]}", radix: 16) / 255.0;
      if (hexStr.length == 7) return int.parse("${hexStr[pos*2 + 1]}${hexStr[pos*2 + 2]}", radix: 16) / 255.0;

      logger.warning("Malformed hex string: ${hexStr}");
    } catch (e) {
      logger.warning("Problem converting hex string to decimal:  ${e}");
      return 0.0;
    }
    return 0.0;
  }

  //--------------------
  // CSS Adapter methods.
  String get css =>
      alpha == 1.0 ? "rgb(${red256},${green256},${blue256})" : "rgba(${red256},${green256},${blue256},${alpha})";

  Color fromCss(String css) {
    try {
      if (css == null || css.isEmpty) return Color.black;
      if (css.startsWith("#")) return new Color.hex(css);
      if (css.startsWith("rgba(")) {
        int comma1 = css.indexOf(",", 5);
        int comma2 = css.indexOf(",", comma1 + 1);
        int comma3 = css.indexOf(",", comma2 + 1);
        int endParens = css.indexOf(")", comma3);
        int r = int.parse(css.substring(5, comma1));
        int g = int.parse(css.substring(comma1 + 1, comma2));
        int b = int.parse(css.substring(comma2 + 1, comma3));
        double a = double.parse(css.substring(comma3 + 1, endParens));
        return new Color.rgba(r / 255, g / 255, b / 255, a);
      }
      if (css.startsWith("rgb(")) {
        int comma1 = css.indexOf(",", 5);
        int comma2 = css.indexOf(",", comma1 + 1);
        int endParens = css.indexOf(")", comma2);
        int r = int.parse(css.substring(5, comma1));
        int g = int.parse(css.substring(comma1 + 1, comma2));
        int b = int.parse(css.substring(comma2 + 1, endParens));
        return new Color.rgb(r / 255, g / 255, b / 255);
      }

      //TODO handle all predefined CSS color names too
      // see http://www.w3schools.com/cssref/css_colornames.asp

      // Give up
      logger.warning("Envy doesn't know how to parse this CSS color value (${css}):  returning black");
      return Color.black;
    } catch (e) {
      logger.warning("Problem parsing CSS color value (${css}):  ${e}");
      return Color.black;
    }
  }

  //--------------------
}
