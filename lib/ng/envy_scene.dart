import 'package:angular2/angular2.dart';
import 'package:envy/envy.dart';

@Component(
    selector: "envy-scene",
    encapsulation: ViewEncapsulation.Native,
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

}
