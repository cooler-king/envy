import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-text2d',
  templateUrl: 'test_text2d.html',
  directives: const <Object>[
    EnvyScene,
  ],
)
class TestText2d implements AfterViewInit {
  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('fontVariation')
  EnvyScene fontVariationScene;

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
    testFontVariations(fontVariationScene);
    testRotation(rotationScene);
    testAnchors(anchorsScene);
    testLifecycle(lifecycleScene);
    testHit(hitScene);
  }

  void testBasic(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Text
    final Text2d s = Text2d();
    canvas.attach(s);

    s.text.enter = StringConstant.array(<String>['abc', 'def', 'xyz']);
    s.x.enter = NumberConstant.array(<num>[75, 225, 375]);
    s.y.enter = NumberConstant.array(<num>[55]);
    s.font.enter = FontConstant(Font(
        family: FontFamily.sansSerif, size: FontSize.cssLength(CssLength.pt(16)), weight: FontWeight.bold));
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
    s.fill.enter = BooleanConstant.array(<bool>[true, true, false]);
    s.stroke.enter = BooleanConstant.array(<bool>[true, false, true]);

    esg.updateGraph();
  }

  void testFontVariations(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Text
    final Text2d s = Text2d();
    canvas.attach(s);

    s.text.enter = StringConstant('Abcd');
    s.x.enter = NumberConstant.array(<int>[75, 225, 375, 525, 675, 825, 975]);
    s.y.enter = NumberConstant.array(<int>[55]);
    s.font.enter = FontConstant.array(<Font>[
      Font(
          family: FontFamily.sansSerif, size: FontSize.px(20), weight: FontWeight.bold, style: FontStyle.normal),
      Font(family: FontFamily.serif, size: FontSize.px(12), weight: FontWeight.normal, style: FontStyle.italic),
      Font(
          family: FontFamily.monospace, size: FontSize.px(14), weight: FontWeight.normal, style: FontStyle.normal),
      Font(
          family: FontFamily.cursive, size: FontSize.px(14), weight: FontWeight.bolder, style: FontStyle.normal),
      Font(
          family: FontFamily.custom('Ubuntu Mono'),
          size: FontSize.px(28),
          weight: FontWeight.bold,
          style: FontStyle.normal),
      Font(
          family: FontFamily.fantasy, size: FontSize.px(16), weight: FontWeight.normal, style: FontStyle.oblique),
      Font(size: FontSize.px(30), weight: FontWeight.bold, style: FontStyle.oblique)
    ]);
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Text
    final Text2d s = Text2d();
    canvas.attach(s);

    s.text.enter = StringConstant('12345');
    s.x.enter = NumberConstant.array(<num>[50, 100, 150, 200, 250]);
    s.y.enter = NumberConstant(50);
    s.rotation.enter = AngleConstant.array(
        <Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final Text2d s = Text2d();
    canvas.attach(s);

    final List<num> xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.text.enter = StringConstant('yXy');
    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.font.enter = FontConstant(Font(
        family: FontFamily.sansSerif, size: FontSize.cssLength(CssLength.pt(14)), weight: FontWeight.bold));
    s.lineWidth.enter = NumberConstant(1);
    s.rotation.enter = AngleConstant(Angle(deg: 0));
    s.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.black));
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
    final Circle2d c = Circle2d();
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
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode();
    esg.attachToRoot(canvas);
    final Text2d t = Text2d();
    canvas.attach(t);

    enterButton.onClick.listen((_) {
      t.text.enter = StringConstant('qwerty');
      t.x.enter = NumberConstant.array(<num>[75]);
      t.y.enter = NumberConstant.array(<num>[55]);
      t.font.enter = FontConstant(Font(
          family: FontFamily.sansSerif, size: FontSize.cssLength(CssLength.pt(16)), weight: FontWeight.bold));
      t.rotation.enter = AngleConstant(Angle(deg: 0));
      t.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
      t.opacity.enter = NumberConstant(0.3);

      t.text.update = null;
      t.x.update = null;
      t.y.update = null;
      t.font.update = null;
      t.rotation.update = null;
      t.fillStyle.update = null;
      t.opacity.update = null;

      esg.updateGraph();
    });

    // ignore: cascade_invocations
    updateButton.onClick.listen((_) {
      t.text.enter = StringConstant('qwerty');
      t.x.enter = NumberConstant(50);
      t.y.enter = NumberConstant(50);
      t.font.enter = FontConstant(Font(
          family: FontFamily.sansSerif, size: FontSize.cssLength(CssLength.pt(12)), weight: FontWeight.normal));
      t.rotation.enter = AngleConstant(Angle(deg: 0));
      t.fillStyle.enter = DrawingStyle2dConstant(DrawingStyle2d(color: Color.blue));
      t.opacity.enter = NumberConstant(1);

      t.text.update = StringConstant('qwerty2');
      t.x.update = NumberConstant(200);
      t.y.update = NumberConstant(100);
      t.font.update = FontConstant(Font(
          family: FontFamily.cursive, size: FontSize.cssLength(CssLength.pt(20)), weight: FontWeight.bold));
      t.rotation.update = AngleConstant(Angle(deg: 720));
      t.fillStyle.update = DrawingStyle2dConstant(DrawingStyle2d(color: Color.red));
      t.opacity.update = NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      t.text.exit = StringConstant('qwertybye');
      t.x.exit = NumberConstant(400);
      t.y.exit = NumberConstant(10);
      t.rotation.exit = AngleConstant(Angle(deg: 0));
      t.fillStyle.exit = DrawingStyle2dConstant(DrawingStyle2d(color: Color.gray555));
      t.opacity.exit = NumberConstant(0);

      t.text.enter = null;
      t.x.enter = null;
      t.y.enter = null;
      t.rotation.enter = null;
      t.font.enter = null;
      t.fillStyle.enter = null;
      t.opacity.enter = null;

      t.text.update = null;
      t.x.update = null;
      t.y.update = null;
      t.rotation.update = null;
      t.font.update = null;
      t.fillStyle.update = null;
      t.opacity.update = null;

      esg.updateGraph();
    });
  }

  void testHit(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    final Text2d s = Text2d();
    canvas.attach(s);

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 360]);
    s.y.enter = NumberConstant(50);
    s.text.enter = StringConstant.array(<String>['abc', 'def', 'xyz', 'pdq', 'omg']);
    s.font.enter = FontConstant(Font(
        family: FontFamily.sansSerif, size: FontSize.cssLength(CssLength.pt(16)), weight: FontWeight.bold));
    s.rotation.enter = AngleConstant.array(
        <Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
    s.fill.enter = BooleanConstant.trueValue;
    s.fillStyle.enter = DrawingStyle2dConstant.array(<DrawingStyle2d>[
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.blue),
      DrawingStyle2d(color: Color.black),
      DrawingStyle2d(color: Color.red)
    ]);

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
