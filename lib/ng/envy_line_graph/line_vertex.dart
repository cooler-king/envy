import 'line_vertex_marker.dart';

/// Represents the values and display options for a single vertex.
class LineVertex<X, Y> {
  /// The x-axis value.
  X x;

  /// The y-axis value.
  Y y;

  /// The marker to display at the vertex, if any.
  LineVertexMarker marker;
}
