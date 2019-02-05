import 'dart:html';
import '../envy_property.dart';
import 'canvas_image_source_node.dart';
import 'media_node.dart';

/// [VideoNode] is an Envy scene graph node that manages an HTML video element.
///
class VideoNode extends MediaNode implements CanvasImageSourceNode {
  VideoNode() {
    _initVideoElement();
  }

  void _initVideoElement() {
    properties['width'] = new NumberProperty();
    properties['height'] = new NumberProperty();
    properties['poster'] = new StringProperty();
  }

  @override
  Element generateNode() => new VideoElement();

  @override
  VideoElement elementAt(int index) {
    final int i = index % domNodesMap.length;
    final List<Node> list = new List<Node>.from(domNodesMap.values);
    return list[i] as VideoElement;
  }

  NumberProperty get width => properties['width'] as NumberProperty;
  NumberProperty get height => properties['height'] as NumberProperty;
  StringProperty get poster => properties['poster'] as StringProperty;
}
