import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:angular/angular.dart';

@Component(
  selector: "test-circle2d",
  templateUrl: 'test_circle2d.html',
  directives: const [EnvyScene],
)
class TestCircle2d implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('anchors')
  EnvyScene anchorsScene;

  @ViewChild('hit')
  EnvyScene hitScene;

  void ngAfterViewInit() {
    testBasic(basicScene);
    testAnchors(anchorsScene);
    testHit(hitScene);
  }

  void testBasic(EnvyScene e) {
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
    c.strokeStyle.enter = new DrawingStyle2dConstant.array(
        [new DrawingStyle2d(color: Color.cyan), new DrawingStyle2d(color: Color.black)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
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

  void testHit(EnvyScene e) {
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

    s.onClick.listen((Graphic2dIntersection g2di) => querySelector("#hit-click").innerHtml = "CLICKED ${g2di}");
    s.onDoubleClick
        .listen((Graphic2dIntersection g2di) => querySelector("#hit-click").innerHtml = "DOUBLE-CLICKED ${g2di}");
    s.onMouseEnter.listen((Graphic2dIntersection g2di) => querySelector("#hit-enter").innerHtml = "ENTER ${g2di}");
    s.onMouseLeave.listen((Graphic2dIntersection g2di) => querySelector("#hit-leave").innerHtml = "LEAVE ${g2di}");
    s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector("#hit-out").innerHtml = "OUT ${g2di}");
    s.onMouseOver.listen((Graphic2dIntersection g2di) => querySelector("#hit-over").innerHtml = "OVER ${g2di}");
    s.onMouseDown.listen((Graphic2dIntersection g2di) => querySelector("#hit-down-up").innerHtml = "DOWN ${g2di}");
    s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector("#hit-down-up").innerHtml = "UP ${g2di}");

    esg.updateGraph();
  }
}
