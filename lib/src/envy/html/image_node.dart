import 'dart:convert' show HtmlEscape;
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
  /// Constructs a instance, initializing properties.
  ImageNode() {
    _initProperties();
  }

  @override
  ImageElement generateNode() => ImageElement();

  @override
  ImageElement elementAt(int index) {
    if (domNodesMap.isNotEmpty) {
      final i = index % domNodesMap.length;
      final list = List<Node>.from(domNodesMap.values);
      return list[i] as ImageElement;
    } else {
      logger.warning('ImageNode detected empty domNodesMap in elementAt(); returning null');
      return null;
    }
  }

  void _initProperties() {
    properties['alt'] = StringProperty();
    properties['crossOrigin'] = StringProperty()..enter = StringConstant.enumerationValue(CrossOrigin.anonymous);
    properties['height'] = NumberProperty();
    properties['isMap'] = BooleanProperty();
    properties['src'] = StringProperty();
    //TODO srcset (List of src strings plus width/height thresholds)
    properties['useMap'] = StringProperty();
    properties['width'] = NumberProperty();
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
    for (var i = 0; i < domNodes.length; i++) {
      final imageEl = elementAt(i);

      strValue = src.valueAt(i);
      if (imageEl.src?.endsWith(strValue) != true) {
        // Browsers have embedded security for image sources (e.g., scripts will not run)
        // ignore: unsafe_html
        imageEl.src = strValue;
      }

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
