import 'dart:async';
import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';


void main() { 
  
  initPolymer().then((Zone zone) { 
    zone.run(() {
      Polymer.onReady.then((_) {
        // Code that executes after elements have been upgraded.
        _init();
      });
    });
  });
}


void _init() {
  
  EnvyDiv e = querySelector("#envy") as EnvyDiv;
  //print(e);
  //print(e.sceneGraph);
  
  EnvySceneGraph esg = e.sceneGraph;
  
  CanvasNode canvas = new CanvasNode();
  esg.attachToRoot(canvas);
  
  
  // Circle
  Circle2d c = new Circle2d();
  canvas.attach(c);
  
  c.x.enter = new NumberConstant.array([300, 395]);
  c.y.enter = new NumberConstant.array([200]);
  c.radius.enter = new NumberConstant.array([100, 5]);
  c.lineWidth.enter = new NumberConstant.array([5, 1]);
  c.fillStyle.enter = new DrawingStyle2dConstant.array( [
                                                         new DrawingStyle2d(color: Color.BLUE),
                                                         new DrawingStyle2d(color: Color.YELLOW) ]);
  c.strokeStyle.enter = new DrawingStyle2dConstant.array( [
                                                         new DrawingStyle2d(color: Color.CYAN),
                                                         new DrawingStyle2d(color: Color.BLACK) ]);
  

  esg.updateGraph();

}
