import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:angular/angular.dart';

@Component(
  selector: "test-div-node",
  templateUrl: 'test_div_node.html',
  directives: const [EnvyScene],
)
class TestDivNode implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  void ngAfterViewInit() {
    testBasic(basicScene);
  }

  void testBasic(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;

    DivNode div1 = new DivNode();
    div1.id = "test-div";
    //div1.style.border = "1px solid black";
    esg.attachToRoot(div1);

    //div1.x.enter = new NumberConstant.array([300, 100]);
    CssStyle style = new CssStyle();
    //style["background-color"] = new CssColor(0.5);
    style["opacity"] = new CssNumber(0.5);
    style["width"] = new CssLength.pixels(200);
    div1.style.enter = new CssStyleConstant(style);

    esg.updateGraph();
  }
}
