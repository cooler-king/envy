part of envy;

/// [DivNode] is an Envy scene graph node that manages an HTML div element.
///
class DivNode extends HtmlNode {
  DivNode();

  //DivElement get div => super.domNode as DivElement;

  Element generateNode() => new DivElement();
}
