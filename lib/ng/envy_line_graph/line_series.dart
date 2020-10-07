import 'dart:math';

/// Holds value and display information for a single series of values.
class LineSeries<X, Y> {
  /// A unique identifier for the series.
  String key;

  /// A label for the series.
  String label;

  /// The x-axis values.
  List<X> xList;

  /// The y-axis values.
  List<Y> yList;

  /// The effective length of the series is the minimum length of the X and Y lists.
  int get length => min(xList?.length ?? 0, yList?.length ?? 0);
}
