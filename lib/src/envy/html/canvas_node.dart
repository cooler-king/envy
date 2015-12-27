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

  // Mouse event streams for events that fall through to the background (no intersection with graphic)
  Stream onClick;
  StreamController<MouseEvent> _onClickController;

  Stream onDoubleClick;
  StreamController<MouseEvent> _onDoubleClickController;

  Stream onMouseEnter;
  StreamController<MouseEvent> _onMouseEnterController;

  Stream onMouseLeave;
  StreamController<MouseEvent> _onMouseLeaveController;

  Stream onMouseOver;
  StreamController<MouseEvent> _onMouseOverController;

  Stream onMouseOut;
  StreamController<MouseEvent> _onMouseOutController;

  Stream onMouseDown;
  StreamController<MouseEvent> _onMouseDownController;

  Stream onMouseUp;
  StreamController<MouseEvent> _onMouseUpController;

  Stream onMouseMove;
  StreamController<MouseEvent> _onMouseMoveController;

  final List<Graphic2dIntersection> _prevHits = [];
  final List<Graphic2dIntersection> _newHits = [];

  final List<Graphic2dIntersection> outs = [];
  final List<Graphic2dIntersection> overs = [];


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

    _onMouseLeaveController = new StreamController<MouseEvent>.broadcast();
    onMouseLeave = _onMouseLeaveController.stream;

    _onMouseOverController = new StreamController<MouseEvent>.broadcast();
    onMouseOver = _onMouseOverController.stream;

    _onMouseOutController = new StreamController<MouseEvent>.broadcast();
    onMouseOut = _onMouseOutController.stream;

    _onMouseDownController = new StreamController<MouseEvent>.broadcast();
    onMouseDown = _onMouseDownController.stream;

    _onMouseUpController = new StreamController<MouseEvent>.broadcast();
    onMouseUp = _onMouseUpController.stream;

    _onMouseMoveController = new StreamController<MouseEvent>.broadcast();
    onMouseMove = _onMouseMoveController.stream;
  }

  CanvasElement elementAt(int index) => _domNodesMap.values.elementAt(index % _domNodesMap.length);

  /// Clear the canvas and then update all children.
  ///
  @override
  void update(num timeFraction, {dynamic context, finish: false}) {
    // Clear canvases and store 2D contexts before drawing anything new
    _currentContext2DList.clear();
    _transform2DStackList.clear();
    for (Node n in _domNodesMap.values) {
      if (n is CanvasElement) {
        // Make sure canvas fills its parent
        if (n.parent != null) {
          var rect = n.parent.getBoundingClientRect();
          if (n.width != rect.width) n.width = rect.width.toInt();
          if (n.height != rect.height) n.height = rect.height.toInt();
        }

        n.context2D.clearRect(0, 0, n.width, n.height);
        _currentContext2DList.add(n.context2D);

        var transform2DStack = new ListQueue<Matrix3>()..add(new Matrix3.identity());
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

  /// Handles detection of mouse movement on the canvas.
  ///
  /// Fires enter events on any newly intersected graphics,
  /// regardless of intersection depth.
  ///
  /// Fires leave events on any previously intersected graphics
  /// that are no longer intersected, regardless of intersection
  /// depth.
  ///
  /// Fires an out event on any previously intersected graphics
  /// that are no longer intersected, regardless of intersection
  /// depth (same as leave) but also on any graphic that is still
  /// intersected for which one or more of the superimposed graphics
  /// is no longer intersected (that is, the mouse has moved out
  /// of a graphic on top of it but is still over it.)  This is
  /// analogous to the browser's mouseout events that fire when
  /// the mouse moves out of child DOM nodes.
  ///
  /// Fires over events on any newly intersected graphics,
  /// regardless of intersection depth (same as enter) but also
  /// on any graphic that was previously intersected for which
  /// there are new intersections above it (that is, the mouse has
  /// moved over a new graphic on top of it while still over it as
  /// well).  This is analogous to the browser's mouseover events
  /// that fire when the mouse moves over child DOM nodes.
  ///
  /// Fires a move event on the topmost intersected graphic
  /// or on this canvas itself if there are no intersections.
  ///
  void handleMouseMove(CanvasElement canvas, MouseEvent e) {
    _prevHits.clear();
    _prevHits.addAll(_newHits);
    _newHits.clear();

    allGraphic2dsAtEvent(e, canvas, addToList: _newHits);

    if (_newHits.isEmpty) {
      if (_prevHits.isNotEmpty) {
        // Leave and out events for all previous
        for (var hit in _prevHits) {
          hit.event = e;
          hit.graphic2d
            ..fireMouseLeaveEvent(hit)
            ..fireMouseOutEvent(hit);
        }
      }

      // Pass along move event to canvas if no graphic intersected.
      _onMouseMoveController.add(e);

      return;
    }

    // There are new hits if get this far.

    // Compare prev to new hit list, firing leave and out events
    // as appropriate
    outs.clear();
    for (var prevHit in _prevHits) {
      if (!_newHits.contains(prevHit)) {
        prevHit.graphic2d.fireMouseLeaveEvent(prevHit..event = e);

        // Previous hit and all remaining hits underneath it get an out event
        outs.add(prevHit);
        prevHit.graphic2d.fireMouseOutEvent(prevHit..event = e);
      } else {
        if(outs.isNotEmpty) {
          for(var out in outs) {
            prevHit.graphic2d.fireMouseOutEvent(out..event = e);
          }
        }
      }
    }

    // Compare new to previous hit list, firing enter and over events
    // as appropriate
    overs.clear();
    for (var newHit in _newHits) {
      if (!_prevHits.contains(newHit)) {
        newHit.graphic2d.fireMouseEnterEvent(newHit..event = e);

        // New hit and all remaining hits underneath it get an over event
        overs.add(newHit);
        newHit.graphic2d.fireMouseOverEvent(newHit..event = e);
      } else {
        if(overs.isNotEmpty) {
          for(var over in overs) {
            newHit.graphic2d.fireMouseOverEvent(over..event = e);
          }
        }
      }
    }

    // Move event
    var topHit = _newHits.first;
    topHit.graphic2d.fireMouseMoveEvent(topHit..event = e);
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
  }

  /// Returns a list of all the graphics that intersect the point,
  /// with the topmost intersection as the first entry (index 0).
  ///
  /// Returns null if no 2d graphic intersects [pt].
  ///
  List<Graphic2dIntersection> allGraphic2dsAtEvent(MouseEvent e, CanvasElement canvas, {List addToList}) {
    var canvasRect = canvas.getBoundingClientRect();
    var pt = new Point(e.client.x - canvasRect.left, e.client.y - canvasRect.top);

    return allGraphic2dsAtPointInGroup(pt, this, canvas.context2D, addToList: addToList);
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

  List<Graphic2dIntersection> allGraphic2dsAtPointInGroup(Point pt, GroupNode grp, CanvasRenderingContext2D ctx,
      {List addToList}) {
    // Go backwards
    EnvyNode child;
    List<int> intersectionIndices = [];
    List list = addToList ?? [];
    for (int i = grp.children.length - 1; i > -1; i--) {
      child = grp.children[i];

      if (child is Graphic2dNode) {
        child.allIndicesContainingPoint(pt.x, pt.y, ctx, listToUse: intersectionIndices);
        for(int z in intersectionIndices) {
          list.add(new Graphic2dIntersection(child, z));
        }
      }

      if (child is GroupNode) {
        allGraphic2dsAtPointInGroup(pt, child, ctx, addToList: list);
      }
    }
    return list.isNotEmpty ? list : null;
  }
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
      "Intersection at index ${index} of ${graphic2d?.runtimeType}; event = ${event?.type} (${event?.client?.x}, ${event?.client?.y})";
}
