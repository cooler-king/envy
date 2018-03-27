import 'population_strategy.dart';

/// A type of population strategy where (copies of) the generated children
/// are *all* added to each parent DOM node.
///
/// The total number of child DOM nodes will be product of the parent count
/// times the nominal child count.
///
/// Singleton:  does not have any state.
///
class IndependentPopulationStrategy extends PopulationStrategy {
  static IndependentPopulationStrategy _instance;

  factory IndependentPopulationStrategy() => _instance ??= new IndependentPopulationStrategy._internal();

  IndependentPopulationStrategy._internal();

  /// Generate the coupling list.
  ///
  @override
  List<DomNodeCoupling> determineCoupling(int parentCount, int childCount) {
    final List<DomNodeCoupling> list = <DomNodeCoupling>[];

    int c;
    for (int p = 0; p < parentCount; p++) {
      for (c = 0; c < childCount; c++) {
        list.add(new DomNodeCoupling(parentIndex: p, propIndex: c));
      }
    }

    return list;
  }
}
