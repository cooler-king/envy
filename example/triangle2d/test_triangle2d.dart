import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-triangle2d',
  templateUrl: 'test_triangle2d.html',
  directives: <Object>[
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
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Triangle
    final s = Triangle2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = NumberConstant.array(<num>[55]);
    s.base.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
    s.lineWidth.enter = NumberConstant(5);
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

    // Triangle
    final s = Triangle2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 100, 150, 200, 250]);
    s.y.enter = NumberConstant(50);
    s.base.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final s = Triangle2d();
    canvas.attach(s);

    final xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.base.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
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
    final s = Triangle2d();
    canvas.attach(s);

    enterButton.onClick.listen((_) {
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.base.enter = NumberConstant(40);
      s.height.enter = NumberConstant(40);
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.opacity.enter = NumberConstant(1);

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
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.base.enter = NumberConstant(40);
      s.height.enter = NumberConstant(40);
      s.lineWidth.enter = NumberConstant(1);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
      s.opacity.enter = NumberConstant(1);

      s.x.update = NumberConstant(200);
      s.y.update = NumberConstant(100);
      s.base.update = NumberConstant(20);
      s.height.update = NumberConstant(60);
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
      s.base.exit = NumberConstant(1);
      s.height.exit = NumberConstant(1);
      s.lineWidth.exit = NumberConstant(3);
      s.rotation.exit = AngleConstant(Angle(deg: 0));
      s.fillStyle.exit = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
      s.stroke.exit = BooleanConstant(false);
      s.opacity.exit = NumberConstant(0);

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
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    final s = Triangle2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 375]);
    s.y.enter = NumberConstant(50);
    s.base.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
    s.lineWidth.enter = NumberConstant(5);
    s.lineDash.update = NumberListConstant(NumberList(<num>[3, 3]));
    s.strokeStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.gray));
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

    s.rotation.enter =
        AngleConstant.array(<Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
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
