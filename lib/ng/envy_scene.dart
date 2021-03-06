import 'dart:html';
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';

/// Manages and renders an Envy scene.
@Component(
  selector: 'envy-scene',
  templateUrl: 'envy_scene.html',
  styleUrls: <String>['envy_scene.css'],
)
class EnvyScene implements AfterViewInit {
  ///TODO input spec
  String spec;

  /// Defines the scene components.
  final EnvySceneGraph sceneGraph = EnvySceneGraph();

  /// A reference to the wrapper element.
  @ViewChild('envyWrapper', read: Element)
  Element wrapper;

  @override
  void ngAfterViewInit() {
    sceneGraph.htmlHost = wrapper;
  }

  /// Returns the first canvas element found under the root (or null).
  CanvasElement get canvas => wrapper?.querySelector('canvas') as CanvasElement;

  /// Gets the bounds of the root HTML element.
  Rectangle<num> get bounds => wrapper?.getBoundingClientRect();
}
