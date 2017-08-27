import 'dart:html';
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';

@Component(
  selector: "envy-scene",
  templateUrl: 'envy_scene.html',
)
class EnvyScene implements AfterViewInit {
  //TODO input spec
  String spec;

  final EnvySceneGraph sceneGraph = new EnvySceneGraph();

  @ViewChild('envyRoot', read: Element)
  Element root;

  void ngAfterViewInit() {
    sceneGraph.htmlHost = root;
  }

  /// Returns the first canvas element found under the root (or null).
  CanvasElement get canvas => root?.querySelector("canvas") as CanvasElement;

  /// Gets the bounds of the root HTML element.
  Rectangle get bounds => root?.getBoundingClientRect();
}
