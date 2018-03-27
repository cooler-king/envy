import '../../../util/enumeration.dart';

/// Supported values: start (default), end, left, right or center.
///
/// Note that these values are not the same as the supported CSS text-align values.
///
class TextAlign2d extends Enumeration<String> {
  static const TextAlign2d start = const TextAlign2d('start');
  static const TextAlign2d end = const TextAlign2d('end');
  static const TextAlign2d left = const TextAlign2d('left');
  static const TextAlign2d right = const TextAlign2d('right');
  static const TextAlign2d center = const TextAlign2d('center');

  const TextAlign2d(String value) : super(value);

  static TextAlign2d from(dynamic d) {
    if (d is TextAlign2d) return d;
    if (d is String) {
      final String lc = d.trim().toLowerCase();
      if (lc == 'left') return TextAlign2d.left;
      if (lc == 'right') return TextAlign2d.right;
      if (lc == 'center') return TextAlign2d.center;
      if (lc == 'start') return TextAlign2d.start;
      if (lc == 'end') return TextAlign2d.end;
    }

    return TextAlign2d.start;
  }
}
