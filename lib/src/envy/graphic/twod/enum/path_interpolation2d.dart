import '../../../util/enumeration.dart';

/// How to draw a line between the points in a path.
///
class PathInterpolation2d extends Enumeration<String> {
  static const PathInterpolation2d LINEAR = const PathInterpolation2d("linear");
  static const PathInterpolation2d LINEAR_CLOSED = const PathInterpolation2d("linear-closed");
  static const PathInterpolation2d STEP_BEFORE = const PathInterpolation2d("step-before");
  static const PathInterpolation2d STEP_AFTER = const PathInterpolation2d("step-after");
  static const PathInterpolation2d DIAGONAL = const PathInterpolation2d("diagonal");

  const PathInterpolation2d(String value) : super(value);

  static PathInterpolation2d from(dynamic d) {
    if (d is PathInterpolation2d) return d;
    if (d is String) {
      String lc = d.trim().toLowerCase();
      if (lc == "linear") return PathInterpolation2d.LINEAR;
      if (lc == "step-before") return PathInterpolation2d.STEP_BEFORE;
      if (lc == "step-after") return PathInterpolation2d.STEP_AFTER;
      if (lc == "diagonal") return PathInterpolation2d.DIAGONAL;
    }

    return PathInterpolation2d.LINEAR;
  }
}
