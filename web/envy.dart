import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';

main() async {
  await initPolymer();
  _init();
}

void _init() {
  EnvyDiv e = querySelector("#envy") as EnvyDiv;
  //print(e);
  //print(e.sceneGraph);

  EnvySceneGraph esg = e.sceneGraph;

  CanvasNode canvas = new CanvasNode(500, 500);
  esg.attachToRoot(canvas);

  // Rect
  Rect2d rect = new Rect2d();
  canvas.attach(rect);

  rect.x.enter = new NumberConstant.array([300, 100]);
  rect.y.enter = new NumberConstant.array([200, 300]);
  rect.width.enter = new NumberConstant(200);
  rect.height.enter = new NumberConstant(100);
  rect.lineWidth.enter = new NumberConstant(15);
  rect.globalAlpha.enter = new NumberConstant(0.1);

  rect.shadowBlur.enter = new NumberConstant(50);
  rect.shadowColor.enter = new ColorConstant(Color.RED);

  rect.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));

  rect.x.update = new NumberConstant(150);
  rect.y.update = new NumberConstant(100);
  rect.width.update = new NumberConstant.array([300, 100]);
  rect.height.update = new NumberConstant.array([50, 200]);
  rect.lineWidth.update = new NumberConstant(2);
  rect.globalAlpha.update = new NumberConstant(0.6);

  rect.shadowBlur.update = new NumberConstant(10);
  rect.shadowColor.update = new ColorConstant(Color.YELLOW);

  // Text
  Text2d text = new Text2d();
  canvas.attach(text);

  text.x.enter = new NumberConstant.array([300, 100]);
  text.y.enter = new NumberConstant.array([200, 300]);
  text.maxWidth.enter = new NumberConstant.array([200, 100]);
  text.text.enter = new StringConstant("This is sample text!");

  esg.updateGraph();
}
