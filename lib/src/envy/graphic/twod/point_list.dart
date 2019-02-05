import 'dart:math' show Point;
import 'package:collection/collection.dart';

class PointList extends DelegatingList<Point<num>> {
  PointList([Iterable<Point<num>> points]) : super(new List<Point<num>>.from(points ?? <Point<num>>[]));

  void addPoint(Point<num> value) => add(value);

  void addPoints(Iterable<Point<num>> points) => addAll(points);

  //----------------

  num get minX {
    if (isEmpty) return double.nan;
    num min = double.infinity;
    for (Point<num> pt in this) {
      if (pt.x < min) min = pt.x;
    }
    return min;
  }

  num get maxX {
    if (isEmpty) return double.nan;
    num max = double.negativeInfinity;
    for (Point<num> pt in this) {
      if (pt.x > max) max = pt.x;
    }
    return max;
  }

  num get minY {
    if (isEmpty) return double.nan;
    num min = double.infinity;
    for (Point<num> pt in this) {
      if (pt.y < min) min = pt.y;
    }
    return min;
  }

  num get maxY {
    if (isEmpty) return double.nan;
    num max = double.negativeInfinity;
    for (Point<num> pt in this) {
      if (pt.y > max) max = pt.y;
    }
    return max;
  }

  @override
  String toString() {
    final StringBuffer buf = new StringBuffer()..writeln('[');
    for (int i = 0; i < length; i++) {
      buf.writeln('  [$i]  ${this[i]}');
    }
    buf.writeln(']');
    return buf.toString();
  }
}
