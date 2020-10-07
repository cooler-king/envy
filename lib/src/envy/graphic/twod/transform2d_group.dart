import 'dart:collection';
import 'dart:html';
import 'package:quantity/quantity.dart' hide logger;
import 'package:vector_math/vector_math.dart';
import '../../dynamic_node.dart';
import '../../envy_property.dart';
import '../../html/canvas_node.dart';
import '../../util/logger.dart';
import '../graphic_node.dart';

//TODO should the size of this node affect the number of canvases?

/// Transforms its child nodes.
class Transform2dGroup extends GraphicGroup with DynamicNode {
  /// Constructs a instance.
  Transform2dGroup() : super() {
    _initProperties();
  }

  void _initProperties() {
    properties['rotate'] = AngleProperty();
    properties['scale'] = Scale2Property();
    properties['translate'] = Vector2Property();
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
      for (var index = 0; index < currentContext2DList.length; index++) {
        final ctx = currentContext2DList[index];
        final transform2DStack = transform2DStackList[index];

        final currentTransform = transform2DStack.first;

        final _scale = scale.valueAt(index);
        final sx = _scale.x;
        final sy = _scale.y;
        final theta = rotate.valueAt(index);
        final cosTheta = theta.cosine();
        final sinTheta = theta.sine();
        final _translate = translate.valueAt(index);
        final tx = _translate.x;
        final ty = _translate.y;

        // Column major order.
        final myTransform = Matrix3(sx * cosTheta, sy * sinTheta, 0, -sx * sinTheta, sy * cosTheta, 0, tx, ty, 1)
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
    for (var index = 0; index < currentContext2DList.length; index++) {
      final ctx = currentContext2DList[index];
      if (transform2DStackList.length > index) {
        final transform2DStack = transform2DStackList[index]..removeFirst();
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
