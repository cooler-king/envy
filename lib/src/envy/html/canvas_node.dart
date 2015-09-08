part of envy;

/// Global list of current 2D contexts
final List<CanvasRenderingContext2D> _currentContext2DList = [];

/// Global list of current 2D transforms (no way to get from HTML canvas)
final List<ListQueue<Matrix3>> _transform2DStackList = [];

/// [CanvasNode] is an Envy scene graph node that manages an
/// HTML Canvas element.
///
class CanvasNode extends HtmlNode implements CanvasImageSourceNode {
  num initialWidth;
  num initialHeight;

  // Keep track of last Graphic2d to intersect with mouse event
  Graphic2dIntersection _lastG2di;

  // Mouse event streams for events that fall through to the background (no interstion with graphic)
  Stream onClick;
  StreamController<MouseEvent> _onClickController;

  Stream onDoubleClick;
  StreamController<MouseEvent> _onDoubleClickController;

  Stream onMouseEnter;
  StreamController<MouseEvent> _onMouseEnterController;

  Stream onMouseOver;
  StreamController<MouseEvent> _onMouseOverController;

  Stream onMouseOut;
  StreamController<MouseEvent> _onMouseOutController;

  Stream onMouseDown;
  StreamController<MouseEvent> _onMouseDownController;

  Stream onMouseUp;
  StreamController<MouseEvent> _onMouseUpController;

  CanvasNode([this.initialWidth = 500, this.initialHeight = 400]) {
    _initStreams();
  }

  CanvasElement generateNode() {
    CanvasElement canvas = new CanvasElement(width: initialWidth, height: initialHeight)
      ..style.position = "absolute"
      ..style.left = "0"
      ..style.top = "0"
      ..style.right = "0"
      ..style.bottom = "0";

    canvas.onClick.listen((e) => handleClick(canvas, e));
    canvas.onDoubleClick.listen((e) => handleDoubleClick(canvas, e));
    canvas.onMouseMove.listen((e) => handleMouseMove(canvas, e));
    canvas.onMouseUp.listen((e) => handleMouseUp(canvas, e));
    canvas.onMouseDown.listen((e) => handleMouseDown(canvas, e));

    return canvas;
  }

  void _initStreams() {
    _onClickController = new StreamController<MouseEvent>.broadcast();
    onClick = _onClickController.stream;

    _onDoubleClickController = new StreamController<MouseEvent>.broadcast();
    onDoubleClick = _onDoubleClickController.stream;

    _onMouseEnterController = new StreamController<MouseEvent>.broadcast();
    onMouseEnter = _onMouseEnterController.stream;

    _onMouseOverController = new StreamController<MouseEvent>.broadcast();
    onMouseOver = _onMouseOverController.stream;

    _onMouseOutController = new StreamController<MouseEvent>.broadcast();
    onMouseOut = _onMouseOutController.stream;

    _onMouseDownController = new StreamController<MouseEvent>.broadcast();
    onMouseDown = _onMouseDownController.stream;

    _onMouseUpController = new StreamController<MouseEvent>.broadcast();
    onMouseUp = _onMouseUpController.stream;
  }

  CanvasElement elementAt(int index) {
    List list = new List.from(_domNodesMap.values);
    return list[index % _domNodesMap.length] as CanvasElement;
  }

  /// Clear the canvas and then update all children.
  ///
  @override
  void update(num timeFraction, {dynamic context, finish: false}) {
    //print("canvas update fraction = ${timeFraction}");
    // Clear canvases and store 2D contexts before draw anything new
    _currentContext2DList.clear();
    _transform2DStackList.clear();
    for (Node n in _domNodesMap.values) {
      if (n is CanvasElement) {
        // Make sure canvas fills its parent
        if (n.parent != null) {
          Rectangle rect = n.parent.getBoundingClientRect();
          if (n.width != rect.width) n.width = rect.width.toInt();
          if (n.height != rect.height) n.height = rect.height.toInt();
        }

        n.context2D.clearRect(0, 0, n.width, n.height);
        _currentContext2DList.add(n.context2D);

        ListQueue<Matrix3> transform2DStack = new ListQueue<Matrix3>();
        transform2DStack.add(new Matrix3.identity());
        _transform2DStackList.add(transform2DStack);
      }
    }

    super.update(timeFraction, context: context, finish: finish);
  }

  void handleClick(CanvasElement canvas, MouseEvent e) {
    Graphic2dIntersection g2d = graphic2dAtEvent(e, canvas);
    if (g2d == null) {
      _onClickController.add(e);
      return;
    }
    g2d.graphic2d.fireClickEvent(g2d..event = e);
    _lastG2di = g2d;
  }

  void handleDoubleClick(CanvasElement canvas, MouseEvent e) {
    Graphic2dIntersection g2d = graphic2dAtEvent(e, canvas);
    if (g2d == null) {
      _onDoubleClickController.add(e);
      return;
    }
    g2d.graphic2d.fireDoubleClickEvent(g2d..event = e);
    _lastG2di = g2d;
  }

  void handleMouseMove(CanvasElement canvas, MouseEvent e) {
    Graphic2dIntersection g2d = graphic2dAtEvent(e, canvas);
    if (g2d != _lastG2di) {
      // Over
      if (_lastG2di != null) {
        _lastG2di.graphic2d.fireMouseOutEvent(_lastG2di..event = e);
      }

      if (g2d != null && g2d.graphic2d != null) {
        g2d.graphic2d.fireMouseEnterEvent(g2d..event = e);
      }
    }

    _lastG2di = g2d;
    if (g2d == null) {
      _onMouseOverController.add(e);
      return;
    }
    g2d.graphic2d.fireMouseOverEvent(g2d..event = e);
  }

  void handleMouseUp(CanvasElement canvas, MouseEvent e) {
    Graphic2dIntersection g2d = graphic2dAtEvent(e, canvas);
    if (g2d == null) {
      _onMouseUpController.add(e);
      return;
    }
    g2d.graphic2d.fireMouseUpEvent(g2d..event = e);
    _lastG2di = g2d;
  }

  void handleMouseDown(CanvasElement canvas, MouseEvent e) {
    Graphic2dIntersection g2d = graphic2dAtEvent(e, canvas);
    if (g2d == null) {
      _onMouseDownController.add(e);
      return;
    }
    g2d.graphic2d.fireMouseDownEvent(g2d..event = e);
    _lastG2di = g2d;
  }

  /// Finds the first graphic that intersects the point.
  ///
  /// This will be the graphic rendered on top either due to being
  /// rendered last or because it is rendered on a layer higher than
  /// any other matches.
  ///
  /// Returns null if no 2d graphic intersects [pt].
  ///
  Graphic2dIntersection graphic2dAtEvent(MouseEvent e, CanvasElement canvas) {
    var canvasRect = canvas.getBoundingClientRect();
    var pt = new Point(e.client.x - canvasRect.left, e.client.y - canvasRect.top);

    return graphic2dAtPointInGroup(pt, this, canvas.context2D);
/*    // Go backwards
    int numChildren = children.length;
    EnvyNode child;
    for (int i = numChildren - 1; i > -1; i--) {
      child = children[i];
      if (child is Graphic2dNode) {
        //todo transform point to local coords
        int intersectionIndex = child.indexContainingPoint(pt.x, pt.y, ctx);
        if (intersectionIndex != null) return new Graphic2dIntersection(child, intersectionIndex);
      }

      if (child is GroupNode) {
        Graphic2dIntersection g2di = graphic2dAtPointInGroup(pt, child, ctx);
        if(g2di != null) return g2di;
      }
    }

    return null;*/
  }

  Graphic2dIntersection graphic2dAtPointInGroup(Point pt, GroupNode grp, CanvasRenderingContext2D ctx) {
    // Go backwards
    int numChildren = grp.children.length;
    EnvyNode child;
    for (int i = numChildren - 1; i > -1; i--) {
      child = grp.children[i];

      if (child is Graphic2dNode) {
        int intersectionIndex = child.indexContainingPoint(pt.x, pt.y, ctx);
        if (intersectionIndex != null) return new Graphic2dIntersection(child, intersectionIndex);
      }

      if (child is GroupNode) {
        Graphic2dIntersection g2di = graphic2dAtPointInGroup(pt, child, ctx);
        if (g2di != null) return g2di;
      }
    }
    return null;
  }

  /*
  int indexForCanvas(CanvasElement canvas) {
    for(int index = 0; i<_domNodesMap.length; i++) {
      if(identical(canvas, _domNodesMap))
    }
  }*/
}

class Graphic2dIntersection {
  final Graphic2dNode graphic2d;
  final int index;
  MouseEvent event;

  Graphic2dIntersection(this.graphic2d, this.index);

  @override
  bool operator ==(obj) {
    if (obj is! Graphic2dIntersection) return false;
    if (obj.graphic2d != graphic2d) return false;
    if (index != obj.index) return false;
    return true;
  }

  String toString() =>
      "Intersection at index ${index} of ${graphic2d.runtimeType}; event = ${event.type} (${event.client.x}, ${event.client.y})";
}
