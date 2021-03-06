import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-html-node-population',
  templateUrl: 'test_html_node_population.html',
  directives: <Object>[EnvyScene],
)
class TestHtmlNodePopulation implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @override
  void ngAfterViewInit() {
    testBasic(basicScene);
  }

  void testBasic(EnvyScene e) {
    final esg = e.sceneGraph;

    final div = DivNode();

    //final DivNode n1 = DivNode()..populationStrategy = IndependentPopulationStrategy();
    // TODO make multiple -- need style working
    //div.x.enter = NumberConstant.array([10, 20, 30, 40]);
    //div.y.enter = NumberConstant.array([10, 20, 30 ,40]);

    esg
      ..attachToRoot(div)
      ..updateGraph();
  }
}
