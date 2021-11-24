import 'dynamic_node.dart';
import 'envy_node.dart';

/// A generic group nodes holds any number of child nodes but has
/// no other state and no rendered component.
class GroupNode extends EnvyNode {
  /// The group's child nodes.
  /// DO NOT MODIFY THE CONTENTS OF children DIRECTLY.  Use only attach() and detach().
  final List<EnvyNode> children = List<EnvyNode>.from(<EnvyNode>[]);

  /// Subclasses must override to execute any updates prior to child updates
  /// (but after property updates).
  void groupUpdatePre(num timeFraction, {dynamic context, bool finish = false}) {
    // No-op default
  }

  /// Subclasses must override to execute any updates after child updates
  /// (and after property updates and any groupUpdatePre updates).
  void groupUpdatePost(num timeFraction, {dynamic context, bool finish = false}) {
    // No-op default
  }

  /// Set start and target values for an animation update for each property.
  @override
  void prepareForAnimation() {
    if (this is DynamicNode) (this as DynamicNode).preparePropertiesForAnimation();
    for (final child in children) {
      if (child is DynamicNode) (child as DynamicNode).preparePropertiesForAnimation();
      if (child is GroupNode) child.prepareForAnimation();
    }
  }

  /// Update the dynamic properties, execute any auxiliary group update and then
  /// update the group's children (in that order).
  @override
  void update(num timeFraction, {dynamic context, bool finish = false}) {
    // Update any dynamic properties
    super.update(timeFraction, context: context, finish: finish);

    // Opportunity for subclasses to execute post-property/pre-child updates
    groupUpdatePre(timeFraction, context: context, finish: finish);

    // Update children
    for (final child in children) {
      child.update(timeFraction, context: context, finish: finish);
    }

    // Opportunity for subclasses to execute post-child updates
    groupUpdatePost(timeFraction, context: context, finish: finish);

    // Nothing to render.
  }

  /// A shortcut for adding a child node to this group.
  ///
  /// The node will be appended at the end of the list of children unless
  /// [index] is provided, in which case the node will be inserted at the
  /// specified (zero-based) child index.  If the index is out of range
  /// the node will be appended.
  ///
  /// Returns true if the node was successfully added.  Rejects null nodes and
  /// duplicate nodes and returns false.
  bool attach(EnvyNode node, [int? index]) {
    if (children.contains(node)) return false;
    if (index == null || (index < 0 || index >= children.length)) {
      children.add(node);
    } else {
      children.insert(index, node);
    }
    node
      ..parent = this
      ..prepareForAnimation();
    return true;
  }

  /// A shortcut for removing a child node from this group.
  ///
  /// Returns true if the node was successfully removed.  Null nodes and
  /// nodes that are not in the current child list cannot be removed and
  /// return false.
  bool detach(EnvyNode node) {
    final tf = children.remove(node);
    node.parent = null;
    return tf;
  }
}
