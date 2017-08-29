import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';

void main()  {
  _init();
}

void _init() {
  testBasic();
  testRotation();
  testAnchors();
  testLifecycle();
  testHit();
}

void testBasic() {
  EnvyScene e = querySelector("#basic") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  // Triangle
  Triangle2d s = new Triangle2d();
  canvas.attach(s);

  s.x.enter = new NumberConstant.array([75, 225, 375]);
  s.y.enter = new NumberConstant.array([55]);
  s.base.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
  s.lineWidth.enter = new NumberConstant(5);
  s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
  s.fill.enter = new BooleanConstant.array([true, true, false]);
  s.stroke.enter = new BooleanConstant.array([true, false, true]);

  esg.updateGraph();
}

void testRotation() {
  EnvyScene e = querySelector("#rotation") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  // Triangle
  Triangle2d s = new Triangle2d();
  canvas.attach(s);

  s.x.enter = new NumberConstant.array([50, 100, 150, 200, 250]);
  s.y.enter = new NumberConstant(50);
  s.base.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

  esg.updateGraph();
}

void testAnchors() {
  EnvyScene e = querySelector("#anchors") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 200);
  esg.attachToRoot(canvas);

  Triangle2d s = new Triangle2d();
  canvas.attach(s);

  List<num> xList = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

  s.x.enter = new NumberConstant.array(xList);
  s.y.enter = new NumberConstant(100);
  s.base.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
  s.lineWidth.enter = new NumberConstant(1);
  s.rotation.enter = new AngleConstant(new Angle(deg: 0));
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

void testLifecycle() {
  EnvyScene e = querySelector("#lifecycle") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode();
  esg.attachToRoot(canvas);
  Triangle2d s = new Triangle2d();
  canvas.attach(s);

  ButtonElement enterButton = querySelector("#enter-button");
  enterButton.onClick.listen((_) {
    s.x.enter = new NumberConstant(50);
    s.y.enter = new NumberConstant(50);
    s.base.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
    s.opacity.enter = new NumberConstant(1);

    s.x.update = null;
    s.y.update = null;
    s.base.update = null;
    s.height.update = null;
    s.lineWidth.update = null;
    s.rotation.update = null;
    s.fillStyle.update = null;
    s.opacity.update = null;

    esg.updateGraph();
  });

  ButtonElement updateButton = querySelector("#update-button");
  updateButton.onClick.listen((_) {
    s.x.enter = new NumberConstant(50);
    s.y.enter = new NumberConstant(50);
    s.base.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
    s.opacity.enter = new NumberConstant(1);

    s.x.update = new NumberConstant(200);
    s.y.update = new NumberConstant(100);
    s.base.update = new NumberConstant(20);
    s.height.update = new NumberConstant(60);
    s.lineWidth.update = new NumberConstant(3);
    s.rotation.update = new AngleConstant(new Angle(deg: 720));
    s.fillStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
    s.opacity.update = new NumberConstant(1);
    esg.updateGraph();
  });

  ButtonElement exitButton = querySelector("#exit-button") as ButtonElement;
  exitButton.onClick.listen((_) {
    s.x.exit = new NumberConstant(400);
    s.y.exit = new NumberConstant(10);
    s.base.exit = new NumberConstant(1);
    s.height.exit = new NumberConstant(1);
    s.lineWidth.exit = new NumberConstant(3);
    s.rotation.exit = new AngleConstant(new Angle(deg: 0));
    s.fillStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
    s.stroke.exit = new BooleanConstant(false);
    s.opacity.exit = new NumberConstant(0);

    s.x.enter = null;
    s.y.enter = null;
    s.base.enter = null;
    s.height.enter = null;
    s.lineWidth.enter = null;
    s.rotation.enter = null;
    s.fillStyle.enter = null;
    s.opacity.enter = null;

    s.x.update = null;
    s.y.update = null;
    s.base.update = null;
    s.height.update = null;
    s.lineWidth.update = null;
    s.rotation.update = null;
    s.fillStyle.update = null;
    s.opacity.update = null;

    esg.updateGraph();
  });
}

void testHit() {
  EnvyScene e = querySelector("#hit") as EnvyScene;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 500);
  esg.attachToRoot(canvas);

  Triangle2d s = new Triangle2d();
  canvas.attach(s);

  s.x.enter = new NumberConstant.array([50, 150, 250, 350, 375]);
  s.y.enter = new NumberConstant(50);
  s.base.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
  s.lineWidth.enter = new NumberConstant(5);
  s.lineDash.update = new NumberListConstant(new NumberList([3, 3]));
  s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.gray));
  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
  s.fill.enter = BooleanConstant.TRUE;
  s.fillStyle.enter = new DrawingStyle2dConstant.array([
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
  s.onMouseEnter.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-enter").innerHtml = "ENTER ${g2di}");
  s.onMouseLeave.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-leave").innerHtml = "LEAVE ${g2di}");
  s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-out").innerHtml = "OUT ${g2di}");
  s.onMouseOver.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-over").innerHtml = "OVER ${g2di}");
  s.onMouseDown.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-downup").innerHtml = "DOWN ${g2di}");
  s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-downup").innerHtml = "UP ${g2di}");
  s.onMouseMove.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-move").innerHtml = "MOVE ${g2di}");

  esg.updateGraph();
}
