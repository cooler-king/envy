import 'dart:math' as Math;
import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';

void main() async {
  _init();
}

var pointData = new PointList(
    [new Point(1, 5), new Point(20, 20), new Point(40, 10), new Point(60, 40), new Point(80, 5), new Point(100, 60)]);

void _init() {
  testBasic();
  testRotation();
  testAnchors();
  testLifecycle();
  testDataDriven();
  testInterpolation();
  testHit();
}

void testBasic() {
  EnvyScene e = querySelector("#path2d-basic") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  // Path
  Path2d s = new Path2d();
  canvas.addDataset("points", list: pointData);
  canvas.attach(s);

  s.points.enter = new PointListData("points", canvas);
  s.x.enter = new NumberConstant.array([50, 250, 450]);
  s.y.enter = new NumberConstant(10);
  s.lineWidth.enter = new NumberConstant(5);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
  s.fill.enter = new BooleanConstant.array([true, true, false]);
  s.stroke.enter = new BooleanConstant.array([true, false, true]);

  esg.updateGraph();
}

void testRotation() {
  EnvyScene e = querySelector("#path2d-rotation") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  canvas.addDataset("points", list: pointData);
  esg.attachToRoot(canvas);

  // Path
  Path2d s = new Path2d();
  canvas.attach(s);

  s.points.enter = new PointListData("points", canvas);
  s.x.enter = new NumberConstant.array([50, 150, 250, 350, 450]);
  s.y.enter = new NumberConstant(50);
  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

  esg.updateGraph();
}

void testAnchors() {
  EnvyScene e = querySelector("#path2d-anchors") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 200);
  canvas.addDataset("points", list: pointData);
  esg.attachToRoot(canvas);

  Path2d s = new Path2d();
  canvas.attach(s);

  List<num> xList = [50, 250, 450, 650, 850, 1050, 1250, 1450, 1650, 1850];

  s.points.enter = new PointListData("points", canvas);
  s.x.enter = new NumberConstant.array(xList);
  s.y.enter = new NumberConstant(100);
  s.lineWidth.enter = new NumberConstant(1);
  s.rotation.enter = new AngleConstant(new Angle(deg: 0));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
  s.stroke.enter = new BooleanConstant(true);
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

void testLifecycle() {
  EnvyScene e = querySelector("#path2d-lifecycle") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode();
  canvas.addDataset("points", list: pointData);
  esg.attachToRoot(canvas);
  Path2d s = new Path2d();
  canvas.attach(s);

  ButtonElement enterButton = querySelector("#path2d-enter-button");
  enterButton.onClick.listen((_) {
    s.points.enter = new PointListData("points", canvas);
    s.x.enter = new NumberConstant(50);
    s.y.enter = new NumberConstant(50);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
    s.opacity.enter = new NumberConstant(1);

    s.x.update = null;
    s.y.update = null;
    s.lineWidth.update = null;
    s.rotation.update = null;
    s.strokeStyle.update = null;
    s.opacity.update = null;

    esg.updateGraph();
  });

  ButtonElement updateButton = querySelector("#path2d-update-button");
  updateButton.onClick.listen((_) {
    s.points.enter = new PointListData("points", canvas);
    s.x.enter = new NumberConstant(50);
    s.y.enter = new NumberConstant(50);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
    s.opacity.enter = new NumberConstant(1);

    s.points.update = new PointListData("points", canvas);
    s.x.update = new NumberConstant(200);
    s.y.update = new NumberConstant(100);
    s.lineWidth.update = new NumberConstant(3);
    s.rotation.update = new AngleConstant(new Angle(deg: 720));
    s.strokeStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
    s.opacity.update = new NumberConstant(1);
    esg.updateGraph();
  });

  ButtonElement exitButton = querySelector("#path2d-exit-button");
  exitButton.onClick.listen((_) {
    s.points.exit = new PointListData("points", canvas);
    s.x.exit = new NumberConstant(400);
    s.y.exit = new NumberConstant(10);
    s.lineWidth.exit = new NumberConstant(3);
    s.rotation.exit = new AngleConstant(new Angle(deg: 0));
    s.strokeStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
    s.stroke.exit = new BooleanConstant(false);
    s.opacity.exit = new NumberConstant(0);

    s.points.enter = null;
    s.x.enter = null;
    s.y.enter = null;
    s.lineWidth.enter = null;
    s.rotation.enter = null;
    s.strokeStyle.enter = null;
    s.opacity.enter = null;

    s.points.update = null;
    s.x.update = null;
    s.y.update = null;
    s.lineWidth.update = null;
    s.rotation.update = null;
    s.strokeStyle.update = null;
    s.opacity.update = null;

    esg.updateGraph();
  });
}

void testDataDriven() {
  EnvyScene e = querySelector("#path2d-data") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode();
  canvas.addDataset("points", list: pointData);
  esg.attachToRoot(canvas);

  Path2d s = new Path2d();
  s.points.enter = new PointListData("points", canvas);
  s.x.enter = new NumberConstant(50);
  s.y.enter = new NumberConstant(50);
  s.lineWidth.enter = new NumberConstant(1);
  s.rotation.enter = new AngleConstant(new Angle(deg: 0));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.cyan));
  s.opacity.enter = new NumberConstant(1);

  canvas.attach(s);
  esg.updateGraph();

  ButtonElement dataButton = querySelector("#path2d-data-button");
  dataButton.onClick.listen((_) {
    Math.Random rand = new Math.Random();
    var newPointData = new PointList([
      new Point(1, rand.nextDouble() * 300),
      new Point(20, rand.nextDouble() * 300),
      new Point(40, rand.nextDouble() * 300),
      new Point(60, rand.nextDouble() * 300),
      new Point(80, rand.nextDouble() * 300),
      new Point(100 + rand.nextDouble() * 100, rand.nextDouble() * 300)
    ]);

    canvas.addDataset("points", list: newPointData);
    esg.updateGraph();
  });
}

void testInterpolation() {
  EnvyScene e = querySelector("#path2d-interpolation") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  // Path
  Path2d s = new Path2d();
  canvas.addDataset("points", list: pointData);
  canvas.attach(s);

  s.points.enter = new PointListData("points", canvas);
  s.interpolation.enter = new PathInterpolation2dConstant.array([
    PathInterpolation2d.LINEAR,
    PathInterpolation2d.LINEAR_CLOSED,
    PathInterpolation2d.STEP_BEFORE,
    PathInterpolation2d.STEP_AFTER,
    PathInterpolation2d.DIAGONAL
  ]);
  s.x.enter = new NumberConstant.array([50, 250, 450, 650, 850]);
  s.y.enter = new NumberConstant(10);
  s.lineWidth.enter = new NumberConstant(3);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.magenta));
  s.stroke.enter = BooleanConstant.TRUE;
  s.fill.enter = BooleanConstant.TRUE;

  esg.updateGraph();
}

void testHit() {
  EnvyScene e = querySelector("#hit") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 500);
  canvas.addDataset("points", list: pointData);
  esg.attachToRoot(canvas);

  Path2d s = new Path2d();
  canvas.attach(s);

  s.x.enter = new NumberConstant.array([50, 200, 350, 500, 550]);
  s.y.enter = new NumberConstant(50);
  s.points.enter = new PointListData("points", canvas);
  s.lineWidth.enter = new NumberConstant(5);
  s.stroke.enter = BooleanConstant.TRUE;
  s.strokeStyle.enter = new DrawingStyle2dConstant.array([
    new DrawingStyle2d(color: Color.BLUE),
    new DrawingStyle2d(color: Color.BLUE),
    new DrawingStyle2d(color: Color.BLUE),
    new DrawingStyle2d(color: Color.black),
    new DrawingStyle2d(color: Color.RED)
  ]);

  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
  s.onClick.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "CLICKED ${g2di}");
  s.onDoubleClick.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "DOUBLE-CLICKED ${g2di}");
  s.onMouseEnter.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "ENTER ${g2di}");
  s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "OUT ${g2di}");
  s.onMouseOver.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-over").innerHtml = "OVER ${g2di}");
  s.onMouseDown.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-downup").innerHtml = "DOWN ${g2di}");
  s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-downup").innerHtml = "UP ${g2di}");

  esg.updateGraph();
}
