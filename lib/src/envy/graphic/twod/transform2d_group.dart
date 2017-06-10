part of envy;

//TODO should the size of this node affect the number of canvases?

class Transform2dGroup extends GraphicGroup with DynamicNode {

  //Matrix3 _incomingTransform;
  Transform2dGroup() : super() {
    _initProperties();
  }

  void _initProperties() {
    properties["rotate"] = new AngleProperty();
    properties["scale"] = new Scale2Property();
    properties["translate"] = new Vector2Property();
  }

  Scale2Property get scale => properties["scale"] as Scale2Property;

  AngleProperty get rotate => properties["rotate"] as AngleProperty;

  Vector2Property get translate => properties["translate"] as Vector2Property;

  /// Updates prior to child updates (but after property updates).
  ///
  @override
  void groupUpdatePre(num timeFraction, {dynamic context, bool finish: false}) {
    try {
      // Apply the transform
      //for(CanvasRenderingContext2D ctx in _currentContext2DList) {

      for (int index = 0; index < _currentContext2DList.length; index++) {
        //if(context is CanvasRenderingContext2D) {
        // Save a copy of the transform before modification
        //int index = _currentContext2DList.indexOf(ctx);
        CanvasRenderingContext2D ctx = _currentContext2DList[index];
        ListQueue transform2DStack = _transform2DStackList[index];

        Matrix3 currentTransform = transform2DStack.first;

        Vector2 _scale = scale.valueAt(index);
        num sx = _scale.x;
        num sy = _scale.y;
        Angle theta = rotate.valueAt(index);
        num cosTheta = theta.cosine();
        num sinTheta = theta.sine();
        Vector2 _translate = translate.valueAt(index);
        num tx = _translate.x;
        num ty = _translate.y;

        // column major order
        Matrix3 myTransform =
            new Matrix3(sx * cosTheta, sy * sinTheta, 0.0, -sx * sinTheta, sy * cosTheta, 0.0, tx, ty, 1.0);

        myTransform.multiply(currentTransform);
        transform2DStack.addFirst(myTransform);
        _replaceTransform(myTransform, ctx);
      }
      //} else {
      //  _LOG.warning("Expected CanvasRenderingContext2D for context, not ${context}");
      // }
    } catch (e, s) {
      _LOG.severe("Error applying transform", e, s);
    }
  }

  /// Updates after child updates to restore the incoming transform.
  ///
  @override
  void groupUpdatePost(num timeFraction, {dynamic context, bool finish: false}) {
    // Set back to the incoming transform
    //if(context is CanvasRenderingContext2D) {
    for (int index = 0; index < _currentContext2DList.length; index++) {
      CanvasRenderingContext2D ctx = _currentContext2DList[index];
      // Save a copy of the transform before modification
      //int index = _currentContext2DList.indexOf(context);
      if (_transform2DStackList.length > index) {
        ListQueue transform2DStack = _transform2DStackList[index];
        transform2DStack.removeFirst();
        _replaceTransform(transform2DStack.first, ctx);
      } else {
        _LOG.warning("Attempt to revert transform at index ${index} ignored; out of range");
      }
    }
    //} else {
    //  _LOG.warning("Expected CanvasRenderingContext2D for context, not ${context}");
    // }
  }

  void _replaceTransform(Matrix3 t, CanvasRenderingContext2D context) {
    context.setTransform(t[0], t[1], t[3], t[4], t[6], t[7]);
    //context.setTransform(t[0], t[3], t[1], t[4], t[6], t[7]);
  }
}
