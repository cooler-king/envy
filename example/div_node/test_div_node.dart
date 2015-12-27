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
