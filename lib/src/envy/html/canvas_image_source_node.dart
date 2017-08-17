/// Provides a common handle for ImageElement, VideoElement and CanvasElement,
/// all of which can be used as the source of an image to be drawn on a Canvas.
///
abstract class CanvasImageSourceNode {
  dynamic elementAt(int index);
}
