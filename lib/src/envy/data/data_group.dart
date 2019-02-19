import '../group_node.dart';

/// A group node that also holds a map of named data sets.
///
/// A named data set with the same name as one in an ancestor
/// data node, including the global data pool, will override
/// the earlier data.
class DataGroup extends GroupNode {
  /// The data sets held by this group, mapped by name.
  final Map<String, List<Map<dynamic, dynamic>>> dataMap = <String, List<Map<dynamic, dynamic>>>{};
}
