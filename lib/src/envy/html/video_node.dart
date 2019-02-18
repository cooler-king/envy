import 'dart:html';
import '../envy_property.dart';
import 'canvas_image_source_node.dart';
import 'media_node.dart';

/// [VideoNode] is an Envy scene graph node that manages an HTML video element.
class VideoNode extends MediaNode implements CanvasImageSourceNode {
  /// Constructs a new instance.
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

  /// The width of the video.
  NumberProperty get width => properties['width'] as NumberProperty;

  /// The height of the video.
  NumberProperty get height => properties['height'] as NumberProperty;

  /// The poster.
  StringProperty get poster => properties['poster'] as StringProperty;
}
