import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';
import 'package:envy/wc/envy_div.dart';

main() async {
  await initPolymer();
  _init();
  testAnchors();
  testHit();
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
  c.fillStyle.enter = new DrawingStyle2dConstant.array(
      [new DrawingStyle2d(color: Color.BLUE), new DrawingStyle2d(color: Color.yellow)]);
  c.strokeStyle.enter =
      new DrawingStyle2dConstant.array([new DrawingStyle2d(color: Color.cyan), new DrawingStyle2d(color: Color.black)]);

  esg.updateGraph();
}

void testAnchors() {
  EnvyDiv e = querySelector("#anchors") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 200);
  esg.attachToRoot(canvas);

  Circle2d s = new Circle2d();
  canvas.attach(s);

  List<num> xList = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

  s.x.enter = new NumberConstant.array(xList);
  s.y.enter = new NumberConstant(100);
  s.radius.enter = new NumberConstant(30);
  s.lineWidth.enter = new NumberConstant(1);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
  s.stroke.enter = new BooleanConstant(false);
  s.anchor.enter = new Anchor2dConstant.array([
    new Anchor2d(mode: AnchorMode2d.DEFAULT),
    new Anchor2d(mode: AnchorMode2d.CENTER),
    new Anchor2d(mode: AnchorMode2d.BOTTOM),
    new Anchor2d(mode: AnchorMode2d.BOTTOM_LEFT),
    new Anchor2d(mode: AnchorMode2d.BOTTOM_RIGHT),
    new Anchor2d(mode: AnchorMode2d.LEFT),
    new Anchor2d(mode: AnchorMode2d.RIGHT),
    new Anchor2d(mode: AnchorMode2d.TOP),
    new Anchor2d(mode: AnchorMode2d.TOP_LEFT),
    new Anchor2d(mode: AnchorMode2d.TOP_RIGHT)
  ]);

  // Circles to mark the anchors
  Circle2d c = new Circle2d();
  canvas.attach(c);
  c.x.enter = new NumberConstant.array(xList);
  c.y.enter = new NumberConstant(100);
  c.radius.enter = new NumberConstant(2);
  c.lineWidth.enter = new NumberConstant(1);
  c.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
  c.stroke.enter = new BooleanConstant(false);

  esg.updateGraph();
}


void testHit() {
  EnvyDiv e = querySelector("#hit") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 400);
  esg.attachToRoot(canvas);

  // Annular Section
  var s = new Circle2d();
  canvas.attach(s);

  s.x.enter = new NumberConstant(150);
  s.y.enter = new NumberConstant(150);
  s.radius.enter = new NumberConstant.array([120, 60, 30]);
  s.lineWidth.update = new NumberConstant(5);
  s.fillStyle.update = new DrawingStyle2dConstant.array([
    new DrawingStyle2d(color: Color.BLUE),
    new DrawingStyle2d(color: Color.GREEN),
    new DrawingStyle2d(color: Color.cyan),
  ]);

  s.onClick.listen((g2di) => querySelector("#hit-click").innerHtml = "CLICKED ${g2di}");
  s.onDoubleClick.listen((g2di) => querySelector("#hit-click").innerHtml = "DOUBLE-CLICKED ${g2di}");
  s.onMouseEnter.listen((g2di) => querySelector("#hit-enter").innerHtml = "ENTER ${g2di}");
  s.onMouseLeave.listen((g2di) => querySelector("#hit-leave").innerHtml = "LEAVE ${g2di}");
  s.onMouseOut.listen((g2di) => querySelector("#hit-out").innerHtml = "OUT ${g2di}");
  s.onMouseOver.listen((g2di) => querySelector("#hit-over").innerHtml = "OVER ${g2di}");
  s.onMouseDown.listen((g2di) => querySelector("#hit-down-up").innerHtml = "DOWN ${g2di}");
  s.onMouseUp.listen((g2di) => querySelector("#hit-down-up").innerHtml = "UP ${g2di}");

  esg.updateGraph();
}
