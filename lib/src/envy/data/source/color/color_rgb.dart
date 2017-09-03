import 'dart:math' show max;
import 'color_source.dart';
import '../number/number_source.dart';
import '../../../color/color.dart';

class ColorRgb extends ColorSource {
  // 0 - 1
  NumberSource red;
  NumberSource green;
  NumberSource blue;

  ColorRgb(this.red, this.green, this.blue);

  //TODO -- array length considerations???
  Color valueAt(int i) {
    //TODO check for nulls?
    return new Color(
        red?.valueAt(i)?.toDouble() ?? 0.0, green?.valueAt(i)?.toDouble() ?? 0.0, blue?.valueAt(i)?.toDouble() ?? 0.0);

    //TODO even need values array?  or should that be for constants?
    //values[i] = new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));
    //return super.valueAt(i);
  }

  int get rawSize => max(max(red.rawSize, green.rawSize), blue.rawSize);

  // No-op refresh
  void refresh() {}
}
