import '../dynamic_node.dart';
import '../envy_node.dart';
import '../group_node.dart';

/// Common handle for [GraphicLeaf] and [GraphicGroup] scene graph nodes.
abstract class GraphicNode extends EnvyNode {}

/// A GraphicLeaf is A GraphicNode with dynamic property values.
abstract class GraphicLeaf extends GraphicNode with DynamicNode {}

/// A GraphicGroup is a type of GroupNode.
class GraphicGroup extends GroupNode {}
