import 'dart:async';
import 'dart:html';
import 'dart:math' as Math;
import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';
import 'package:quantity/quantity.dart';

void main() {
  initPolymer().then((Zone zone) {
    zone.run(() {
      Polymer.onReady.then((_) {
        // Code that executes after elements have been upgraded.
        _init();
      });
    });
  });
}

void _init() {
  testBasic();
  testRotation();
  testAnchors();
  testLifecycle();
  testDataDriven();
  testHit();
}

void testBasic() {
  EnvyDiv e = querySelector("#image2d-basic") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  ImageNode image = new ImageNode()
    ..src.enter = new StringConstant(
        "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");

  // Image
  Image2d s = new Image2d(image);
  canvas.attach(s);

  // Image has to be part of scene graph
  canvas.attach(image);

  CssStyle css = new CssStyle();
  css["opacity"] = new CssNumber(0.5);
  image.style.enter = new CssStyleConstant(css);

  //s.source = new CanvasImageSource()
  s.x.enter = new NumberConstant(5);
  s.y.enter = new NumberConstant(5);
  //s.width.enter = new NumberConstant(50);
  //s.height.enter = new NumberConstant(30);

  esg.updateGraph();
}

void testRotation() {
  EnvyDiv e = querySelector("#image2d-rotation") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 100);
  esg.attachToRoot(canvas);

  ImageNode image = new ImageNode()
    ..src.enter = new StringConstant(
        "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");

  // Image
  Image2d s = new Image2d(image);
  canvas.attach(s);

  // Image has to be part of scene graph
  canvas.attach(image);

  s.x.enter = new NumberConstant.array([50, 150, 250, 350, 450]);
  s.y.enter = new NumberConstant(10);
  s.width.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);

  esg.updateGraph();
}

void testAnchors() {
  EnvyDiv e = querySelector("#image2d-anchors") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 200);
  esg.attachToRoot(canvas);

  ImageNode image = new ImageNode()
    ..src.enter = new StringConstant(
        "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");

  // Image
  Image2d s = new Image2d(image);
  canvas.attach(s);

  // Image has to be part of scene graph
  canvas.attach(image);

  List<num> xList = [50, 150, 250, 350, 450, 550, 650, 750, 850, 950];

  s.x.enter = new NumberConstant.array(xList);
  s.y.enter = new NumberConstant(100);
  s.width.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
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

void testLifecycle() {
  EnvyDiv e = querySelector("#image2d-lifecycle") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode();
  esg.attachToRoot(canvas);

  ImageNode image = new ImageNode()
    ..src.enter = new StringConstant(
        "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");

  // Image
  Image2d s = new Image2d(image);
  canvas.attach(s);

  // Image has to be part of scene graph
  canvas.attach(image);

  ButtonElement enterButton = querySelector("#image2d-enter-button");
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

  ButtonElement updateButton = querySelector("#image2d-update-button");
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

  ButtonElement exitButton = querySelector("#image2d-exit-button");
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

void testDataDriven() {
  EnvyDiv e = querySelector("#image2d-data") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode();
  esg.attachToRoot(canvas);
  Map datamap = {"xcoord": 100, "ycoord": 50, "width": 50, "height": 20, "opacity": 1};
  canvas.addDataset("imagedata", map: datamap);

  ImageNode image = new ImageNode()
    ..src.enter = new StringConstant(
        "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");

  // Image
  Image2d s = new Image2d(image);
  canvas.attach(s);

  // Image has to be part of scene graph
  canvas.attach(image);

  s.x.enter = new NumberData("imagedata", canvas, prop: "xcoord");
  s.y.enter = new NumberData("imagedata", canvas, prop: "ycoord");
  s.width.enter = new NumberData("imagedata", canvas, prop: "width");
  s.height.enter = new NumberData("imagedata", canvas, prop: "height");
  s.opacity.enter = new NumberData("imagedata", canvas, prop: "opacity");
  s.rotation.enter = new AngleData("imagedata", canvas, prop: "rot");

  esg.updateGraph();

  ButtonElement dataButton = querySelector("#image2d-data-button");
  dataButton.onClick.listen((_) {
    Math.Random rand = new Math.Random();
    Map randomData = {
      "xcoord": 150 + rand.nextDouble() * 100,
      "ycoord": 140 + rand.nextDouble() * 50,
      "width": 40 + rand.nextDouble() * 100,
      "height": 40 + rand.nextDouble() * 100,
      "opacity": rand.nextDouble(),
      "rot": new Angle(deg: rand.nextDouble() * 360)
    };
    canvas.addDataset("imagedata", map: randomData);
    esg.updateGraph();
  });
}

void testHit() {
  EnvyDiv e = querySelector("#hit") as EnvyDiv;
  EnvySceneGraph esg = e.sceneGraph;
  CanvasNode canvas = new CanvasNode(1000, 500);
  esg.attachToRoot(canvas);

  canvas.onClick.listen((e) => querySelector("#hit-feedback").innerHtml = "CLICKED BACKGROUND ${e}");

  ImageNode image = new ImageNode()
    ..src.enter = new StringConstant(
        "https://mozorg.cdn.mozilla.net/media/img/styleguide/identity/firefox/usage-logo.54fbc7b6231b.png");

  // Image
  Image2d s = new Image2d(image);
  canvas.attach(s);

  // Image has to be part of scene graph
  canvas.attach(image);

  s.x.enter = new NumberConstant.array([50, 150, 250, 350, 375]);
  s.y.enter = new NumberConstant(50);
  s.width.enter = new NumberConstant(40);
  s.height.enter = new NumberConstant(40);
  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
  s.data.enter = new NumberConstant.array([10, 20, 30, 40, 50]);

  s.rotation.enter = new AngleConstant.array(
      [new Angle(deg: 0), new Angle(deg: 30), new Angle(deg: 45), new Angle(deg: 60), new Angle(deg: 90)]);
  s.onClick.listen((g2di) => querySelector("#hit-feedback").innerHtml =
      "CLICKED ${g2di}... data = ${g2di.graphic2d.data.valueAt(g2di.index)}");
  s.onDoubleClick.listen((g2di) => querySelector("#hit-feedback").innerHtml = "DOUBLE-CLICKED ${g2di}");
  s.onMouseEnter.listen((g2di) => querySelector("#hit-feedback").innerHtml = "ENTER ${g2di}");
  s.onMouseOut.listen((g2di) => querySelector("#hit-feedback").innerHtml = "OUT ${g2di}");
  s.onMouseOver.listen((g2di) => querySelector("#hit-feedback-over").innerHtml = "OVER ${g2di}");
  s.onMouseDown.listen((g2di) => querySelector("#hit-feedback-downup").innerHtml = "DOWN ${g2di}");
  s.onMouseUp.listen((g2di) => querySelector("#hit-feedback-downup").innerHtml = "UP ${g2di}");

  esg.updateGraph();
}
