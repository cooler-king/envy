import 'dart:math';

/// Holds value and display information for a single series of values.
class LineSeries<X, Y> {
  /// Constructs a new instance.
  LineSeries(this.key, this.label, this.xList, this.yList);

  /// A unique identifier for the series.
  final String key;

  /// A label for the series.
  final String label;

  /// The x-axis values.
  final List<X> xList;

  /// The y-axis values.
  final List<Y> yList;

  /// The effective length of the series is the minimum length of the X and Y lists.
  int get length => min(xList?.length ?? 0, yList?.length ?? 0);
}
