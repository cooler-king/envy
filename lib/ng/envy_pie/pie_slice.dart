import 'package:envy/envy.dart';

/// Contains information about a single pie slice.
class PieSlice {
  /// Constructs a new instance.
  PieSlice({this.key, this.value, this.label, this.fillStyle, this.strokeStyle, this.tooltip});

  /// The slice's unique id;
  final String key;

  /// The numerical value of the slice.
  final num value;

  /// The optional label to display directly in the slice.
  final String label;

  /// How to render the slice.
  final DrawingStyle2d fillStyle;

  /// How to render the border of the slice.
  final DrawingStyle2d strokeStyle;

  /// THe opacity of the slice.
  final num opacity = 1;

  /// The optional tooltip to display when hovering over the slice.
  final String tooltip;
}
