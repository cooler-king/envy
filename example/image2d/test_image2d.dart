import 'dart:html';
import 'dart:math';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_scene.dart';
import 'package:quantity/quantity.dart';
import 'package:angular/angular.dart';

@Component(
  selector: 'test-image2d',
  templateUrl: 'test_image2d.html',
  directives: const <Object>[EnvyScene],
)
class TestImage2d implements AfterViewInit {
  final String imageUrl = 'packages/envy/resources/morgan_silver_dollar.png';

  @ViewChild('basic')
  EnvyScene basicScene;

  @ViewChild('rotation')
  EnvyScene rotationScene;

  @ViewChild('circle')
  EnvyScene circleScene;

  @ViewChild('anchors')
  EnvyScene anchorsScene;

  @ViewChild('lifecycle')
  EnvyScene lifecycleScene;

  @ViewChild('data')
  EnvyScene dataScene;

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
    testHit(hitScene);
  }

  void testBasic(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final ImageNode image = ImageNode()..src.enter = StringConstant(imageUrl);

    // Image
    final Image2d s = Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    final CssStyle css = CssStyle();
    css['opacity'] = CssNumber(0.5);
    image.style.enter = CssStyleConstant(css);

    //s.source = CanvasImageSource()
    s.x.enter = NumberConstant(5);
    s.y.enter = NumberConstant(5);
    //s.width.enter = NumberConstant(50);
    //s.height.enter = NumberConstant(30);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final ImageNode image = ImageNode()..src.enter = StringConstant(imageUrl);

    // Image
    final Image2d s = Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = NumberConstant(10);
    s.width.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
    s.rotation.enter = AngleConstant.array(
        <Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final ImageNode image = ImageNode()..src.enter = StringConstant(imageUrl);

    // Image
    final Image2d s = Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    final List<num> xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = NumberConstant.array(xList);
    s.y.enter = NumberConstant(100);
    s.width.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
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

    final ImageNode image = ImageNode()..src.enter = StringConstant(imageUrl);

    // Image
    final Image2d s = Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    enterButton.onClick.listen((_) {
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.width.enter = NumberConstant(50);
      s.height.enter = NumberConstant(50);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.opacity.enter = NumberConstant(1);

      s.x.update = null;
      s.y.update = null;
      s.width.update = null;
      s.height.update = null;
      s.rotation.update = null;
      s.opacity.update = null;

      esg.updateGraph();
    });

    // ignore: cascade_invocations
    updateButton.onClick.listen((_) {
      s.x.enter = NumberConstant(50);
      s.y.enter = NumberConstant(50);
      s.width.enter = NumberConstant(50);
      s.height.enter = NumberConstant(30);
      s.rotation.enter = AngleConstant(Angle(deg: 0));
      s.opacity.enter = NumberConstant(1);

      s.x.update = NumberConstant(200);
      s.y.update = NumberConstant(100);
      s.width.update = NumberConstant(100);
      s.height.update = NumberConstant(80);
      s.rotation.update = AngleConstant(Angle(deg: 720));
      s.opacity.update = NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.x.exit = NumberConstant(400);
      s.y.exit = NumberConstant(10);
      s.width.exit = NumberConstant(2);
      s.height.exit = NumberConstant(2);
      s.rotation.exit = AngleConstant(Angle(deg: 0));
      s.opacity.exit = NumberConstant(0);

      s.x.enter = null;
      s.y.enter = null;
      s.width.enter = null;
      s.height.enter = null;
      s.rotation.enter = null;
      s.opacity.enter = null;

      s.x.update = null;
      s.y.update = null;
      s.width.update = null;
      s.height.update = null;
      s.rotation.update = null;
      s.opacity.update = null;

      esg.updateGraph();
    });
  }

  void testDataDriven(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode();
    esg.attachToRoot(canvas);
    final Map<String, int> datamap = <String, int>{
      'xcoord': 100,
      'ycoord': 50,
      'width': 50,
      'height': 20,
      'opacity': 1
    };
    canvas.addDataset('imagedata', map: datamap);

    final ImageNode image = ImageNode()..src.enter = StringConstant(imageUrl);

    // Image
    final Image2d s = Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    s.x.enter = NumberData('imagedata', canvas, prop: 'xcoord');
    s.y.enter = NumberData('imagedata', canvas, prop: 'ycoord');
    s.width.enter = NumberData('imagedata', canvas, prop: 'width');
    s.height.enter = NumberData('imagedata', canvas, prop: 'height');
    s.opacity.enter = NumberData('imagedata', canvas, prop: 'opacity');
    s.rotation.enter = AngleData('imagedata', canvas, prop: 'rot');

    esg.updateGraph();

    dataButton.onClick.listen((_) {
      final Random rand = Random();
      final Map<String, dynamic> randomData = <String, dynamic>{
        'xcoord': 150 + rand.nextDouble() * 100,
        'ycoord': 140 + rand.nextDouble() * 50,
        'width': 40 + rand.nextDouble() * 100,
        'height': 40 + rand.nextDouble() * 100,
        'opacity': rand.nextDouble(),
        'rot': Angle(deg: rand.nextDouble() * 360)
      };
      canvas.addDataset('imagedata', map: randomData);
      esg.updateGraph();
    });
  }

  void testHit(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    canvas.onClick.listen((MouseEvent e) => querySelector('#hit-feedback').innerHtml = 'CLICKED BACKGROUND $e');

    final ImageNode image = ImageNode()..src.enter = StringConstant(imageUrl);

    // Image
    final Image2d s = Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    s.x.enter = NumberConstant.array(<num>[50, 150, 250, 350, 375]);
    s.y.enter = NumberConstant(50);
    s.width.enter = NumberConstant(40);
    s.height.enter = NumberConstant(40);
    s.rotation.enter = AngleConstant.array(
        <Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
    s.data.enter = NumberConstant.array(<num>[10, 20, 30, 40, 50]);

    s.rotation.enter = AngleConstant.array(
        <Angle>[Angle(deg: 0), Angle(deg: 30), Angle(deg: 45), Angle(deg: 60), Angle(deg: 90)]);
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
}
