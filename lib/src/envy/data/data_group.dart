import '../group_node.dart';

/// A group node that also holds a map of named data sets.
///
/// A named data set with the same name as one in an ancestor
/// data node, including the global data pool, will override
/// the earlier data.
///
class DataGroup extends GroupNode {
  Map<String, List<Map>> _dataMap = {};

  void update(num fraction, {dynamic context, bool finish: false}) =>
      super.update(fraction, context: context, finish: finish);
}
