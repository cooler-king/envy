part of envy;

class ColorRgb extends ColorSource {

  // 0 - 1
  NumberSource red;
  NumberSource green;
  NumberSource blue;

  ColorRgb(this.red, this.green, this.blue);

  //TODO -- array length considerations???
  Color valueAt(int i) {

    //TODO check for nulls?
    return new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));

    //TODO even need values array?  or shoudl that be for constants?
    //values[i] = new Color(red.valueAt(i), green.valueAt(i), blue.valueAt(i));
    //return super.valueAt(i);
  }

  int get rawSize => Math.max(Math.max(red.rawSize, green.rawSize), blue.rawSize);

  // No-op refresh
  void refresh() {}
}
