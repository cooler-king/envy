import 'dart:math' as Math;
import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';
import 'package:envy/wc/envy_div.dart';
import 'package:quantity/quantity.dart';

main() async {
  await initPolymer();
  _init();
}


void _init() {
  testBasic();
}

void testBasic() {
  EnvyDiv e = querySelector("#geo-basic") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  // Path
  Path2d s = new Path2d();
  //canvas.addDataset("coords", list: angleData);
  canvas.attach(s);

  var projSource = new ProjectionConstant(new Equirectangular(new Angle(deg: 45)));
  var latSource = new NumberData("coords", canvas, prop: "lat");
  var longSource = new NumberData("coords", canvas, prop: "long");

  /* TODO
  s.points.enter = new GeoPointListDegrees(projSource, latSource, longSource);
  s.x.enter = new NumberConstant.array([50, 250, 450]);
  s.y.enter = new NumberConstant(10);
  s.lineWidth.enter = new NumberConstant(5);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.white));
  s.fill.enter = new BooleanConstant.array([true, true, false]);
  s.stroke.enter = new BooleanConstant.array([true, false, true]);
*/
  esg.updateGraph();
}

