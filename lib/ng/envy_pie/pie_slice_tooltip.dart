/// Defines the content and style of a tooltip displayed when mousing over a pie slice.
class PieSliceTooltip {
  /// Constructs a instance.
  PieSliceTooltip({this.html, this.cssStyle});

  /// The HTML content of the tooltip.
  final String html;

  /// Optional styling for the tooltip.
  final Map<String, String> cssStyle;
}
