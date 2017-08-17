import 'dynamic_node.dart';
import 'envy_node.dart';


/// A generic group nodes holds any number of child nodes but has
/// no other state and no rendered component.
///
class GroupNode extends EnvyNode {
  //@observable
  //final ObservableList<EnvyNode> children = new ObservableList.from([]);

  // DO NOT MODIFY THE CONTENTS OF children DIRECTLY.  Use only attach() and detach().
  final List<EnvyNode> children = new List.from(<EnvyNode>[]);

  GroupNode() {
    /*
    // Listen for changes to list of children and manage parent references
    children.listChanges.listen((List<ListChangeRecord> changes) {
      //print("GroupNode received children changes...");
      //print("GroupNode received children changes... ${changes.length}");
      for (var lcr in changes) {
        //changes.forEach((ListChangeRecord lcr) {
        //print("GroupNode received children LIST change... added ${lcr.addedCount}");
        //print("GroupNode received children LIST change... removed ${lcr.removed}");

        // Reset parent of removed nodes to null
        if (lcr.removed != null && lcr.removed.isNotEmpty) {
          lcr.removed.forEach((x) {
            //print("GroupNode received children changes... removed ${x}");
            if (x is EnvyNode) {
              x.parent = null;
            }
          });
        }

        // Set parent of added nodes
        if (lcr.addedCount != null && lcr.addedCount > 0) {
          for (int i = children.length - lcr.addedCount; i < children.length; i++) {
            //print("i = ${i}");
            //print("GroupNode received children changes... added ${children[i]}");
            if (children[i] is EnvyNode) {
              children[i].parent = this;
              children[i]._prepareForAnimation();
            }
          }
        }
      }
    });*/
  }

  /// Subclasses must override to execute any updates prior to child updates
  /// (but after property updates).
  ///
  void groupUpdatePre(num timeFraction, {dynamic context, bool finish: false}) {
    // No-op default
  }

  /// Subclasses must override to execute any updates after child updates
  /// (and after property updates and any groupUpdatePre updates).
  ///
  void groupUpdatePost(num timeFraction, {dynamic context, bool finish: false}) {
    // No-op default
  }

  /// Set start and target values for an animation update for each property.
  ///
  void prepareForAnimation() {
    //print("Timed item group preparing for animation");
    if (this is DynamicNode) (this as DynamicNode).preparePropertiesForAnimation();
    /*
    children.where((EnvyNode child) => child is DynamicNode).forEach((child) {
      //print("timed item group preparing child dynamic node for animation");
        (child as DynamicNode)._prepareForAnimation();
    });*/

    for (var child in children) {
      if (child is DynamicNode) (child as DynamicNode).preparePropertiesForAnimation();
      if (child is GroupNode) child.prepareForAnimation();
    }
  }

  /// Update the dynamic properties, execute any auxiliary group update and then
  /// update the group's children (in that order).
  ///
  @override
  void update(num timeFraction, {dynamic context, bool finish: false}) {
    // print("group update fraction = ${timeFraction}");
    // Update any dynamic properties
    super.update(timeFraction, context: context, finish: finish);

    // Opportunity for subclasses to execute post-property/pre-child updates
    groupUpdatePre(timeFraction, context: context, finish: finish);

    // Update children
    for (var child in children) {
      //int start = new DateTime.now().millisecondsSinceEpoch;
      //print("group update node = ${child}");
      child.update(timeFraction, context: context, finish: finish);
      //print("group update node = ${child} took ${new DateTime.now().millisecondsSinceEpoch - start}");
    }

    // Opportunity for subclasses to execute post-child updates
    groupUpdatePost(timeFraction, context: context, finish: finish);

    // nothing to render
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
  ///
  bool attach(EnvyNode node, [int index]) {
    if (node == null || children.contains(node)) return false;
    if (index == null || (index < 0 || index >= children.length)) {
      children.add(node);
    } else {
      children.insert(index, node);
    }
    node.parent = this;
    node.prepareForAnimation();
    return true;
  }

  /// A shortcut for removing a child node from this group.
  ///
  /// Returns true if the node was successfully removed.  Null nodes and
  /// nodes that are not in the current child list cannot be removed and
  /// return false.
  ///
  bool detach(EnvyNode node) {
    if (node == null) return false;
    bool tf = children.remove(node);
    node.parent = null;
    return tf;
  }
}
