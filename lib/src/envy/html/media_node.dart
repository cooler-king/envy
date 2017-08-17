import 'html_node.dart';
import '../envy_property.dart';

/// [MediaNode] is an abstract Envy scene graph node that provides a common base for specific media node types
/// such as VideoNode and AudioNode.
///
abstract class MediaNode extends HtmlNode {
  MediaNode() : super() {
    _initMediaProperties();
  }

  void _initMediaProperties() {
    properties["autoplay"] = new BooleanProperty();
    properties["closedCaptionsVisible"] = new BooleanProperty();
    //TODO controller?
    properties["controls"] = new BooleanProperty();
    properties["currentTime"] = new NumberProperty();
    properties["defaultMuted"] = new BooleanProperty();
    properties["defaultPlaybackRate"] = new NumberProperty();
    properties["loop"] = new BooleanProperty();
    properties["mediaGroup"] = new StringProperty();
    properties["muted"] = new BooleanProperty();
    properties["playbackRate"] = new NumberProperty();
    properties["preload"] = new StringProperty();
    properties["preservesPitch"] = new BooleanProperty();
    properties["src"] = new StringProperty();
    properties["volume"] = new NumberProperty();
  }

  BooleanProperty get autoplay => properties["autoplay"] as BooleanProperty;
  BooleanProperty get closedCaptionsVisible => properties["closedCaptionsVisible"] as BooleanProperty;
  BooleanProperty get controls => properties["controls"] as BooleanProperty;
  NumberProperty get currentTime => properties["currentTime"] as NumberProperty;
  BooleanProperty get defaultMuted => properties["defaultMuted"] as BooleanProperty;
  NumberProperty get defaultPlaybackRate => properties["defaultPlaybackRate"] as NumberProperty;
  BooleanProperty get loop => properties["loop"] as BooleanProperty;
  StringProperty get mediaGroup => properties["mediaGroup"] as StringProperty;
  BooleanProperty get muted => properties["muted"] as BooleanProperty;
  NumberProperty get playbackRate => properties["playbackRate"] as NumberProperty;
  StringProperty get preload => properties["preload"] as StringProperty;
  BooleanProperty get preservesPitch => properties["preservesPitch"] as BooleanProperty;
  StringProperty get src => properties["src"] as StringProperty;
  NumberProperty get volume => properties["volume"] as NumberProperty;
}
