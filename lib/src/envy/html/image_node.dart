import 'dart:html';
import '../data/source/string/string_source.dart';
import '../envy_property.dart';
import '../html/enum/cross_origin.dart';
import '../util/logger.dart';
import 'canvas_image_source_node.dart';
import 'html_node.dart';

/// [ImageNode] is an Envy scene graph node that manages an
/// HTML Image element.
class ImageNode extends HtmlNode implements CanvasImageSourceNode {
  /// Constructs a new instance, initializing properties.
  ImageNode() {
    _initProperties();
  }

  @override
  ImageElement generateNode() => new ImageElement();

  @override
  ImageElement elementAt(int index) {
    if (domNodesMap.isNotEmpty) {
      final int i = index % domNodesMap.length;
      final List<Node> list = new List<Node>.from(domNodesMap.values);
      return list[i] as ImageElement;
    } else {
      logger.warning('ImageNode detected empty domNodesMap in elementAt(); returning null');
      return null;
    }
  }

  void _initProperties() {
    properties['alt'] = new StringProperty();
    properties['crossOrigin'] = new StringProperty()
      ..enter = new StringConstant.enumerationValue(CrossOrigin.anonymous);
    properties['height'] = new NumberProperty();
    properties['isMap'] = new BooleanProperty();
    properties['src'] = new StringProperty();
    //TODO srcset (List of src strings plus width/height thresholds)
    properties['useMap'] = new StringProperty();
    properties['width'] = new NumberProperty();
  }

  /// Holds the source of the image.
  StringProperty get src => properties['src'] as StringProperty;

  /// Holds the width of the image.
  NumberProperty get width => properties['width'] as NumberProperty;

  /// Holds the height of the image.
  NumberProperty get height => properties['height'] as NumberProperty;

  /// Holds the alternative text of the image.
  StringProperty get alt => properties['alt'] as StringProperty;

  /// Holds the cross-origin value for the image.
  StringProperty get crossOrigin => properties['crossOrigin'] as StringProperty;

  /// Holds whether the image is a map.
  BooleanProperty get isMap => properties['isMap'] as BooleanProperty;

  /// Holds the useMap values of the image.
  StringProperty get useMap => properties['useMap'] as StringProperty;

  @override
  void updateDom() {
    super.updateDom();

    String strValue;
    num numValue;
    bool tf;
    for (int i = 0; i < domNodes.length; i++) {
      final ImageElement imageEl = elementAt(i);

      strValue = src.valueAt(i);
      if (imageEl.src != strValue) imageEl.src = strValue;

      strValue = alt.valueAt(i);
      if (imageEl.alt != strValue) imageEl.alt = strValue;

      strValue = crossOrigin.valueAt(i);
      if (imageEl.crossOrigin != strValue) imageEl.crossOrigin = strValue;

      numValue = height.valueAt(i);
      if (imageEl.height != numValue) imageEl.height = numValue.toInt();

      tf = isMap.valueAt(i);
      if (imageEl.isMap != tf) imageEl.isMap = tf;

      strValue = useMap.valueAt(i);
      if (imageEl.useMap != strValue) imageEl.useMap = strValue;

      numValue = width.valueAt(i);
      if (imageEl.width != numValue) imageEl.width = numValue.toInt();
    }
  }
}
