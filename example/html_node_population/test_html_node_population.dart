import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';
import 'package:envy/wc/envy_div.dart';

main() async {
  await initPolymer();
  _init();
}

void _init() {
  EnvyDiv e = querySelector("#envy") as EnvyDiv;
  //print(e);
  //print(e.sceneGraph);

  EnvySceneGraph esg = e.sceneGraph;

  //
  DivNode div = new DivNode();
  esg.attachToRoot(div);

  DivNode n1 = new DivNode();
  n1.populationStrategy = new IndependentPopulationStrategy();
  // TODO make multiple -- need style working
  //div.x.enter = new NumberConstant.array([10, 20, 30, 40]);
  //div.y.enter = new NumberConstant.array([10, 20, 30 ,40]);

  esg.updateGraph();
}
