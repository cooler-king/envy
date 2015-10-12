@HtmlImport('resize_detector')
library envy_resize_detector_lib;

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart' show HtmlImport;

List<EnvyResizeDetector> _detectors = [];

bool _looping = false;

void _processFrame() {
  if (_detectors.isEmpty) {
    _looping = false;
    return;
  }
  for (var detector in _detectors) {
    if (detector.clientWidth != detector._prevWidth || detector.clientHeight != detector._prevHeight) {
      detector._prevWidth = detector.clientWidth;
      detector._prevHeight = detector.clientHeight;
      detector.dispatchEvent(EnvyResizeDetector.resizedEvent);
    }
  }

  // Loop
  window.requestAnimationFrame((_) => _processFrame());
}

/// Automatically detects changes in the size of its parent element and
/// fires a 'resized' custom event.
///
/// The parent element must have a position attribute set (e.g., relative
/// or absolute).
///
@PolymerRegister('envy-resize-detector')
class EnvyResizeDetector extends PolymerElement {
  num _prevWidth = 0;
  num _prevHeight = 0;

  static final CustomEvent resizedEvent = new CustomEvent("resized");

  EnvyResizeDetector.created() : super.created();

  num get width => _prevWidth;

  num get height => _prevHeight;

  @override
  void attached() {
    super.attached();

    if (!_detectors.contains(this)) _detectors.add(this);

    // Make sure animation loop is going
    if (!_looping) window.requestAnimationFrame((_) => _processFrame());
  }

  @override
  void detached() {
    super.detached();
    _detectors.remove(this);
  }
}
