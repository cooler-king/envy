part of envy;

/// The root node of an [EnvySceneGraph].
///
/// The root node can hold global data sets and
/// automatically created an AnimationGroup node
/// for controlling the properties and display
/// of all child elements.
///
class EnvyRoot extends HtmlNode {
  final AnimationGroup rootAnimation = new AnimationGroup();

  EnvyRoot() {

    // Root only ever has a single DivElement DOM node; create it here
    DomNodeCoupling c = new DomNodeCoupling(parentIndex: 0, propIndex: 0);
    _domNodesMap[c] = generateNode();

    _initAnimationNode();
  }

  Node generateNode() => new Element.div()
    ..id = "envy-root-${hashCode}"
    ..attributes["fit"] = "";

  void _initAnimationNode() {
    attach(rootAnimation);
  }

  void update(num fraction, {dynamic context, bool finish: false}) =>
      super.update(fraction, context: context, finish: finish);
}
