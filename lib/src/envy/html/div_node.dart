import 'dart:html' show Element, DivElement;
import 'html_node.dart';

/// [DivNode] is an Envy scene graph node that manages an HTML div element.
///
class DivNode extends HtmlNode {
  DivNode();

  //DivElement get div => super.domNode as DivElement;

  Element generateNode() => new DivElement();
}
