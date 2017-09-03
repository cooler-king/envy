import 'dart:html';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: "test-text2d",
  templateUrl: 'test_text2d.html',
  directives: const [EnvyScene],
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

  void ngAfterViewInit() {
    testBasic(basicScene);
    testFontVariations(fontVariationScene);
    testRotation(rotationScene);
    testAnchors(anchorsScene);
    testLifecycle(lifecycleScene);
    testHit(hitScene);
  }

  void testBasic(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Text
    Text2d s = new Text2d();
    canvas.attach(s);

    s.text.enter = new StringConstant.array(["abc", "def", "xyz"]);
    s.x.enter = new NumberConstant.array([75, 225, 375]);
    s.y.enter = new NumberConstant.array([55]);
    s.font.enter = new FontConstant(new Font(
        family: FontFamily.sansSerif, size: new FontSize.cssLength(new CssLength.pt(16)), weight: FontWeight.bold));
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
    s.fill.enter = new BooleanConstant.array([true, true, false]);
    s.stroke.enter = new BooleanConstant.array([true, false, true]);

    esg.updateGraph();
  }

  void testFontVariations(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Text
    Text2d s = new Text2d();
    canvas.attach(s);

    s.text.enter = new StringConstant("Abcd");
    s.x.enter = new NumberConstant.array([75, 225, 375, 525, 675, 825, 975]);
    s.y.enter = new NumberConstant.array([55]);
    s.font.enter = new FontConstant.array([
      new Font(
          family: FontFamily.sansSerif, size: new FontSize.px(20), weight: FontWeight.bold, style: FontStyle.normal),
      new Font(family: FontFamily.serif, size: new FontSize.px(12), weight: FontWeight.normal, style: FontStyle.italic),
      new Font(
          family: FontFamily.monospace, size: new FontSize.px(14), weight: FontWeight.normal, style: FontStyle.normal),
      new Font(
          family: FontFamily.cursive, size: new FontSize.px(14), weight: FontWeight.bolder, style: FontStyle.normal),
      new Font(
          family: new FontFamily.custom("Ubuntu Mono"),
          size: new FontSize.px(28),
          weight: FontWeight.bold,
          style: FontStyle.normal),
      new Font(
          family: FontFamily.fantasy, size: new FontSize.px(16), weight: FontWeight.normal, style: FontStyle.oblique),
      new Font(size: new FontSize.px(30), weight: FontWeight.bold, style: FontStyle.oblique)
    ]);
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    // Text
    Text2d s = new Text2d();
    canvas.attach(s);

    s.text.enter = new StringConstant("12345");
    s.x.enter = new NumberConstant.array([50, 100, 150, 200, 250]);
    s.y.enter = new NumberConstant(50);
    s.rotation.enter = new AngleConstant.array(
        [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    Text2d s = new Text2d();
    canvas.attach(s);

    List<num> xList = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.text.enter = new StringConstant("yXy");
    s.x.enter = new NumberConstant.array(xList);
    s.y.enter = new NumberConstant(100);
    s.font.enter = new FontConstant(new Font(
        family: FontFamily.sansSerif, size: new FontSize.cssLength(new CssLength.pt(14)), weight: FontWeight.bold));
    s.lineWidth.enter = new NumberConstant(1);
    s.rotation.enter = new AngleConstant(new Angle(deg: 0));
    s.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.black));
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
    CanvasNode canvas = new CanvasNode();
    esg.attachToRoot(canvas);
    Text2d t = new Text2d();
    canvas.attach(t);

    enterButton.onClick.listen((_) {
      t.text.enter = new StringConstant("qwerty");
      t.x.enter = new NumberConstant.array([75]);
      t.y.enter = new NumberConstant.array([55]);
      t.font.enter = new FontConstant(new Font(
          family: FontFamily.sansSerif, size: new FontSize.cssLength(new CssLength.pt(16)), weight: FontWeight.bold));
      t.rotation.enter = new AngleConstant(new Angle(deg: 0));
      t.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
      t.opacity.enter = new NumberConstant(0.3);

      t.text.update = null;
      t.x.update = null;
      t.y.update = null;
      t.font.update = null;
      t.rotation.update = null;
      t.fillStyle.update = null;
      t.opacity.update = null;

      esg.updateGraph();
    });

    updateButton.onClick.listen((_) {
      t.text.enter = new StringConstant("qwerty");
      t.x.enter = new NumberConstant(50);
      t.y.enter = new NumberConstant(50);
      t.font.enter = new FontConstant(new Font(
          family: FontFamily.sansSerif, size: new FontSize.cssLength(new CssLength.pt(12)), weight: FontWeight.normal));
      t.rotation.enter = new AngleConstant(new Angle(deg: 0));
      t.fillStyle.enter = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.BLUE));
      t.opacity.enter = new NumberConstant(1);

      t.text.update = new StringConstant("qwerty2");
      t.x.update = new NumberConstant(200);
      t.y.update = new NumberConstant(100);
      t.font.update = new FontConstant(new Font(
          family: FontFamily.cursive, size: new FontSize.cssLength(new CssLength.pt(20)), weight: FontWeight.bold));
      t.rotation.update = new AngleConstant(new Angle(deg: 720));
      t.fillStyle.update = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.RED));
      t.opacity.update = new NumberConstant(1);
      esg.updateGraph();
    });

    exitButton.onClick.listen((_) {
      t.text.exit = new StringConstant("qwertybye");
      t.x.exit = new NumberConstant(400);
      t.y.exit = new NumberConstant(10);
      t.rotation.exit = new AngleConstant(new Angle(deg: 0));
      t.fillStyle.exit = new DrawingStyle2dConstant(new DrawingStyle2d(color: Color.gray555));
      t.opacity.exit = new NumberConstant(0);

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
    EnvySceneGraph esg = e.sceneGraph;
    CanvasNode canvas = new CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    Text2d s = new Text2d();
    canvas.attach(s);

    s.x.enter = new NumberConstant.array([50, 150, 250, 350, 360]);
    s.y.enter = new NumberConstant(50);
    s.text.enter = new StringConstant.array(["abc", "def", "xyz", "pdq", "omg"]);
    s.font.enter = new FontConstant(new Font(
        family: FontFamily.sansSerif, size: new FontSize.cssLength(new CssLength.pt(16)), weight: FontWeight.bold));
    s.rotation.enter = new AngleConstant.array(
        [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
    s.fill.enter = BooleanConstant.TRUE;
    s.fillStyle.enter = new DrawingStyle2dConstant.array([
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(color: Color.BLUE),
      new DrawingStyle2d(color: Color.black),
      new DrawingStyle2d(color: Color.RED)
    ]);

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
}
