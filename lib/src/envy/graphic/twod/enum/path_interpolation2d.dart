import '../../../util/enumeration.dart';

/// How to draw a line between the points in a path.
///
class PathInterpolation2d extends Enumeration<String> {
  static const PathInterpolation2d linear = const PathInterpolation2d('linear');
  static const PathInterpolation2d linearClosed = const PathInterpolation2d('linear-closed');
  static const PathInterpolation2d stepBefore = const PathInterpolation2d('step-before');
  static const PathInterpolation2d stepAfter = const PathInterpolation2d('step-after');
  static const PathInterpolation2d diagonal = const PathInterpolation2d('diagonal');

  const PathInterpolation2d(String value) : super(value);

  static PathInterpolation2d from(dynamic d) {
    if (d is PathInterpolation2d) return d;
    if (d is String) {
      final String lc = d.trim().toLowerCase();
      if (lc == 'linear') return PathInterpolation2d.linear;
      if (lc == 'step-before') return PathInterpolation2d.stepBefore;
      if (lc == 'step-after') return PathInterpolation2d.stepAfter;
      if (lc == 'diagonal') return PathInterpolation2d.diagonal;
    }

    return PathInterpolation2d.linear;
  }
}
