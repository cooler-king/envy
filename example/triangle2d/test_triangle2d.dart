import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-triangle2d',
  templateUrl: 'test_triangle2d.html',
  directives: const <Object>[
    EnvyScene,
  ],
)
class TestTriangle2d implements AfterViewInit {
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

  @ViewChild('enterButton', read: Element)
  Element enterButton;

  @ViewChild('updateButton', read: Element)
  Element updateButton;

  @ViewChild('exitButton', read: Element)
  Element exitButton;

  @override
  void ngAfterViewInit() {
    testBasic(basicScene);
    testRotation(rotationScene);
    testAnchors(anchorsScene);
    testLifecycle(lifecycleScene);
    testHit(hitScene);
  }

  void testBasic(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Triangle
    final Triangle2d s = new Triangle2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = new NumberConstant.array(<num>[55]);
    s.base.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
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

    // Triangle
    final Triangle2d s = new Triangle2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[50, 100, 150, 200, 250]);
    s.y.enter = new NumberConstant(50);
    s.base.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final Triangle2d s = new Triangle2d();
    canvas.attach(s);

    final List<num> xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = new NumberConstant.array(xList);
    s.y.enter = new NumberConstant(100);
    s.base.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
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
    final Triangle2d s = new Triangle2d();
    canvas.attach(s);

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

    // ignore: cascade_invocations
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
      s.fillStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.blue));
      s.opacity.update = new NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.x.exit = new NumberConstant(400);
      s.y.exit = new NumberConstant(10);
      s.base.exit = new NumberConstant(1);
      s.height.exit = new NumberConstant(1);
      s.lineWidth.exit = new NumberConstant(3);
      s.rotation.exit = new AngleConstant(new Angle(deg: 0));
      s.fillStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.red));
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

  void testHit(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    final Triangle2d s = new Triangle2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 375]);
    s.y.enter = new NumberConstant(50);
    s.base.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
    s.lineWidth.enter = new NumberConstant(5);
    s.lineDash.update = new NumberListConstant(new NumberList(<num>[3, 3]));
    s.strokeStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.gray));
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

    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
    s.onClick.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml = 'CLICKED $g2di');
    s.onDoubleClick
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback').innerHtml = 'DOUBLE-CLICKED $g2di');
    s.onMouseEnter
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-enter').innerHtml = 'ENTER $g2di');
    s.onMouseLeave
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-leave').innerHtml = 'LEAVE $g2di');
    s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-out').innerHtml = 'OUT $g2di');
    s.onMouseOver.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-over').innerHtml = 'OVER $g2di');
    s.onMouseDown
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-downup').innerHtml = 'DOWN $g2di');
    s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-downup').innerHtml = 'UP $g2di');
    s.onMouseMove.listen((Graphic2dIntersection g2di) => querySelector('#hit-feedback-move').innerHtml = 'MOVE $g2di');

    esg.updateGraph();
  }
}
