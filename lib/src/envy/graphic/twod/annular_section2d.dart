part of envy;

/// A 2-dimensional annular section to be drawn on an HTML canvas.
///
/// An annular section is a portion of a circle bounded by minimum and
/// maximum radii and angles.  The zero angle corresponds with the x-axis
/// and angles increase in the clockwise direction.
///
class AnnularSection2d extends Graphic2dNode {
  AnnularSection2d() : super(null) {
    _initProperties();
  }

  void _initProperties() {
    properties["innerRadius"] = new NumberProperty();
    properties["outerRadius"] = new NumberProperty();
    properties["startAngle"] = new AngleProperty();
    properties["endAngle"] = new AngleProperty();
  }

  NumberProperty get innerRadius => properties["innerRadius"] as NumberProperty;
  NumberProperty get outerRadius => properties["outerRadius"] as NumberProperty;
  AngleProperty get startAngle => properties["startAngle"] as AngleProperty;
  AngleProperty get endAngle => properties["endAngle"] as AngleProperty;

  void _renderIndex(int i, CanvasRenderingContext2D ctx) {
    num _x, _y, _innerRadius, _outerRadius, _startAngleRad, _endAngleRad;
    _innerRadius = innerRadius.valueAt(i);
    _outerRadius = outerRadius.valueAt(i);
    _startAngleRad = startAngle.valueAt(i).valueSI.toDouble();
    _endAngleRad = endAngle.valueAt(i).valueSI.toDouble();

    bool _fill = fill.valueAt(i);
    bool _stroke = stroke.valueAt(i);

    AngleRange range = new AngleRange(new Angle(rad: _startAngleRad), new Angle(rad: _endAngleRad));

    // Adjust for anchor (default is at the origin of the circle of which the annulus is a section)
    _x = 0;
    _y = 0;
    Anchor2d _anchor = anchor.valueAt(i);
    if (_anchor?.isNotDefault ?? false) {
      num outerRadius = _outerRadius > _innerRadius ? _outerRadius : _innerRadius;

      Angle northernmost = range.angleClosestTo(angle0);
      num minY = -outerRadius * northernmost.cosine();

      Angle southernmost = range.angleClosestTo(angle180);
      num maxY = outerRadius * southernmost.cosine();

      Angle westernmost = range.angleClosestTo(angle270);
      num minX = outerRadius * westernmost.sine();

      Angle easternmost = range.angleClosestTo(angle90);
      num maxX = outerRadius * easternmost.sine();

      List<num> adj = _anchor.calcAdjustments(minY, maxX, maxY, minX);
      _x += adj[0];
      _y += adj[1];
    }

    var angleDelta = (_endAngleRad - _startAngleRad).abs();
    if (angleDelta.remainder(twoPi) < 0.0001 || (angleDelta - twoPi).abs() < 0.0001) {
      // Handle 360 degree annulus specially so there is no line going from inner to outer edge
      Path2D p = new Path2D();
      paths.add(p);
      if (_fill) {
        num cosStart = Math.cos(_startAngleRad);
        num sinStart = Math.sin(_startAngleRad);
        p.moveTo(_x + _innerRadius * cosStart, _y + _innerRadius * sinStart);
        p.arc(_x, _y, _innerRadius, _startAngleRad, _endAngleRad, false);
        p.lineTo(_x + _outerRadius * Math.cos(_endAngleRad), _y + _outerRadius * Math.sin(_endAngleRad));
        p.arc(_x, _y, _outerRadius, _endAngleRad, _startAngleRad, true);
        p.lineTo(_x + _innerRadius * cosStart, _y + _innerRadius * sinStart);
        p.closePath();

        // Fill only for this piece so no line!
        ctx.fill(p);
      }

      if (_stroke) {
        // Add two circles to draw the edges (stroke only!)
        ctx.beginPath();
        ctx.arc(_x, _y, _innerRadius, 0, twoPi, false);
        ctx.closePath();
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(_x, _y, _outerRadius, 0, twoPi, false);
        ctx.closePath();
        ctx.stroke();
      }
    } else {
      var x1 = _x + _innerRadius * Math.cos(_startAngleRad);
      var y1 = _y + _innerRadius * Math.sin(_startAngleRad);
      Path2D p = new Path2D();
      //ctx.beginPath();
      p.moveTo(x1, y1);
      p.arc(_x, _y, _innerRadius, _startAngleRad, _endAngleRad, false);
      p.lineTo(_x + _outerRadius * Math.cos(_endAngleRad), _y + _outerRadius * Math.sin(_endAngleRad));
      p.arc(_x, _y, _outerRadius, _endAngleRad, _startAngleRad, true);
      p.lineTo(x1, y1);
      p.closePath();
      paths.add(p);

      if (_fill) ctx.fill(p);
      if (_stroke) ctx.stroke(p);
    }
  }
}
