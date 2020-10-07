import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-circle2d',
  templateUrl: 'test_circle2d.html',
  directives: <Object>[
    EnvyScene,
  ],
)
class TestCircle2d implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('anchors')
  EnvyScene anchorsScene;

  @ViewChild('hit')
  EnvyScene hitScene;

  @override
  void ngAfterViewInit() {
    testBasic(basicScene);
    testAnchors(anchorsScene);
    testHit(hitScene);
  }

  void testBasic(EnvyScene e) {
    final esg = e.sceneGraph;

    final canvas = CanvasNode();
    esg.attachToRoot(canvas);

    // Circle
    final c = Circle2d();
    canvas.attach(c);

    c.x.enter = NumberConstant.array(<num>[300, 395]);
    c.y.enter = NumberConstant.array(<num>[200]);
    c.radius.enter = NumberConstant.array(<num>[100, 5]);
    c.lineWidth.enter = NumberConstant.array(<num>[5, 1]);
    c.fillStyle.enter = DrawingStyle2dConstant.array(
        <DrawingStyle2d>[DrawingStyle2d(color: Color.blue), DrawingStyle2d(color: Color.yellow)]);
    c.strokeStyle.enter = DrawingStyle2dConstant.array(
        <DrawingStyle2d>[DrawingStyle2d(color: Color.cyan), DrawingStyle2d(color: Color.black)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final s = Circle2d();
    canvas.attach(s);

    final xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.radius.enter = NumberConstant(30);
    s.lineWidth.enter = NumberConstant(1);
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

  void testHit(EnvyScene e) {
    final esg = e.sceneGraph;
    final canvas = CanvasNode(1000, 400);
    esg.attachToRoot(canvas);

    // Annular Section
    final s = Circle2d();
    canvas.attach(s);

    s.x.enter = NumberConstant(150);
    s.y.enter = NumberConstant(150);
    s.radius.enter = NumberConstant.array(<num>[120, 60, 30]);
    s.lineWidth.update = NumberConstant(5);
    s.fillStyle.update = DrawingStyle2dConstant.array(<DrawingStyle2d>[
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.green),
      DrawingStyle2d(color: Color.cyan),
    ]);

    s.onClick.listen((Graphic2dIntersection g2di) => querySelector('#hit-click').innerHtml = 'CLICKED $g2di');
    s.onDoubleClick
        .listen((Graphic2dIntersection g2di) => querySelector('#hit-click').innerHtml = 'DOUBLE-CLICKED $g2di');
    s.onMouseEnter.listen((Graphic2dIntersection g2di) => querySelector('#hit-enter').innerHtml = 'ENTER $g2di');
    s.onMouseLeave.listen((Graphic2dIntersection g2di) => querySelector('#hit-leave').innerHtml = 'LEAVE $g2di');
    s.onMouseOut.listen((Graphic2dIntersection g2di) => querySelector('#hit-out').innerHtml = 'OUT $g2di');
    s.onMouseOver.listen((Graphic2dIntersection g2di) => querySelector('#hit-over').innerHtml = 'OVER $g2di');
    s.onMouseDown.listen((Graphic2dIntersection g2di) => querySelector('#hit-down-up').innerHtml = 'DOWN $g2di');
    s.onMouseUp.listen((Graphic2dIntersection g2di) => querySelector('#hit-down-up').innerHtml = 'UP $g2di');

    esg.updateGraph();
  }
}
