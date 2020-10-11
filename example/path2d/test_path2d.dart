import 'dart:html';
import 'dart:math';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-path2d',
  templateUrl: 'test_path2d.html',
  directives: <Object>[
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

  PointList pointData = PointList(<Point<num>>[
    const Point<num>(1, 5),
    const Point<num>(20, 20),
    const Point<num>(40, 10),
    const Point<num>(60, 40),
    const Point<num>(80, 5),
    const Point<num>(100, 60),
  ]);

  void testBasic(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Path
    final s = Path2d();
    canvas
      ..addDataset('points', list: pointData)
      ..attach(s);

    s.points.enter = PointListData('points', canvas);
    s.x.enter = NumberConstant.array(<num>[50, 250, 450]);
    s.y.enter = NumberConstant(10);
    s.lineWidth.enter = NumberConstant(5);
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
    s.fill.enter = BooleanConstant.array(<bool>[true, true, false]);
    s.stroke.enter = BooleanConstant.array(<bool>[true, false, true]);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100)..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    // Path
    final s = Path2d();
    canvas.attach(s);

    s.points.enter = PointListData('points', canvas);
    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = NumberConstant(50);
    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 200)..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    final s = Path2d();
    canvas.attach(s);

    final xList = <num>[50, 250, 450, 650, 850, 1050, 1250, 1450, 1650, 1850];

    s.points.enter = PointListData('points', canvas);
    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.lineWidth.enter = NumberConstant(1);
    s.rotation.enter = AngleConstant(Angle(deg: 0));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
    s.stroke.enter = BooleanConstant(true);
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
    c.radius.enter = NumberConstant(2);
    c.lineWidth.enter = NumberConstant(1);
    c.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
    c.stroke.enter = BooleanConstant(false);

    esg.updateGraph();
  }

  void testLifecycle(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode()..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);
    final s = Path2d();
    canvas.attach(s);

    enterButton.onClick.listen((_) {
      s.points.enter = PointListData('points', canvas);
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.opacity.enter = NumberConstant(1);

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
      s.points.enter = PointListData('points', canvas);
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.opacity.enter = NumberConstant(1);

      s.points.update = PointListData('points', canvas);
      s.x.update = NumberConstant(200);
      s.y.update = NumberConstant(100);
      s.lineWidth.update = NumberConstant(3);
      s.rotation.update = AngleConstant(Angle(deg: 720));
      s.strokeStyle.update = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
      s.opacity.update = NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.points.exit = PointListData('points', canvas);
      s.x.exit = NumberConstant(400);
      s.y.exit = NumberConstant(10);
      s.lineWidth.exit = NumberConstant(3);
      s.rotation.exit = AngleConstant(Angle(deg: 0));
      s.strokeStyle.exit = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
      s.stroke.exit = BooleanConstant(false);
      s.opacity.exit = NumberConstant(0);

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
    final esg = e.sceneGraph;
    final canvas = CanvasNode()..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    final s = Path2d();
    s.points.enter = PointListData('points', canvas);
    s.x.enter = NumberConstant(50);
    s.y.enter = NumberConstant(50);
    s.lineWidth.enter = NumberConstant(2);
    s.rotation.enter = AngleConstant(Angle(deg: 0));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
    s.opacity.enter = NumberConstant(1);

    canvas.attach(s);
    esg.updateGraph();

    dataButton.onClick.listen((_) {
      final rand = Random();
      /*
      final newPointData = PointList(<Point<num>>[
        Point<num>(1, rand.nextDouble() * 300),
        Point<num>(20, rand.nextDouble() * 300),
        Point<num>(40, rand.nextDouble() * 300),
        Point<num>(60, rand.nextDouble() * 300),
        Point<num>(80, rand.nextDouble() * 300),
        Point<num>(100 + rand.nextDouble() * 100, rand.nextDouble() * 300)
      ]);*/

      final count = 2 + rand.nextInt(10);
      final points = <Point<num>>[];
      for (var i = 0; i < count; i++) {
        points.add(Point<num>(1 + 20 * i, rand.nextDouble() * 300));
      }

      canvas.addDataset('points', list: PointList(points));
      esg.updateGraph();
    });
  }

  void testInterpolation(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Path
    final s = Path2d();
    canvas
      ..addDataset('points', list: pointData)
      ..attach(s);

    s.points.enter = PointListData('points', canvas);
    s.interpolation.enter = PathInterpolation2dConstant.array(<PathInterpolation2d>[
      PathInterpolation2d.linear,
      PathInterpolation2d.linearClosed,
      PathInterpolation2d.stepBefore,
      PathInterpolation2d.stepAfter,
      PathInterpolation2d.diagonal
    ]);
    s.x.enter = NumberConstant.array(<num>[50, 250, 450, 650, 850]);
    s.y.enter = NumberConstant(10);
    s.lineWidth.enter = NumberConstant(3);
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.magenta));
    s.stroke.enter = BooleanConstant.trueValue;
    s.fill.enter = BooleanConstant.trueValue;

    esg.updateGraph();
  }

  void testHit(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 500)..addDataset('points', list: pointData);
    esg.attachToRoot(canvas);

    final s = Path2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 200, 350, 500, 550]);
    s.y.enter = NumberConstant(50);
    s.points.enter = PointListData('points', canvas);
    s.lineWidth.enter = NumberConstant(5);
    s.stroke.enter = BooleanConstant.trueValue;
    s.strokeStyle.enter = DrawingStyle2dConstant.array(<DrawingStyle2d>[
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
}
