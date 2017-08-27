import 'dart:async';
import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: "test-annular-section2d",
  templateUrl: 'test_annular_section2d.html',
  directives: const [EnvyScene],
)
class TestAnnularSection2d implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('rotation')
  EnvyScene rotationScene;

  @ViewChild('circle')
  EnvyScene circleScene;

  @ViewChild('anchors')
  EnvyScene anchorsScene;

  @ViewChild('lifecycle')
  EnvyScene lifecycleScene;

  @ViewChild('hit')
  EnvyScene hitScene;

  @ViewChild('fill')
  EnvyScene fillScene;

  void ngAfterViewInit() {
    testBasic(basicScene);
    testRotation(rotationScene);
    testCircle(circleScene);
    testAnchors(anchorsScene);
    testLifecycle(lifecycleScene);
    testHit(hitScene);
    testFill(fillScene);
  }

  void testBasic(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Annular Section
    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array([75, 225, 375]);
    s.y.enter = new NumberConstant.array([55]);
    s.innerRadius.enter = new NumberConstant(25);
    s.outerRadius.enter = new NumberConstant(50);
    s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
    s.endAngle.enter = new AngleConstant(new Angle(deg: 45));
    s.lineWidth.enter = new NumberConstant(2);
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
    s.fill.enter = new BooleanConstant.array([true, true, false]);
    s.stroke.enter = new BooleanConstant.array([true, false, true]);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Annular Section
    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array([50, 100, 150, 200, 250]);
    s.y.enter = new NumberConstant(50);
    s.innerRadius.enter = new NumberConstant(10);
    s.outerRadius.enter = new NumberConstant(20);
    s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
    s.endAngle.enter = new AngleConstant(new Angle(deg: 45));
    s.rotation.enter = new AngleConstant.array(
        [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testCircle(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Annular Section
    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array([75, 225, 375]);
    s.y.enter = new NumberConstant.array([55]);
    s.innerRadius.enter = new NumberConstant(25);
    s.outerRadius.enter = new NumberConstant(50);
    s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
    s.endAngle.enter = new AngleConstant(new Angle(deg: 360));
    s.lineWidth.enter = new NumberConstant(2);
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.grayCCC));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.GREEN));
    s.fill.enter = new BooleanConstant.array([true, true, false]);
    s.stroke.enter = new BooleanConstant.array([true, false, true]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    List<num> xList = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = new NumberConstant.array(xList);
    s.y.enter = new NumberConstant(100);
    s.innerRadius.enter = new NumberConstant(10);
    s.outerRadius.enter = new NumberConstant(20);
    s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
    s.endAngle.enter = new AngleConstant(new Angle(deg: 45));
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

  void testLifecycle(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 500);
    esg.attachToRoot(canvas);
    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    ButtonElement enterButton = querySelector("#enter-button");
    enterButton.onClick.listen((_) {
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.innerRadius.enter = new NumberConstant(10);
      s.outerRadius.enter = new NumberConstant(20);
      s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
      s.endAngle.enter = new AngleConstant(new Angle(deg: 45));
      s.lineWidth.enter = new NumberConstant(1);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.gray999));
      s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.GREEN));
      s.stroke.enter = new BooleanConstant(true);

      s.x.update = null;
      s.y.update = null;
      s.innerRadius.update = null;
      s.outerRadius.update = null;
      s.startAngle.update = null;
      s.endAngle.update = null;
      s.lineWidth.update = null;
      s.rotation.update = null;
      s.fillStyle.update = null;

      esg.updateGraph();
    });

    ButtonElement updateButton = querySelector("#update-button");
    updateButton.onClick.listen((_) {
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.innerRadius.enter = new NumberConstant(10);
      s.outerRadius.enter = new NumberConstant(20);
      s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
      s.endAngle.enter = new AngleConstant(new Angle(deg: 45));
      s.lineWidth.enter = new NumberConstant(1);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
      s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.GREEN));
      s.stroke.enter = new BooleanConstant(true);

      s.x.update = new NumberConstant(200);
      s.y.update = new NumberConstant(100);
      s.innerRadius.update = new NumberConstant(30);
      s.outerRadius.update = new NumberConstant(50);
      s.startAngle.update = new AngleConstant(new Angle(deg: 30));
      s.endAngle.update = new AngleConstant(new Angle(deg: 360));
      s.lineWidth.update = new NumberConstant(3);
      s.rotation.update = new AngleConstant(new Angle(deg: 720));
      s.fillStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
      s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.cyan));
      s.stroke.enter = new BooleanConstant(true);
      esg.updateGraph();
    });

    ButtonElement exitButton = querySelector("#exit-button");
    exitButton.onClick.listen((_) {
      s.x.exit = new NumberConstant(400);
      s.y.exit = new NumberConstant(10);
      s.innerRadius.exit = new NumberConstant(2);
      s.outerRadius.exit = new NumberConstant(4);
      s.startAngle.exit = new AngleConstant(new Angle(deg: 0));
      s.endAngle.exit = new AngleConstant(new Angle(deg: 45));
      s.lineWidth.exit = new NumberConstant(3);
      s.rotation.exit = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
      s.stroke.exit = new BooleanConstant(false);
      s.opacity.exit = new NumberConstant(0.01);

      s.x.enter = null;
      s.y.enter = null;
      s.innerRadius.enter = null;
      s.outerRadius.enter = null;
      s.startAngle.enter = null;
      s.endAngle.enter = null;
      s.lineWidth.enter = null;
      s.rotation.enter = null;
      s.fillStyle.enter = null;
      s.strokeStyle.enter = null;
      s.stroke.enter = null;

      s.x.update = null;
      s.y.update = null;
      s.innerRadius.update = null;
      s.outerRadius.update = null;
      s.startAngle.update = null;
      s.endAngle.update = null;
      s.lineWidth.update = null;
      s.rotation.update = null;
      s.fillStyle.update = null;
      s.strokeStyle.update = null;
      s.stroke.update = null;

      esg.updateGraph();
    });
  }

  void testHit(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    // Annular Section
    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array([150, 300, 450, 600, 650]);
    s.y.enter = new NumberConstant(150);
    s.innerRadius.enter = new NumberConstant(30);
    s.outerRadius.enter = new NumberConstant(120);
    s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
    s.endAngle.enter = new AngleConstant.array([new Angle(deg: 90), new Angle(deg: 180), new Angle(deg: 360)]);
    s.lineWidth.update = new NumberConstant(5);
    s.fillStyle.update = new DrawingStyle2dConstant.array([
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(color: Color.black),
      new DrawingStyle2d(color: Color.RED)
    ]);

    s.rotation.enter = new AngleConstant.array(
        [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
    s.onClick.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "CLICKED ${g2di}");
    s.onDoubleClick
        .listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "DOUBLE-CLICKED ${g2di}");
    s.onMouseEnter.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "ENTER ${g2di}");
    s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback").innerHtml = "OUT ${g2di}");
    s.onMouseOver
        .listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-over").innerHtml = "OVER ${g2di}");
    s.onMouseDown
        .listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-downup").innerHtml = "DOWN ${g2di}");
    s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector("#hit-feedback-downup").innerHtml = "UP ${g2di}");

    esg.updateGraph();
  }

  void testFill(EnvyScene e) {
    //EnvyScene e = querySelector("#fill") as EnvyScene;
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    ImageElement image = new ImageElement(
        width: 30,
        height: 30,
        src: "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");
    // Annular Section
    AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array([50, 200, 350, 460, 650]);
    s.y.enter = new NumberConstant.array([50, 50, 50, 10, 50]);
    s.innerRadius.enter = new NumberConstant(0);
    s.outerRadius.enter = new NumberConstant(40);
    s.startAngle.enter = new AngleConstant(new Angle(deg: 0));
    s.endAngle.enter = new AngleConstant(new Angle(deg: 270));
    s.fill.enter = BooleanConstant.TRUE;
    s.anchor.enter = new Anchor2dConstant.array(
        [new Anchor2d(), new Anchor2d(), new Anchor2d(), new Anchor2d(mode: AnchorMode2d.TOP_LEFT), new Anchor2d()]);
    s.fillStyle.enter = new DrawingStyle2dConstant.array([
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(
          gradient: new LinearGradient2d(x0: -20, x1: 40, y0: -20, y1: 40)
            ..addColorStop(0, Color.gray777)
            ..addColorStop(0.5, Color.BLUE)
            ..addColorStop(1, Color.cyan)),
      new DrawingStyle2d(
          gradient: new RadialGradient2d(x0: 0, y0: 0, r0: 5, x1: 0, y1: 0, r1: 35)
            ..addColorStop(0, Color.GREEN)
            ..addColorStop(0.3, Color.BLUE)
            ..addColorStop(0.7, Color.RED)
            ..addColorStop(1, Color.black)),
      new DrawingStyle2d(
          pattern: new ImagePattern2d(image,
              patternWidth: 80,
              patternHeight: 80,
              //patternOffsetX: -40,
              //patternOffsetY: -40,
              repeat: PatternRepeat.noRepeat)),
      new DrawingStyle2d(color: Color.TRANSPARENT_BLACK)
    ]);

    esg.updateGraph();
  }
}
