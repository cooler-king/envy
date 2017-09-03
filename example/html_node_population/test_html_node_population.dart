import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:angular/angular.dart';

@Component(
  selector: "test-html-node-population",
  templateUrl: 'test_html_node_population.html',
  directives: const [EnvyScene],
)
class TestHtmlNodePopulation implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  void ngAfterViewInit() {
    testBasic(basicScene);
  }

  void testBasic(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;

    DivNode div = new DivNode();
    esg.attachToRoot(div);

    DivNode n1 = new DivNode();
    n1.populationStrategy = new IndependentPopulationStrategy();
    // TODO make multiple -- need style working
    //div.x.enter = new NumberConstant.array([10, 20, 30, 40]);
    //div.y.enter = new NumberConstant.array([10, 20, 30 ,40]);

    esg.updateGraph();
  }
}
