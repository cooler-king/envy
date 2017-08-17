import 'dart:html';
import 'package:quantity/quantity.dart';
import 'animation/player.dart';
import 'animation/timeline.dart';
import 'envy_node.dart';
import 'envy_root.dart';

class EnvySceneGraph {

  /// Master timeline (can be thought of as the document timeline)
  Timeline masterTimeline = new Timeline.now();

  /// The Envy root node is a DataGroup node
  final EnvyRoot root = new EnvyRoot();

  // The HTML node under which this scne graph will add its contents
  Element _htmlHost;

  EnvySceneGraph([String spec]) {

    //TODO build scene graph nodes from spec
    if (spec != null) applySpec(spec);
  }

  void applySpec(String spec) {
    //TODO envy spec -- add nodes to master animation group
  }

  Element get htmlHost => _htmlHost;

  /// Change the host DOM Element of this Envy scene graph's DOM nodes.
  ///
  void set htmlHost(Element e) {

    //print("html host = ${e}");

    if (_htmlHost != null && _htmlHost != e) {
      root.domNodes.forEach((Node n) {
        n.remove();
      });
    }

    if (e != null) {
      //print("html host appending nodes");
      root.domNodes.forEach((Node n) {
        e.append(n);
      });
    }

    _htmlHost = e;
  }

  /// Updates all scene graph nodes including all property values
  /// based on animation time fractions.
  ///
  void updateGraph() {
    // Create a new Player having current time (plus a little bit) as start time
    // This starts the update loop.
    Player player = masterTimeline.play();

    /*
     *  Tell the masterAnimationGroup to use it (this will make the masterAnimationGroup
     *  register with the player, which will then periodically update it).
     */
    root.rootAnimation.player = player;
  }

  /// A shortcut for adding a node to the root node's animation group
  /// (or directly to the root node if [animatable] is set to false.
  ///
  /// Returns true if the node was successfully added.  Rejects null nodes and
  /// duplicate nodes and returns false.
  ///
  bool attachToRoot(EnvyNode node, [bool animatable = true]) {
    if (node == null) return false;
    if (animatable) {
      return root.rootAnimation.attach(node);
    } else {
      return root.attach(node);
    }
  }

  /// A convenience method to change the iteration duration in the root animation group,
  /// either in [seconds], [millis]econds or [t]ime quantity.
  ///
  /// Only one of the values should be provided.
  ///
  void setAnimationDuration({Time t, num seconds, num millis}) {
    num secs = t != null ? t.mks : seconds != null ? seconds : millis != null ? millis / 1000 : 0;
    root.rootAnimation.timing.iterationDuration = secs;
  }
}
