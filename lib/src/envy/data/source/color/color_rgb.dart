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
  dynamic valueAt(int i) {

    //TODO check for nulls?
    return new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));

    //TODO even need values array?  or should that be for constants?
    //values[i] = new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));
    //return super.valueAt(i);
  }

  int get rawSize => max(max(red.rawSize, green.rawSize), blue.rawSize);

  // No-op refresh
  void refresh() {}
}
