import 'dart:math' show Point;
import 'package:collection/collection.dart';

/// A collection of points.
class PointList extends DelegatingList<Point<num>> {
  /// Constructs a instance.
  PointList([Iterable<Point<num>> points = const <Point<num>>[]]) : super(List<Point<num>>.from(points));

  /// Adds a point to the end of the list.
  void addPoint(Point<num> value) => add(value);

  /// Adds points to the end of the list.
  void addPoints(Iterable<Point<num>> points) => addAll(points);

  /// The minimum x value in the point collection.
  num get minX {
    if (isEmpty) return double.nan;
    num min = double.infinity;
    for (final pt in this) {
      if (pt.x < min) min = pt.x;
    }
    return min;
  }

  /// The maximum x value in the point collection.
  num get maxX {
    if (isEmpty) return double.nan;
    num max = double.negativeInfinity;
    for (final pt in this) {
      if (pt.x > max) max = pt.x;
    }
    return max;
  }

  /// The minimum y value in the point collection.
  num get minY {
    if (isEmpty) return double.nan;
    num min = double.infinity;
    for (final pt in this) {
      if (pt.y < min) min = pt.y;
    }
    return min;
  }

  /// The maximum y value in the point collection.
  num get maxY {
    if (isEmpty) return double.nan;
    num max = double.negativeInfinity;
    for (final pt in this) {
      if (pt.y > max) max = pt.y;
    }
    return max;
  }

  @override
  String toString() {
    final buf = StringBuffer()..writeln('[');
    for (var i = 0; i < length; i++) {
      buf.writeln('  [$i]  ${this[i]}');
    }
    buf.writeln(']');
    return buf.toString();
  }
}
