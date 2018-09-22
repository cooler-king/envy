import 'dart:math' show max;
import '../../../color/color.dart';
import '../number/number_source.dart';
import 'color_source.dart';

class ColorRgb extends ColorSource {
  // 0 - 1
  NumberSource red;
  NumberSource green;
  NumberSource blue;

  ColorRgb(this.red, this.green, this.blue);

  //TODO -- array length considerations???
  @override
  Color valueAt(int index) {
    //TODO check for nulls?
    return new Color(
        red?.valueAt(index)?.toDouble() ?? 0.0, green?.valueAt(index)?.toDouble() ?? 0.0, blue?.valueAt(index)?.toDouble() ?? 0.0);

    //TODO even need values array?  or should that be for constants?
    //values[i] = new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));
    //return super.valueAt(i);
  }

  @override
  int get rawSize => max(max(red.rawSize, green.rawSize), blue.rawSize);

  // No-op refresh
  @override
  void refresh() {}
}
