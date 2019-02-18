import 'package:quantity/quantity.dart' show Angle;
import '../data_source.dart';

/// A common handle for all angle sources.
abstract class AngleSource extends DataSource<Angle> {}

/// A constant angle value.
class AngleConstant extends ArrayDataSource<Angle> implements AngleSource {
  /// Constructs a enw instance from an existing angle.
  AngleConstant(Angle angle) {
    values.add(angle);
  }

  /// Constructs a enw instance from an existing list of angles.
  AngleConstant.array(List<Angle> angles) {
    values.addAll(angles);
  }

  // No-op refresh.
  @override
  void refresh() {}
}
