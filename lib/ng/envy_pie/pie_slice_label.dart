import 'package:quantity/quantity.dart' show Angle;
import '../../src/envy/graphic/twod/anchor2d.dart';
import '../../src/envy/graphic/twod/drawing_style2d.dart';

/// Defines a label to render associated with a pie slice.
class PieSliceLabel {
  /// Constructs a new instance.
  PieSliceLabel(
      {this.text = '',
      this.anchor,
      this.fillStyle,
      this.opacity = 1,
      this.rotation,
      this.radialPct = 50,
      this.spanPct = 50});

  /// The text of the label.
  final String text;

  /// The anchor point of the label.
  final Anchor2d anchor;

  /// How to render the slice.
  final DrawingStyle2d fillStyle;

  /// THe opacity of the label.
  final num opacity;

  /// The angle to rotate the text (clockwise).
  final Angle rotation;

  /// The location of the anchor between the inner radius (0%) and the outerRadius (100%)
  final num radialPct;

  /// The location of the anchor between the start angle (0%) and the end angle (100%).
  final num spanPct;
}
