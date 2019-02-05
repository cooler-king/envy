@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Scene Graph', () {
    test('Constructors', () {
      final EnvySceneGraph esg = new EnvySceneGraph();
      expect(esg.root is EnvyRoot, true);
      expect(esg.root.rootAnimation is AnimationGroup, true);
      expect(identical(esg.root.children.first, esg.root.rootAnimation), true);
    });

    test('update empty', () {
      final EnvySceneGraph esg = new EnvySceneGraph();
      bool ok = true;
      try {
        esg.updateGraph();
      } catch (e) {
        ok = false;
        print(e);
      }
      expect(ok, true);
    });

    /*
    test('update empty', () {
      EnvySceneGraph esg = new EnvySceneGraph();
      bool ok = true;
      try {
        esg.updateGraph();
      } catch(e) {
        ok = false;
        print(e);
      }
      expect(ok, true);
    });
*/

    test('canvas with rect', () {
      final EnvySceneGraph esg = new EnvySceneGraph();
      final CanvasNode canvas = new CanvasNode();
      esg.attachToRoot(canvas);
      expect(esg.root.children.first is AnimationGroup, true);
      expect((esg.root.children.first as AnimationGroup).children.first, canvas);
      final Rect2d rect = new Rect2d();
      canvas.attach(rect);
      expect((esg.root.rootAnimation.children.first as GroupNode).children.first, rect);

      rect.x.enter = new NumberConstant(10);
      rect.y.enter = new NumberConstant(20);
      rect.width.enter = new NumberConstant(200);
      rect.height.enter = new NumberConstant(100);

      expect(rect.x.enter is NumberSource, true);
      expect(rect.y.enter is NumberSource, true);
      expect(rect.x.enter.valueAt(0) == 10, true);
      expect(rect.y.enter.valueAt(0) == 20, true);
    });
  });
}
