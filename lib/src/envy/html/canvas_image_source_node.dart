import 'dart:html' show CanvasImageSource;

/// Provides a common handle for ImageElement, VideoElement and CanvasElement,
/// all of which can be used as the source of an image to be drawn on a Canvas.
// ignore: one_member_abstracts
abstract class CanvasImageSourceNode {
  /// Gets the canvas image source at [index].
  CanvasImageSource elementAt(int index);
}
