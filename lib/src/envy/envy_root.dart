import 'dart:html';
import 'animation/animation_group.dart';
import 'html/html_node.dart';
import 'html/population/population_strategy.dart';

/// The root node of an `EnvySceneGraph`.
///
/// The root node can hold global data sets and automatically created an AnimationGroup node
/// for controlling the properties and display of all child elements.
class EnvyRoot extends HtmlNode {
  EnvyRoot() {
    // Root only ever has a single DivElement DOM node; create it here
    final DomNodeCoupling c = new DomNodeCoupling(parentIndex: 0, propIndex: 0);
    domNodesMap[c] = generateNode();

    _initAnimationNode();
  }

  final AnimationGroup rootAnimation = new AnimationGroup();

  @override
  Node generateNode() => new Element.div()
    ..id = 'envy-root-$hashCode'
    ..style.position = 'absolute'
    ..style.top = '0'
    ..style.left = '0'
    ..style.bottom = '0'
    ..style.right = '0';

  void _initAnimationNode() {
    attach(rootAnimation);
  }
}
