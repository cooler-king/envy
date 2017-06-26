import 'dart:html';
import 'package:angular2/angular2.dart';
import 'package:envy/envy.dart';

//encapsulation: ViewEncapsulation.Native,
@Component(
    selector: "envy-scene",
    templateUrl: 'envy_scene.html')
class EnvyScene implements AfterViewInit {
  //TODO input spec
  String spec;

  final EnvySceneGraph _sceneGraph = new EnvySceneGraph();
  EnvySceneGraph get sceneGraph => _sceneGraph;

  @ViewChild('envyRootEl')
  ElementRef envyRootEl;

  void ngAfterViewInit() {
    //print("Envy div ATTACHED");
    sceneGraph.htmlHost = envyRootEl.nativeElement;
    //sceneGraph.updateGraph();
  }

  /// Returns the first canvas element found under the root (or null).
  CanvasElement get canvas {
    Element root = envyRootEl.nativeElement;
    return root?.querySelector("canvas") as CanvasElement;
  }

}
