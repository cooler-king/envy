import '../envy_property.dart';
import 'html_node.dart';

/// [MediaNode] is an abstract Envy scene graph node that provides a common base for specific media node types
/// such as VideoNode and AudioNode.
abstract class MediaNode extends HtmlNode {
  /// Constructs a instance.
  MediaNode() : super() {
    _initMediaProperties();
  }

  void _initMediaProperties() {
    properties['autoplay'] = BooleanProperty();
    properties['closedCaptionsVisible'] = BooleanProperty();
    //TODO controller?
    properties['controls'] = BooleanProperty();
    properties['currentTime'] = NumberProperty();
    properties['defaultMuted'] = BooleanProperty();
    properties['defaultPlaybackRate'] = NumberProperty();
    properties['loop'] = BooleanProperty();
    properties['mediaGroup'] = StringProperty();
    properties['muted'] = BooleanProperty();
    properties['playbackRate'] = NumberProperty();
    properties['preload'] = StringProperty();
    properties['preservesPitch'] = BooleanProperty();
    properties['src'] = StringProperty();
    properties['volume'] = NumberProperty();
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
