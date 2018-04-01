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
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final ImageNode image = new ImageNode()..src.enter = new StringConstant(imageUrl);

    // Image
    final Image2d s = new Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    final CssStyle css = new CssStyle();
    css['opacity'] = new CssNumber(0.5);
    image.style.enter = new CssStyleConstant(css);

    //s.source = new CanvasImageSource()
    s.x.enter = new NumberConstant(5);
    s.y.enter = new NumberConstant(5);
    //s.width.enter = new NumberConstant(50);
    //s.height.enter = new NumberConstant(30);

    esg.updateGraph();
  }

  void testRotation(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final ImageNode image = new ImageNode()..src.enter = new StringConstant(imageUrl);

    // Image
    final Image2d s = new Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 450]);
    s.y.enter = new NumberConstant(10);
    s.width.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

    esg.updateGraph();
  }

  void testAnchors(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 200);
    esg.attachToRoot(canvas);

    final ImageNode image = new ImageNode()..src.enter = new StringConstant(imageUrl);

    // Image
    final Image2d s = new Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    final List<num> xList = <num>[50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

    s.x.enter = new NumberConstant.array(xList);
    s.y.enter = new NumberConstant(100);
    s.width.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
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

    final ImageNode image = new ImageNode()..src.enter = new StringConstant(imageUrl);

    // Image
    final Image2d s = new Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    enterButton.onClick.listen((_) {
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.width.enter = new NumberConstant(50);
      s.height.enter = new NumberConstant(50);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.opacity.enter = new NumberConstant(1);

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
      s.x.enter = new NumberConstant(50);
      s.y.enter = new NumberConstant(50);
      s.width.enter = new NumberConstant(50);
      s.height.enter = new NumberConstant(30);
      s.rotation.enter = new AngleConstant(new Angle(deg: 0));
      s.opacity.enter = new NumberConstant(1);

      s.x.update = new NumberConstant(200);
      s.y.update = new NumberConstant(100);
      s.width.update = new NumberConstant(100);
      s.height.update = new NumberConstant(80);
      s.rotation.update = new AngleConstant(new Angle(deg: 720));
      s.opacity.update = new NumberConstant(1);
      esg.updateGraph();
    });

    // ignore: cascade_invocations
    exitButton.onClick.listen((_) {
      s.x.exit = new NumberConstant(400);
      s.y.exit = new NumberConstant(10);
      s.width.exit = new NumberConstant(2);
      s.height.exit = new NumberConstant(2);
      s.rotation.exit = new AngleConstant(new Angle(deg: 0));
      s.opacity.exit = new NumberConstant(0);

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
    final CanvasNode canvas = new CanvasNode();
    esg.attachToRoot(canvas);
    final Map<String, int> datamap = <String, int>{
      'xcoord': 100,
      'ycoord': 50,
      'width': 50,
      'height': 20,
      'opacity': 1
    };
    canvas.addDataset('imagedata', map: datamap);

    final ImageNode image = new ImageNode()..src.enter = new StringConstant(imageUrl);

    // Image
    final Image2d s = new Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    s.x.enter = new NumberData('imagedata', canvas, prop: 'xcoord');
    s.y.enter = new NumberData('imagedata', canvas, prop: 'ycoord');
    s.width.enter = new NumberData('imagedata', canvas, prop: 'width');
    s.height.enter = new NumberData('imagedata', canvas, prop: 'height');
    s.opacity.enter = new NumberData('imagedata', canvas, prop: 'opacity');
    s.rotation.enter = new AngleData('imagedata', canvas, prop: 'rot');

    esg.updateGraph();

    dataButton.onClick.listen((_) {
      final Random rand = new Random();
      final Map<String, dynamic> randomData = <String, dynamic>{
        'xcoord': 150 + rand.nextDouble() * 100,
        'ycoord': 140 + rand.nextDouble() * 50,
        'width': 40 + rand.nextDouble() * 100,
        'height': 40 + rand.nextDouble() * 100,
        'opacity': rand.nextDouble(),
        'rot': new Angle(deg: rand.nextDouble() * 360)
      };
      canvas.addDataset('imagedata', map: randomData);
      esg.updateGraph();
    });
  }

  void testHit(EnvyScene e) {
    final EnvySceneGraph esg = e.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 500);
    esg.attachToRoot(canvas);

    canvas.onClick.listen((MouseEvent e) => querySelector('#hit-feedback').innerHtml = 'CLICKED BACKGROUND $e');

    final ImageNode image = new ImageNode()..src.enter = new StringConstant(imageUrl);

    // Image
    final Image2d s = new Image2d(image);
    canvas
      ..attach(s)

      // Image has to be part of scene graph
      ..attach(image);

    s.x.enter = new NumberConstant.array(<num>[50, 150, 250, 350, 375]);
    s.y.enter = new NumberConstant(50);
    s.width.enter = new NumberConstant(40);
    s.height.enter = new NumberConstant(40);
    s.rotation.enter = new AngleConstant.array(
        <Angle>[new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
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
}
