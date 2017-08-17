import 'package:quantity/quantity.dart' show Angle;
import '../data_source.dart';

abstract class AngleSource extends DataSource<Angle> {}

class AngleConstant extends ArrayDataSource<Angle> implements AngleSource {
  AngleConstant(Angle angle) {
    this.values.add(angle);
  }

  AngleConstant.array(List<Angle> angles) {
    this.values.addAll(angles);
  }

  // No-op refresh
  void refresh() {}
}
