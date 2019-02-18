import '../envy_property.dart';
import 'html_node.dart';

/// [MediaNode] is an abstract Envy scene graph node that provides a common base for specific media node types
/// such as VideoNode and AudioNode.
abstract class MediaNode extends HtmlNode {
  /// Constructs a new instance.
  MediaNode() : super() {
    _initMediaProperties();
  }

  void _initMediaProperties() {
    properties['autoplay'] = new BooleanProperty();
    properties['closedCaptionsVisible'] = new BooleanProperty();
    //TODO controller?
    properties['controls'] = new BooleanProperty();
    properties['currentTime'] = new NumberProperty();
    properties['defaultMuted'] = new BooleanProperty();
    properties['defaultPlaybackRate'] = new NumberProperty();
    properties['loop'] = new BooleanProperty();
    properties['mediaGroup'] = new StringProperty();
    properties['muted'] = new BooleanProperty();
    properties['playbackRate'] = new NumberProperty();
    properties['preload'] = new StringProperty();
    properties['preservesPitch'] = new BooleanProperty();
    properties['src'] = new StringProperty();
    properties['volume'] = new NumberProperty();
  }

  /// Holds the autoplay values.
  BooleanProperty get autoplay => properties['autoplay'] as BooleanProperty;

  /// Holds the closedCaptionsVisible values.
  BooleanProperty get closedCaptionsVisible => properties['closedCaptionsVisible'] as BooleanProperty;

  /// Holds the controls values.
  BooleanProperty get controls => properties['controls'] as BooleanProperty;

  /// Holds the currentTime values.
  NumberProperty get currentTime => properties['currentTime'] as NumberProperty;

  /// Holds the defaultMuted values.
  BooleanProperty get defaultMuted => properties['defaultMuted'] as BooleanProperty;

  /// Holds the defaultPlaybackRate values.
  NumberProperty get defaultPlaybackRate => properties['defaultPlaybackRate'] as NumberProperty;

  /// Holds the loop values.
  BooleanProperty get loop => properties['loop'] as BooleanProperty;

  /// Holds the mediaGroup values.
  StringProperty get mediaGroup => properties['mediaGroup'] as StringProperty;

  /// Holds the muted values.
  BooleanProperty get muted => properties['muted'] as BooleanProperty;

  /// Holds the playbackRate values.
  NumberProperty get playbackRate => properties['playbackRate'] as NumberProperty;

  /// Holds the preload values.
  StringProperty get preload => properties['preload'] as StringProperty;

  /// Holds the preservesPitch values.
  BooleanProperty get preservesPitch => properties['preservesPitch'] as BooleanProperty;

  /// Holds the src values.
  StringProperty get src => properties['src'] as StringProperty;

  /// Holds the volume values.
  NumberProperty get volume => properties['volume'] as NumberProperty;
}
