import 'dart:html';
import 'dart:math';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-path2d',
  templateUrl: 'test_path2d.html',
  directives: const <Object>[
    EnvyScene,
  ],
)
class TestPath2d implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('rotation')
  EnvyScene rotationScene;
  @ViewChild('anchors')
  EnvyScene anchorsScene;

  @ViewChild('lifecycle')
  EnvyScene lifecycleScene;

  @ViewChild('data')
  EnvyScene dataScene;

  @ViewChild('interpolation')
  EnvyScene interpolationScene;

  @ViewChild('hit')
  EnvyScene hitScene;

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
    testInterpolation(interpolationScene);
    testHit(hitScene);
  }

  PointList pointData = new PointList(<Point<num>>[
    const Point<num>(1, 5),
    const Point<num>(20, 20),
    const Point<num>(40, 10),
    const Point<num>(60, 40),
    const Point<num>(80, 5),
    const Point<num>(100, 60),
  ]);

  void testBasic(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Path
    final Path2d s = new Path2d();
    canvas
      ..addDataset('points', list: pointData)
      ..attach(s);

    s.points.enter = new PointListData('points', canvas);
    s.x.enter = new NumberConstant.array(<num>[50, 250, 450]);
    s.y.enter = new NumberConstant(10);
    s.lineWidth.enter = new NumberConstant(5);
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.blue));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
    s.fill.enter = new BooleanConstant.array(<bool>[true, true, false]);
    s.stroke.enter = new BooleanConstant.array(<bool>[true, false, true]);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100)..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    // Path
    final Path2d s = new Path2d();
    canvas.attach(s);

    s.points.enter = new PointListData('points', canvas);
    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = new NumberConstant(50);
    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 200)..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    final Path2d s = new Path2d();
    canvas.attach(s);

    final List<num> xList = <num>[50, 250, 450, 650, 850, 1050, 1250, 1450, 1650, 1850];

    s.points.enter = new PointListData('points', canvas);
    s.x.enter = new NumberConstant.array(xList);
    s.y.enter = new NumberConstant(100);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
    s.stroke.enter = new BooleanConstant(true);
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
    final CanvasNode canvas = new CanvasNode()..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);
    final Path2d s = new Path2d();
    canvas.attach(s);

    enterButton.onClick.listen((_) {
      s.points.enter = new PointListData('points', canvas);
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

    // ignore: cascade_invocations
    updateButton.onClick.listen((_) {
      s.points.enter = new PointListData('points', canvas);
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.lineWidth.enter = new NumberConstant(1);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
      s.opacity.enter = new NumberConstant(1);

      s.points.update = new PointListData('points', canvas);
      s.x.update = new NumberConstant(200);
      s.y.update = new NumberConstant(100);
      s.lineWidth.update = new NumberConstant(3);
      s.rotation.update = new AngleConstant(new Angle(deg: 720));
      s.strokeStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.blue));
      s.opacity.update = new NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.points.exit = new PointListData('points', canvas);
      s.x.exit = new NumberConstant(400);
      s.y.exit = new NumberConstant(10);
      s.lineWidth.exit = new NumberConstant(3);
      s.rotation.exit = new AngleConstant(new Angle(deg: 0));
      s.strokeStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
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

  void testDataDriven(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode()..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    final Path2d s = new Path2d();
    s.points.enter = new PointListData('points', canvas);
    s.x.enter = new NumberConstant(50);
    s.y.enter = new NumberConstant(50);
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.cyan));
    s.opacity.enter = new NumberConstant(1);

    canvas.attach(s);
    esg.updateGraph();

    dataButton.onClick.listen((_) {
      final Random rand = new Random();
      final PointList newPointData = new PointList(<Point<num>>[
        new Point<num>(1, rand.nextDouble() * 300),
        new Point<num>(20, rand.nextDouble() * 300),
        new Point<num>(40, rand.nextDouble() * 300),
        new Point<num>(60, rand.nextDouble() * 300),
        new Point<num>(80, rand.nextDouble() * 300),
        new Point<num>(100 + rand.nextDouble() * 100, rand.nextDouble() * 300)
      ]);

      canvas.addDataset('points', list: newPointData);
      esg.updateGraph();
    });
  }

  void testInterpolation(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Path
    final Path2d s = new Path2d();
    canvas
      ..addDataset('points', list: pointData)
      ..attach(s);

    s.points.enter = new PointListData('points', canvas);
    s.interpolation.enter = new PathInterpolation2dConstant.array(<PathInterpolation2d>[
      PathInterpolation2d.linear,
      PathInterpolation2d.linearClosed,
      PathInterpolation2d.stepBefore,
      PathInterpolation2d.stepAfter,
      PathInterpolation2d.diagonal
    ]);
    s.x.enter = new NumberConstant.array(<num>[50, 250, 450, 650, 850]);
    s.y.enter = new NumberConstant(10);
    s.lineWidth.enter = new NumberConstant(3);
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.magenta));
    s.stroke.enter = BooleanConstant.TRUE;
    s.fill.enter = BooleanConstant.TRUE;

    esg.updateGraph();
  }

  void testHit(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 500)..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    final Path2d s = new Path2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[50, 200, 350, 500, 550]);
    s.y.enter = new NumberConstant(50);
    s.points.enter = new PointListData('points', canvas);
    s.lineWidth.enter = new NumberConstant(5);
    s.stroke.enter = BooleanConstant.TRUE;
    s.strokeStyle.enter = new DrawingStyle2dConstant.array(<DrawingStyle2d>[
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(color: Color.blue),
      new DrawingStyle2d(color: Color.black),
      new DrawingStyle2d(color: Color.red)
    ]);

    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
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
}
