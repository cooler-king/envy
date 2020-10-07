import '../../src/envy/graphic/twod/drawing_style2d.dart';
import 'pie_slice_label.dart';
import 'pie_slice_tooltip.dart';

/// Contains information about a single pie slice.
class PieSlice {
  /// Constructs a instance.
  PieSlice(
      {this.key,
      this.value,
      this.label,
      this.fillStyle,
      this.opacity = 1,
      this.strokeStyle,
      this.tooltip,
      this.payload});

  /// The slice's unique id.
  final String key;

  /// The numerical value of the slice.
  final num value;

  /// An optional label to display along with the slice.
  final PieSliceLabel label;

  /// How to render the slice.
  final DrawingStyle2d fillStyle;

  /// How to render the border of the slice.
  final DrawingStyle2d strokeStyle;

  /// THe opacity of the slice.
  final num opacity;

  /// The optional tooltip to display when hovering over the slice.
  final PieSliceTooltip tooltip;

  /// Any other data.
  Object payload;
}
