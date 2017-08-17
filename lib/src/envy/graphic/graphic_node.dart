import '../dynamic_node.dart';
import '../envy_node.dart';
import '../group_node.dart';

/// Common handle for [GraphicLeaf] and [GraphicGroup] scene graph nodes.
///
abstract class GraphicNode extends EnvyNode {}

abstract class GraphicLeaf extends GraphicNode with DynamicNode {}

class GraphicGroup extends GroupNode {}
