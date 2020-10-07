import 'dart:math' show max;
import '../../../color/color.dart';
import '../number/number_source.dart';
import 'color_source.dart';

/// Generates a color from separate red, green and blue data sources.
class ColorRgb extends ColorSource {
  /// Constructs a instance from existing red, green and blue number sources.
  ColorRgb(this.red, this.green, this.blue);

  //TODO -- array length considerations???
  @override
  Color valueAt(int index) => Color(red?.valueAt(index)?.toDouble() ?? 0.0, green?.valueAt(index)?.toDouble() ?? 0.0,
      blue?.valueAt(index)?.toDouble() ?? 0.0);

  /// The source of the red value (0-1).
  NumberSource red;

  /// The source of the green value (0-1).
  NumberSource green;

  /// The source of the blue value (0-1).
  NumberSource blue;

  @override
  int get rawSize => max(max(red.rawSize, green.rawSize), blue.rawSize);

  // No-op refresh
  @override
  void refresh() {}
}
