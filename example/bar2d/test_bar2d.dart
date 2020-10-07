import 'dart:html';
import 'dart:math';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-bar2d',
  templateUrl: 'test_bar2d.html',
  directives: <Object>[
    EnvyScene,
  ],
)
class TestBar2d implements AfterViewInit {
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
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Bar
    final s = Bar2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = NumberConstant.array(<num>[55]);
    s.width.enter = NumberConstant(10);
    s.height.enter = NumberConstant(30);
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

    // Bar
    final s = Bar2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = NumberConstant(50);
    s.width.enter = NumberConstant(40);
    s.height.enter = NumberConstant(20);
    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final s = Bar2d();
    canvas.attach(s);

    final xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.width.enter = NumberConstant(30);
    s.height.enter = NumberConstant(10);
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
    c.radius.enter = NumberConstant(2);
    c.lineWidth.enter = NumberConstant(1);
    c.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
    c.stroke.enter = BooleanConstant(false);

    esg.updateGraph();
  }

  void testLifecycle(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode();
    esg.attachToRoot(canvas);
    final s = Bar2d();
    canvas.attach(s);

    enterButton.onClick.listen((_) {
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.width.enter = NumberConstant(50);
      s.height.enter = NumberConstant(30);
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.opacity.enter = NumberConstant(1);

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
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.width.enter = NumberConstant(50);
      s.height.enter = NumberConstant(30);
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.opacity.enter = NumberConstant(1);

      s.x.update = NumberConstant(200);
      s.y.update = NumberConstant(100);
      s.width.update = NumberConstant(100);
      s.height.update = NumberConstant(10);
      s.lineWidth.update = NumberConstant(3);
      s.rotation.update = AngleConstant(Angle(deg: 720));
      s.fillStyle.update = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
      s.opacity.update = NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.x.exit = NumberConstant(400);
      s.y.exit = NumberConstant(10);
      s.width.exit = NumberConstant(2);
      s.height.exit = NumberConstant(2);
      s.lineWidth.exit = NumberConstant(3);
      s.rotation.exit = AngleConstant(Angle(deg: 0));
      s.fillStyle.exit = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
      s.stroke.exit = BooleanConstant(false);
      s.opacity.exit = NumberConstant(0);

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
    final esg = e.sceneGraph;
    final canvas = CanvasNode();
    esg.attachToRoot(canvas);
    final datamap = <String, int>{'xcoord': 100, 'ycoord': 50, 'width': 50, 'height': 20, 'opacity': 1};
    canvas.addDataset('bardata', map: datamap);

    final s = Bar2d();

    canvas.attach(s);
    esg.updateGraph();

    s.x.enter = NumberData('bardata', canvas, prop: 'xcoord');
    s.y.enter = NumberData('bardata', canvas, prop: 'ycoord');
    s.width.enter = NumberData('bardata', canvas, prop: 'width');
    s.height.enter = NumberData('bardata', canvas, prop: 'height');
    s.opacity.enter = NumberData('bardata', canvas, prop: 'opacity');
    s.rotation.enter = AngleData('bardata', canvas, prop: 'rot');

    dataButton.onClick.listen((_) {
      final rand = Random();
      final randomData = <String, dynamic>{
        'xcoord': 150 + rand.nextDouble() * 75,
        'ycoord': 75 + rand.nextDouble() * 50,
        'width': 50 + rand.nextDouble() * 200,
        'height': 20 + rand.nextDouble() * 50,
        'opacity': rand.nextDouble(),
        'rot': Angle(deg: rand.nextDouble() * 360)
      };
      canvas.addDataset('bardata', map: randomData);
      esg.updateGraph();
    });
  }

  void testHit(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    canvas.onClick.listen((MouseEvent e) => querySelector('#hit-feedback').innerHtml = 'CLICKED BACKGROUND $e');

    final s = Bar2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 375]);
    s.y.enter = NumberConstant(50);
    s.width.enter = NumberConstant(40);
    s.height.enter = NumberConstant(20);
    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
    s.fill.enter = BooleanConstant.trueValue;
    s.fillStyle.enter = DrawingStyle2dConstant.array(<DrawingStyle2d>[
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.black),
      DrawingStyle2d(color: Color.red)
    ]);
    s.data.enter = NumberConstant.array(<num>[10, 20, 30, 40, 50]);

    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
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
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Bar
    final s = Bar2d();
    canvas.attach(s);

    final image = ImageElement(width: 30, height: 30, src: 'packages/envy/resources/morgan_silver_dollar.png');

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = NumberConstant(50);
    s.width.enter = NumberConstant(60);
    s.height.enter = NumberConstant(40);
    s.fill.enter = BooleanConstant.trueValue;
    s.fillStyle.enter = DrawingStyle2dConstant.array(<DrawingStyle2d>[
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(
          gradient: LinearGradient2d(x0: 5, x1: 50, y0: 0, y1: 40)
            ..addColorStop(0, Color.gray777)
            ..addColorStop(0.5, Color.blue)
            ..addColorStop(1, Color.cyan)),
      DrawingStyle2d(
          gradient: RadialGradient2d(x0: 30, y0: 20, r0: 5, x1: 30, y1: 20, r1: 35)
            ..addColorStop(0, Color.green)
            ..addColorStop(0.3, Color.blue)
            ..addColorStop(0.7, Color.red)
            ..addColorStop(1, Color.black)),
      DrawingStyle2d(pattern: ImagePattern2d(image, patternWidth: 30, patternHeight: 20)),
      DrawingStyle2d(color: Color.transparentBlack)
    ]);

    esg.updateGraph();
  }
}
