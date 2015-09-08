part of envy;

/// Common handle for [GraphicLeaf] and [GraphicGroup] scene graph nodes.
///
abstract class GraphicNode extends EnvyNode {}

abstract class GraphicLeaf extends GraphicNode with DynamicNode {}

class GraphicGroup extends GroupNode {}
