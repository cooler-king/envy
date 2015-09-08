part of envy;

/// [VideoNode] is an Envy scene graph node that manages an HTML video element.
///
class VideoNode extends MediaNode implements CanvasImageSourceNode {
  VideoNode() {
    _initVideoElement();
  }

  void _initVideoElement() {
    properties["width"] = new NumberProperty();
    properties["height"] = new NumberProperty();
    properties["poster"] = new StringProperty();
  }

  Element generateNode() => new VideoElement();

  VideoElement elementAt(int index) {
    int i = index % _domNodesMap.length;
    List list = new List.from(_domNodesMap.values);
    return list[i] as VideoElement;
  }

  NumberProperty get width => properties["width"] as NumberProperty;
  NumberProperty get height => properties["height"] as NumberProperty;
  StringProperty get poster => properties["poster"] as StringProperty;
}
