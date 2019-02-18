import 'dart:html' show Element, DivElement;
import 'html_node.dart';

/// [DivNode] is an Envy scene graph node that manages an HTML div element.
class DivNode extends HtmlNode {
  @override
  Element generateNode() => new DivElement();
}
