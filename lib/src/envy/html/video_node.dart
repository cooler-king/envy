import 'dart:html';
import '../envy_property.dart';
import 'canvas_image_source_node.dart';
import 'media_node.dart';

/// [VideoNode] is an Envy scene graph node that manages an HTML video element.
class VideoNode extends MediaNode implements CanvasImageSourceNode {
  /// Constructs a instance.
  VideoNode() {
    _initVideoElement();
  }

  void _initVideoElement() {
    properties['width'] = NumberProperty();
    properties['height'] = NumberProperty();
    properties['poster'] = StringProperty();
  }

  @override
  Element generateNode() => VideoElement();

  @override
  VideoElement elementAt(int index) {
    final i = index % domNodesMap.length;
    final list = List<Node>.from(domNodesMap.values);
    return list[i] as VideoElement;
  }

  /// The width of the video.
  NumberProperty get width => properties['width'] as NumberProperty;

  /// The height of the video.
  NumberProperty get height => properties['height'] as NumberProperty;

  /// The poster.
  StringProperty get poster => properties['poster'] as StringProperty;
}
