import 'dart:collection';
import 'dart:html';
import 'package:quantity/quantity.dart';
import 'package:vector_math/vector_math.dart';
import '../../dynamic_node.dart';
import '../../envy_property.dart';
import '../../html/canvas_node.dart';
import '../../util/logger.dart';
import '../graphic_node.dart';

//TODO should the size of this node affect the number of canvases?

/// Transforms its child nodes.
class Transform2dGroup extends GraphicGroup with DynamicNode {
  /// Constructs a new instance.
  Transform2dGroup() : super() {
    _initProperties();
  }

  void _initProperties() {
    properties['rotate'] = new AngleProperty();
    properties['scale'] = new Scale2Property();
    properties['translate'] = new Vector2Property();
  }

  /// The scaling element of the transform.
  Scale2Property get scale => properties['scale'] as Scale2Property;

  /// The rotational element of the transform.
  AngleProperty get rotate => properties['rotate'] as AngleProperty;

  /// The translational element of the transform.
  Vector2Property get translate => properties['translate'] as Vector2Property;

  /// Updates prior to child updates (but after property updates).
  @override
  void groupUpdatePre(num timeFraction, {dynamic context, bool finish = false}) {
    try {
      for (int index = 0; index < currentContext2DList.length; index++) {
        final CanvasRenderingContext2D ctx = currentContext2DList[index];
        final ListQueue<Matrix3> transform2DStack = transform2DStackList[index];

        final Matrix3 currentTransform = transform2DStack.first;

        final Vector2 _scale = scale.valueAt(index);
        final double sx = _scale.x;
        final double sy = _scale.y;
        final Angle theta = rotate.valueAt(index);
        final double cosTheta = theta.cosine();
        final double sinTheta = theta.sine();
        final Vector2 _translate = translate.valueAt(index);
        final double tx = _translate.x;
        final double ty = _translate.y;

        // Column major order.
        final Matrix3 myTransform =
            new Matrix3(sx * cosTheta, sy * sinTheta, 0.0, -sx * sinTheta, sy * cosTheta, 0.0, tx, ty, 1.0)
              ..multiply(currentTransform);
        transform2DStack.addFirst(myTransform);
        _replaceTransform(myTransform, ctx);
      }
    } catch (e, s) {
      logger.severe('Error applying transform', e, s);
    }
  }

  /// Updates after child updates to restore the incoming transform.
  @override
  void groupUpdatePost(num timeFraction, {dynamic context, bool finish = false}) {
    // Set back to the incoming transform.
    for (int index = 0; index < currentContext2DList.length; index++) {
      final CanvasRenderingContext2D ctx = currentContext2DList[index];
      if (transform2DStackList.length > index) {
        final ListQueue<Matrix3> transform2DStack = transform2DStackList[index]..removeFirst();
        _replaceTransform(transform2DStack.first, ctx);
      } else {
        logger.warning('Attempt to revert transform at index $index ignored; out of range');
      }
    }
  }

  void _replaceTransform(Matrix3 t, CanvasRenderingContext2D context) {
    context.setTransform(t[0], t[1], t[3], t[4], t[6], t[7]);
  }
}
