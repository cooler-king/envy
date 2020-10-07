import 'dart:html';
import 'dart:math' show Random;
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-annular-section2d',
  templateUrl: 'test_annular_section2d.html',
  directives: <Object>[
    EnvyScene,
  ],
)
class TestAnnularSection2d implements AfterViewInit {
  @ViewChild('basic', read: EnvyScene)
  EnvyScene basicScene;

  @ViewChild('rotation', read: EnvyScene)
  EnvyScene rotationScene;

  @ViewChild('circle', read: EnvyScene)
  EnvyScene circleScene;

  @ViewChild('anchors', read: EnvyScene)
  EnvyScene anchorsScene;

  @ViewChild('lifecycle', read: EnvyScene)
  EnvyScene lifecycleScene;

  @ViewChild('hit', read: EnvyScene)
  EnvyScene hitScene;

  @ViewChild('fill', read: EnvyScene)
  EnvyScene fillScene;

  @ViewChild('enterButton', read: Element)
  Element enterButton;

  @ViewChild('updateButton', read: Element)
  Element updateButton;

  @ViewChild('exitButton', read: Element)
  Element exitButton;

  Map<String, Angle> anchorDatamap = <String, Angle>{'startAngle': angle0, 'endAngle': angle90};

  @override
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
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Annular Section
    final s = AnnularSection2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = NumberConstant.array(<num>[55]);
    s.innerRadius.enter = NumberConstant(25);
    s.outerRadius.enter = NumberConstant(50);
    s.startAngle.enter = AngleConstant(Angle(deg: 0));
    s.endAngle.enter = AngleConstant(Angle(deg: 45));
    s.lineWidth.enter = NumberConstant(2);
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
    s.fill.enter = BooleanConstant.array(<bool>[true, true, false]);
    s.stroke.enter = BooleanConstant.array(<bool>[true, false, true]);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Annular Section
    final s = AnnularSection2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 100, 150, 200, 250]);
    s.y.enter = NumberConstant(50);
    s.innerRadius.enter = NumberConstant(10);
    s.outerRadius.enter = NumberConstant(20);
    s.startAngle.enter = AngleConstant(Angle(deg: 0));
    s.endAngle.enter = AngleConstant(Angle(deg: 45));
    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testCircle(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Annular Section
    final s = AnnularSection2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = NumberConstant.array(<num>[55]);
    s.innerRadius.enter = NumberConstant(25);
    s.outerRadius.enter = NumberConstant(50);
    s.startAngle.enter = AngleConstant(Angle(deg: 0));
    s.endAngle.enter = AngleConstant(Angle(deg: 360));
    s.lineWidth.enter = NumberConstant(2);
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.grayCCC));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.green));
    s.fill.enter = BooleanConstant.array(<bool>[true, true, false]);
    s.stroke.enter = BooleanConstant.array(<bool>[true, false, true]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    canvas.addDataset('anchordata', map: anchorDatamap);

    final s = AnnularSection2d();
    canvas.attach(s);

    final xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.innerRadius.enter = NumberConstant(10);
    s.outerRadius.enter = NumberConstant(20);
    //s.startAngle.enter = AngleConstant(Angle(deg: 0));
    s.startAngle.update = AngleData('anchordata', canvas, prop: 'startAngle');
    //s.startAngle.enter = AngleConstant(Angle(deg: anchorStartAngle));
    s.endAngle.update = AngleData('anchordata', canvas, prop: 'endAngle');
    //s.endAngle.enter = AngleConstant(Angle(deg: 270));
    s.lineWidth.enter = NumberConstant(1);
    s.rotation.enter = AngleConstant(Angle(deg: 0));
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
    s.stroke.enter = BooleanConstant(false);
    s.anchor.enter = Anchor2dConstant.array(<Anchor2d>[
      Anchor2d(mode: AnchorMode2d.defaultMode),
      Anchor2d(mode: AnchorMode2d.center),
      Anchor2d(mode: AnchorMode2d.bottom),
      Anchor2d(mode: AnchorMode2d.bottomLeft),
      Anchor2d(mode: AnchorMode2d.bottomRight),
      Anchor2d(mode: AnchorMode2d.left),
      Anchor2d(mode: AnchorMode2d.right),
      Anchor2d(mode: AnchorMode2d.top),
      Anchor2d(mode: AnchorMode2d.topLeft),
      Anchor2d(mode: AnchorMode2d.topRight)
    ]);

    // Circles to mark the anchors
    final c = Circle2d();
    canvas.attach(c);
    c.x.enter = NumberConstant.array(xList);
    c.y.enter = NumberConstant(100);
    c.radius.enter = NumberConstant(2.5);
    c.opacity.enter = NumberConstant(0.7);
    c.lineWidth.enter = NumberConstant(1);
    c.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
    c.stroke.enter = BooleanConstant(false);
    c.anchor.enter = Anchor2dConstant(Anchor2d(mode: AnchorMode2d.center));

    esg.updateGraph();
  }

  void testLifecycle(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 500);
    esg.attachToRoot(canvas);
    final s = AnnularSection2d();
    canvas.attach(s);

    enterButton.onClick.listen((_) {
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.innerRadius.enter = NumberConstant(10);
      s.outerRadius.enter = NumberConstant(20);
      s.startAngle.enter = AngleConstant(Angle(deg: 0));
      s.endAngle.enter = AngleConstant(Angle(deg: 45));
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.gray999));
      s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.green));
      s.stroke.enter = BooleanConstant(true);

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

    // ignore: cascade_invocations
    updateButton.onClick.listen((_) {
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.innerRadius.enter = NumberConstant(10);
      s.outerRadius.enter = NumberConstant(20);
      s.startAngle.enter = AngleConstant(Angle(deg: 0));
      s.endAngle.enter = AngleConstant(Angle(deg: 45));
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.green));
      s.stroke.enter = BooleanConstant(true);

      s.x.update = NumberConstant(200);
      s.y.update = NumberConstant(100);
      s.innerRadius.update = NumberConstant(30);
      s.outerRadius.update = NumberConstant(50);
      s.startAngle.update = AngleConstant(Angle(deg: 30));
      s.endAngle.update = AngleConstant(Angle(deg: 360));
      s.lineWidth.update = NumberConstant(3);
      s.rotation.update = AngleConstant(Angle(deg: 720));
      s.fillStyle.update = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
      s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.cyan));
      s.stroke.enter = BooleanConstant(true);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.x.exit = NumberConstant(400);
      s.y.exit = NumberConstant(10);
      s.innerRadius.exit = NumberConstant(2);
      s.outerRadius.exit = NumberConstant(4);
      s.startAngle.exit = AngleConstant(Angle(deg: 0));
      s.endAngle.exit = AngleConstant(Angle(deg: 45));
      s.lineWidth.exit = NumberConstant(3);
      s.rotation.exit = AngleConstant(Angle(deg: 0));
      s.fillStyle.exit = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
      s.stroke.exit = BooleanConstant(false);
      s.opacity.exit = NumberConstant(0.01);

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
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    // Annular Section
    final s = AnnularSection2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[150, 300, 450, 600, 650]);
    s.y.enter = NumberConstant(150);
    s.innerRadius.enter = NumberConstant(30);
    s.outerRadius.enter = NumberConstant(120);
    s.startAngle.enter = AngleConstant(Angle(deg: 0));
    s.endAngle.enter = AngleConstant.array(<Angle>[Angle(deg: 90), Angle(deg: 180), Angle(deg: 360)]);
    s.lineWidth.update = NumberConstant(5);
    s.fillStyle.update = DrawingStyle2dConstant.array(<DrawingStyle2d>[
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.black),
      DrawingStyle2d(color: Color.red)
    ]);

    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
    s.onClick.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml = 'CLICKED $g2di');
    s.onDoubleClick
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml = 'DOUBLE-CLICKED $g2di');
    s.onMouseEnter.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml = 'ENTER $g2di');
    s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml = 'OUT $g2di');
    s.onMouseOver.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-over').innerHtml = 'OVER $g2di');
    s.onMouseDown
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-downup').innerHtml = 'DOWN $g2di');
    s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-downup').innerHtml = 'UP $g2di');

    esg.updateGraph();
  }

  void testFill(EnvyScene e) {
    //EnvyScene e = querySelector('#fill') as EnvyScene;
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final image = ImageElement(width: 30, height: 30, src: 'packages/envy/resources/morgan_silver_dollar.png');
    // Annular Section
    final s = AnnularSection2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 200, 350, 460, 650]);
    s.y.enter = NumberConstant.array(<num>[50, 50, 50, 10, 50]);
    s.innerRadius.enter = NumberConstant(0);
    s.outerRadius.enter = NumberConstant(40);
    s.startAngle.enter = AngleConstant(Angle(deg: 0));
    s.endAngle.enter = AngleConstant(Angle(deg: 270));
    s.fill.enter = BooleanConstant.trueValue;
    s.anchor.enter = Anchor2dConstant.array(
        <Anchor2d>[Anchor2d(), Anchor2d(), Anchor2d(), Anchor2d(mode: AnchorMode2d.topLeft), Anchor2d()]);
    s.fillStyle.enter = DrawingStyle2dConstant.array(<DrawingStyle2d>[
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(
          gradient: LinearGradient2d(x0: -20, x1: 40, y0: -20, y1: 40)
            ..addColorStop(0, Color.gray777)
            ..addColorStop(0.5, Color.blue)
            ..addColorStop(1, Color.cyan)),
      DrawingStyle2d(
          gradient: RadialGradient2d(x0: 0, y0: 0, r0: 5, x1: 0, y1: 0, r1: 35)
            ..addColorStop(0, Color.green)
            ..addColorStop(0.3, Color.blue)
            ..addColorStop(0.7, Color.red)
            ..addColorStop(1, Color.black)),
      DrawingStyle2d(
          pattern: ImagePattern2d(image,
              patternWidth: 80,
              patternHeight: 80,
              //patternOffsetX: -40,
              //patternOffsetY: -40,
              repeat: PatternRepeat.noRepeat)),
      DrawingStyle2d(color: Color.transparentBlack)
    ]);

    esg.updateGraph();
  }

  void randomizeAnchorAngles() {
    final r = Random();
    final start = r.nextDouble() * 360.0;
    final end = start + r.nextDouble() * (360.0 - start);

    anchorDatamap['startAngle'] = Angle(deg: start);
    anchorDatamap['endAngle'] = Angle(deg: end);
    anchorsScene.sceneGraph.updateGraph();
  }
}
