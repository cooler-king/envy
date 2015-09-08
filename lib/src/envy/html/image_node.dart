part of envy;

/// [ImageNode] is an Envy scene graph node that manages an
/// HTML Image element.
///
class ImageNode extends HtmlNode with DynamicNode implements CanvasImageSourceNode {
  ImageNode() : super() {
    _initProperties();
  }

  ImageElement generateNode() => new ImageElement();

  ImageElement elementAt(int index) {
    if (_domNodesMap.isNotEmpty) {
      int i = index % _domNodesMap.length;
      List list = new List.from(_domNodesMap.values);
      return list[i] as ImageElement;
    } else {
      _LOG.warning("ImageNode detected empty domNodesMap in elementAt(); returning null");
      return null;
    }
  }

  void _initProperties() {
    properties["alt"] = new StringProperty();
    properties["crossOrigin"] = new StringProperty()
      ..enter = new StringConstant.enumerationValue(CrossOrigin.ANONYMOUS);
    properties["height"] = new NumberProperty();
    properties["isMap"] = new BooleanProperty();
    properties["src"] = new StringProperty();
    //TODO srcset (List of src strings plus width/height thresholds)
    properties["useMap"] = new StringProperty();
    properties["width"] = new NumberProperty();
  }

  StringProperty get src => properties["src"] as StringProperty;

  NumberProperty get width => properties["width"] as NumberProperty;
  NumberProperty get height => properties["height"] as NumberProperty;

  StringProperty get alt => properties["alt"] as StringProperty;
  StringProperty get crossOrigin => properties["crossOrigin"] as StringProperty;
  BooleanProperty get isMap => properties["isMap"] as BooleanProperty;
  StringProperty get useMap => properties["useMap"] as StringProperty;

  @override
  void _updateDom() {
    super._updateDom();

    var value = 0;
    for (int i = 0; i < domNodes.length; i++) {
      ImageElement imageEl = elementAt(i);

      value = src.valueAt(i);
      if (imageEl.src != value) imageEl.src = value;

      value = alt.valueAt(i);
      if (imageEl.alt != value) imageEl.alt = value;

      value = crossOrigin.valueAt(i);
      if (imageEl.crossOrigin != value) imageEl.crossOrigin = value;

      value = height.valueAt(i);
      if (imageEl.height != value) imageEl.height = value.toInt();

      value = isMap.valueAt(i);
      if (imageEl.isMap != value) imageEl.isMap = value;

      value = useMap.valueAt(i);
      if (imageEl.useMap != value) imageEl.useMap = value;

      value = width.valueAt(i);
      if (imageEl.width != value) imageEl.width = value.toInt();
    }
  }
}
