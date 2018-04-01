import 'dart:html';
import 'dart:math';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-rect2d',
  templateUrl: 'test_rect2d.html',
  directives: const <Object>[
    EnvyScene,
  ],
)
class TestRect2d implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('rotation')
  EnvyScene rotationScene;

  @ViewChild('anchors')
  EnvyScene anchorsScene;

  @ViewChild('lifecycle')
  EnvyScene lifecycleScene;

  @ViewChild('hit')
  EnvyScene hitScene;

  @ViewChild('data')
  EnvyScene dataScene;

  @ViewChild('fill')
  EnvyScene fillScene;

  @ViewChild('enterButton', read: Element)
  Element enterButton;

  @ViewChild('updateButton', read: Element)
  Element updateButton;

  @ViewChild('exitButton', read: Element)
  Element exitButton;

  @ViewChild('dataButton', read: Element)
  Element dataButton;

  @override
  void ngAfterViewInit() {
    testBasic(basicScene);
    testRotation(rotationScene);
    testAnchors(anchorsScene);
    testLifecycle(lifecycleScene);
    testDataDriven(dataScene);
    testHit(hitScene);
    testFill(fillScene);
  }

  void testBasic(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Rect
    final Rect2d s = new Rect2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = new NumberConstant.array(<num>[55]);
    s.width.enter = new NumberConstant(50);
    s.height.enter = new NumberConstant(30);
    s.lineWidth.enter = new NumberConstant(5);
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.blue));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
    s.fill.enter = new BooleanConstant.array(<bool>[true, true, false]);
    s.stroke.enter = new BooleanConstant.array(<bool>[true, false, true]);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Rect
    final Rect2d s = new Rect2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = new NumberConstant(50);
    s.width.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(20);
    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final Rect2d s = new Rect2d();
    canvas.attach(s);

    final List<num> xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = new NumberConstant.array(xList);
    s.y.enter = new NumberConstant(100);
    s.width.enter = new NumberConstant(30);
    s.height.enter = new NumberConstant(10);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
    s.stroke.enter = new BooleanConstant(false);
    s.anchor.enter = new Anchor2dConstant.array(<Anchor2d>[
      new Anchor2d(mode: AnchorMode2d.defaultMode),
      new Anchor2d(mode: AnchorMode2d.center),
      new Anchor2d(mode: AnchorMode2d.bottom),
      new Anchor2d(mode: AnchorMode2d.bottomLeft),
      new Anchor2d(mode: AnchorMode2d.bottomRight),
      new Anchor2d(mode: AnchorMode2d.left),
      new Anchor2d(mode: AnchorMode2d.right),
      new Anchor2d(mode: AnchorMode2d.top),
      new Anchor2d(mode: AnchorMode2d.topLeft),
      new Anchor2d(mode: AnchorMode2d.topRight)
    ]);

    // Circles to mark the anchors
    final Circle2d c = new Circle2d();
    canvas.attach(c);
    c.x.enter = new NumberConstant.array(xList);
    c.y.enter = new NumberConstant(100);
    c.radius.enter = new NumberConstant(2);
    c.lineWidth.enter = new NumberConstant(1);
    c.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
    c.stroke.enter = new BooleanConstant(false);

    esg.updateGraph();
  }

  void testLifecycle(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode();
    esg.attachToRoot(canvas);
    final Rect2d s = new Rect2d();
    canvas.attach(s);

    enterButton.onClick.listen((_) {
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.width.enter = new NumberConstant(50);
      s.height.enter = new NumberConstant(30);
      s.lineWidth.enter = new NumberConstant(1);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
      s.opacity.enter = new NumberConstant(1);

      s.x.update = null;
      s.y.update = null;
      s.width.update = null;
      s.height.update = null;
      s.lineWidth.update = null;
      s.rotation.update = null;
      s.fillStyle.update = null;
      s.opacity.update = null;

      esg.updateGraph();
    });

    // ignore: cascade_invocations
    updateButton.onClick.listen((MouseEvent e) {
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.width.enter = new NumberConstant(50);
      s.height.enter = new NumberConstant(30);
      s.lineWidth.enter = new NumberConstant(1);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
      s.opacity.enter = new NumberConstant(1);

      s.x.update = new NumberConstant(200);
      s.y.update = new NumberConstant(100);
      s.width.update = new NumberConstant(100);
      s.height.update = new NumberConstant(10);
      s.lineWidth.update = new NumberConstant(3);
      s.rotation.update = new AngleConstant(new Angle(deg: 720));
      s.fillStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.blue));
      s.opacity.update = new NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.x.exit = new NumberConstant(400);
      s.y.exit = new NumberConstant(10);
      s.width.exit = new NumberConstant(2);
      s.height.exit = new NumberConstant(2);
      s.lineWidth.exit = new NumberConstant(3);
      s.rotation.exit = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
      s.stroke.exit = new BooleanConstant(false);
      s.opacity.exit = new NumberConstant(0);

      s.x.enter = null;
      s.y.enter = null;
      s.width.enter = null;
      s.height.enter = null;
      s.lineWidth.enter = null;
      s.rotation.enter = null;
      s.fillStyle.enter = null;
      s.opacity.enter = null;

      s.x.update = null;
      s.y.update = null;
      s.width.update = null;
      s.height.update = null;
      s.lineWidth.update = null;
      s.rotation.update = null;
      s.fillStyle.update = null;
      s.opacity.update = null;

      esg.updateGraph();
    });
  }

  void testDataDriven(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode();
    esg.attachToRoot(canvas);
    final Map<String, int> datamap = <String, int>{
      'xcoord': 100,
      'ycoord': 50,
      'width': 50,
      'height': 20,
      'opacity': 1
    };
    canvas.addDataset('rectdata', map: datamap);

    final Rect2d s = new Rect2d();

    canvas.attach(s);
    esg.updateGraph();

    s.x.enter = new NumberData('rectdata', canvas, prop: 'xcoord');
    s.y.enter = new NumberData('rectdata', canvas, prop: 'ycoord');
    s.width.enter = new NumberData('rectdata', canvas, prop: 'width');
    s.height.enter = new NumberData('rectdata', canvas, prop: 'height');
    s.opacity.enter = new NumberData('rectdata', canvas, prop: 'opacity');
    s.rotation.enter = new AngleData('rectdata', canvas, prop: 'rot');

    dataButton.onClick.listen((_) {
      final Random rand = new Random();
      final Map<String, dynamic> randomData = <String, dynamic>{
        'xcoord': 150 + rand.nextDouble() * 75,
        'ycoord': 75 + rand.nextDouble() * 50,
        'width': 50 + rand.nextDouble() * 200,
        'height': 20 + rand.nextDouble() * 50,
        'opacity': rand.nextDouble(),
        'rot': new Angle(deg: rand.nextDouble() * 360)
      };
      canvas.addDataset('rectdata', map: randomData);
      esg.updateGraph();
    });
  }

  void testHit(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    canvas.onClick.listen((MouseEvent e) => querySelector('#hit-feedback').innerHtml = 'CLICKED BACKGROUND $e');

    final Rect2d s = new Rect2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 375]);
    s.y.enter = new NumberConstant(50);
    s.width.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(20);
    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
    s.fill.enter = BooleanConstant.TRUE;
    s.fillStyle.enter = new DrawingStyle2dConstant.array(<DrawingStyle2d>[
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(color: Color.black),
      new DrawingStyle2d(color: Color.red)
    ]);
    s.data.enter = new NumberConstant.array(<num>[10, 20, 30, 40, 50]);

    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
    s.onClick.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml =
        'CLICKED $g2di... data = ${g2di.graphic2d.data.valueAt(g2di.index)}');
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
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Rect
    final Rect2d s = new Rect2d();
    canvas.attach(s);

    final ImageElement image =
        new ImageElement(width: 30, height: 30, src: 'packages/envy/resources/morgan_silver_dollar.png');

    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = new NumberConstant(50);
    s.width.enter = new NumberConstant(60);
    s.height.enter = new NumberConstant(40);
    s.fill.enter = BooleanConstant.TRUE;
    s.fillStyle.enter = new DrawingStyle2dConstant.array(<DrawingStyle2d>[
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(
          gradient: new LinearGradient2d(x0: 5, x1: 50, y0: 0, y1: 40)
            ..addColorStop(0, Color.gray777)
            ..addColorStop(0.5, Color.blue)
            ..addColorStop(1, Color.cyan)),
      new DrawingStyle2d(
          gradient: new RadialGradient2d(x0: 30, y0: 20, r0: 5, x1: 30, y1: 20, r1: 35)
            ..addColorStop(0, Color.green)
            ..addColorStop(0.3, Color.blue)
            ..addColorStop(0.7, Color.red)
            ..addColorStop(1, Color.black)),
      new DrawingStyle2d(pattern: new ImagePattern2d(image, patternWidth: 60, patternHeight: 60)),
      new DrawingStyle2d(color: Color.transparentBlack)
    ]);

    esg.updateGraph();
  }
}
