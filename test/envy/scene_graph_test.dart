@TestOn('browser')
import 'package:test/test.dart';
import 'package:envy/envy.dart';

void main() {
  group('Scene Graph', () {
    test('Constructors', () {
      final esg = EnvySceneGraph();
      expect(esg.root is EnvyRoot, true);
      expect(esg.root.rootAnimation is AnimationGroup, true);
      expect(identical(esg.root.children.first, esg.root.rootAnimation), true);
    });

    test('update empty', () {
      final esg = EnvySceneGraph();
      var ok = true;
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
      EnvySceneGraph esg = EnvySceneGraph();
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
      final esg = EnvySceneGraph();
      final canvas = CanvasNode();
      esg.attachToRoot(canvas);
      expect(esg.root.children.first is AnimationGroup, true);
      expect((esg.root.children.first as AnimationGroup).children.first, canvas);
      final rect = Rect2d();
      canvas.attach(rect);
      expect((esg.root.rootAnimation.children.first as GroupNode).children.first, rect);

      rect.x.enter = NumberConstant(10);
      rect.y.enter = NumberConstant(20);
      rect.width.enter = NumberConstant(200);
      rect.height.enter = NumberConstant(100);

      expect(rect.x.enter is NumberSource, true);
      expect(rect.y.enter is NumberSource, true);
      expect(rect.x.enter.valueAt(0) == 10, true);
      expect(rect.y.enter.valueAt(0) == 20, true);
    });
  });
}
