import 'package:quantity/quantity.dart' show Angle;
import '../data_source.dart';

abstract class AngleSource extends DataSource<Angle> {}

class AngleConstant extends ArrayDataSource<Angle> implements AngleSource {
  AngleConstant(Angle angle) {
    values.add(angle);
  }

  AngleConstant.array(List<Angle> angles) {
    values.addAll(angles);
  }

  // No-op refresh
  @override
  void refresh() {}
}
