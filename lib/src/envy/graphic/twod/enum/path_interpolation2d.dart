import '../../../util/enumeration.dart';

/// How to draw a line between the points in a path.
///
class PathInterpolation2d extends Enumeration<String> {
  /// Construct a constant two-dimensional path interpolation.
  const PathInterpolation2d(String value) : super(value);

  /// Linear path interpolation.
  static const PathInterpolation2d linear = const PathInterpolation2d('linear');

  /// Linear-closed path interpolation.
  static const PathInterpolation2d linearClosed = const PathInterpolation2d('linear-closed');

  /// Step-before path interpolation.
  static const PathInterpolation2d stepBefore = const PathInterpolation2d('step-before');

  /// Step-after path interpolation.
  static const PathInterpolation2d stepAfter = const PathInterpolation2d('step-after');

  /// Diagonal path interpolation.
  static const PathInterpolation2d diagonal = const PathInterpolation2d('diagonal');

  /// Attempts to convert [d] into a PathInterpolation2d object.
  /// Returns linear if the value is not recognized.
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
