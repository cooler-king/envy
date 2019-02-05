import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-html-node-population',
  templateUrl: 'test_html_node_population.html',
  directives: const <Object>[EnvyScene],
)
class TestHtmlNodePopulation implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @override
  void ngAfterViewInit() {
    testBasic(basicScene);
  }

  void testBasic(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;

    final DivNode div = new DivNode();
    esg.attachToRoot(div);

    //final DivNode n1 = new DivNode()..populationStrategy = new IndependentPopulationStrategy();
    // TODO make multiple -- need style working
    //div.x.enter = new NumberConstant.array([10, 20, 30, 40]);
    //div.y.enter = new NumberConstant.array([10, 20, 30 ,40]);

    esg.updateGraph();
  }
}
