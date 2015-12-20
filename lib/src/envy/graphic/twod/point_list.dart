part of envy;

class PointList extends DelegatingList<Math.Point> {
  PointList([Iterable<Math.Point> points]) : super(new List<Math.Point>.from(points ?? []));

  void addPoint(Math.Point value) => add(value);

  void addPoints(Iterable<Math.Point> points) => addAll(points);

  //----------------

  num get minX {
    if (isEmpty) return double.NAN;
    num min = double.INFINITY;
    for (var pt in this) {
      if (pt.x < min) min = pt.x;
    }
    return min;
  }

  num get maxX {
    if (isEmpty) return double.NAN;
    num max = double.NEGATIVE_INFINITY;
    for (var pt in this) {
      if (pt.x > max) max = pt.x;
    }
    return max;
  }

  num get minY {
    if (isEmpty) return double.NAN;
    num min = double.INFINITY;
    for (var pt in this) {
      if (pt.y < min) min = pt.y;
    }
    return min;
  }

  num get maxY {
    if (isEmpty) return double.NAN;
    num max = double.NEGATIVE_INFINITY;
    for (var pt in this) {
      if (pt.y > max) max = pt.y;
    }
    return max;
  }

  String toString() {
    var buf = new StringBuffer();
    buf.writeln("[");
    for(int i=0; i<this.length; i++) {
      buf.writeln("  [$i]  ${this[i]}");
    }
    buf.writeln("]");
    return buf.toString();
  }
}
