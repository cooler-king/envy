part of envy;

/// A value that indicates a position in the array for which there is no data
/// (needed for keyed property support)
const String dataNotAvailable = "deadJim";

final Vector2 vec2zero = new Vector2(0.0, 0.0);
final Vector2 vec2one = new Vector2(1.0, 1.0);

/// The base class for all Envy properties.
///
abstract class EnvyProperty<T> {
  int _size = 0;

  final List<T> _startValues = [];
  final List<T> _currentValues = [];
  final List<T> _targetValues = [];

  final T defaultValue;

  DataSource<T> _enter;
  DataSource<T> _update;
  DataSource<T> _exit;

  // For efficiency
  int _i = 0;
  T _value;

  EnvyInterpolator<T> _interpolator;

  ///  Control over property array length.
  ///
  ///  DataSources may contribute arrays of various lengths,
  ///  but the property has final say over the array length.
  ///
  Multiplicity multiplicity;

  /// The extrapolation that is applied if the data source does not have one
  Extrapolation extrapolation;

  //TODO category class?
  /// Support optional grouping of properties in UI
  String category;

  //TODO can advanced just be a category?
  bool advanced = false;

  // optional override of alpha for specific property
  AnimationGroup animationOverride;

  EnvyProperty(this.defaultValue);

  DataSource<T> get enter => _enter != null ? _enter : DataSource.nullDataSource;

  void set enter(DataSource<T> dataSource) {
    _enter = dataSource;
  }

  DataSource<T> get update => _update != null ? _update : DataSource.nullDataSource;

  void set update(DataSource<T> dataSource) {
    _update = dataSource;
  }

  DataSource<T> get exit => _exit != null ? _exit : DataSource.nullDataSource;

  void set exit(DataSource<T> dataSource) {
    _exit = dataSource;
  }

  /// Get the current property value at index [i].
  ///
  T valueAt(int i) => (i < _currentValues.length) ? _currentValues[i] : defaultValue;

  /// The raw size of an Envy property is the maximum unextrapolated size of the
  /// enter and update DataSource values.
  ///
  /// Note that [exit] Data Source values do not affect the raw size.
  ///
  int get rawSize => Math.max(enter.rawSize, update.rawSize);

  EnvyInterpolator<T> get interpolator {
    if (_interpolator == null) _interpolator = defaultInterpolator;
    return _interpolator;
  }

  void set interpolator(EnvyInterpolator<T> interp) {
    _interpolator = interp;
  }

  /// Subclasses must provide a default interpolator.
  ///
  EnvyInterpolator<T> get defaultInterpolator;

  /// Prepares for an animation cycle by updating the start and target
  /// values for the property, where [size] is the length of the property
  /// array at the end of the cycle.
  ///
  /// Note that the number of start and target values may be larger if
  /// the property array is shrinking and some things are exiting.
  ///
  /// Before the start and target values are set, each data source is given a
  /// chance to refresh its values.
  ///
  void _preparePropertyForAnimation(int size) {
    // Store size
    _size = size;

    _updateStartValues();
    _updateTargetValues();
  }

  /// The start value for a given index will be the previous current value
  /// at that index or the enter value for that index where a previous current value
  /// is not available.
  ///
  void _updateStartValues() {
    //TODO make more efficient w/ replace?
    _startValues.clear();
    _startValues.addAll(_currentValues);

    if (_size > _currentValues.length) {
      // Size greater than number of current values... some will be entering
      for (_i = _currentValues.length; _i < _size; _i++) {
        _value = enter?.valueAt(_i);
        if (_value == null || _value == dataNotAvailable) _value = _update?.valueAt(_i);
        if (_value == null || _value == dataNotAvailable) _value = defaultValue;

        // Debug
        assert(_value != dataNotAvailable);

        _startValues.add(_value);
      }
    }
  }

  /// The target value for a given index will be the update value,
  /// enter value or default value (whichever is found first)
  /// at that index or the exit value for indices greater than the
  /// new size (up to the number of current values).
  ///
  void _updateTargetValues() {
    _targetValues.clear();
    for (_i = 0; _i < _size; _i++) {
      _value = _update?.valueAt(_i) ?? (_enter?.valueAt(_i));
      if (_value == null) _value = defaultValue;

      // If the value (of a keyed property) is no longer available, use exit value
      if (_value == dataNotAvailable) {
        _value = _exit?.valueAt(_i);
        if (_value == null || _value == dataNotAvailable) {
          // No exit value, use first acceptable of update, enter or default
          _value = _update?.valueAt(_i);
          if (_value == null || _value == dataNotAvailable) _value = _enter?.valueAt(_i);
          if (_value == null || _value == dataNotAvailable) _value = defaultValue;
        }
      }

      // Debug
      assert(_value != dataNotAvailable);

      _targetValues.add(_value);
    }

    // Set target values for exiting nodes
    for (_i = _size; _i < _currentValues.length; _i++) {
      _value = exit.valueAt(_i);
      if (_value == null || _value == dataNotAvailable) _value = _currentValues[_i];

      // Debug
      assert(_value != dataNotAvailable);

      _targetValues.add(_value);
    }
  }

  /// Calculate the current values based on the start and target values,
  /// the timing [fraction] and the interpolator.
  ///
  void updateValues(num fraction, {bool finish: false}) {
    EnvyInterpolator<T> interp = interpolator;
    _currentValues.clear();
    for (_i = 0; _i < (finish ? _size : _targetValues.length); _i++) {
      _currentValues.add(interp.interpolate(_startValues[_i], _targetValues[_i], fraction));
    }
  }

  void _refreshDataSources() {
    if (_enter != null) _enter.refresh();
    if (_update != null) _update.refresh();
    if (_exit != null) _exit.refresh();
  }
}

class GenericProperty extends EnvyProperty<dynamic> {
  GenericProperty({num defaultValue: 0}) : super(defaultValue);
  EnvyInterpolator<num> get defaultInterpolator => new BinaryInterpolator();
}

class NumberProperty extends EnvyProperty<num> {
  NumberProperty({num defaultValue: 0}) : super(defaultValue);
  EnvyInterpolator<num> get defaultInterpolator => new NumberInterpolator();
}

class StringProperty extends EnvyProperty<String> {
  StringProperty({String defaultValue: ""}) : super(defaultValue);
  EnvyInterpolator<String> get defaultInterpolator => new BinaryInterpolator<String>();
}

class BooleanProperty extends EnvyProperty<bool> {
  BooleanProperty({bool defaultValue: false}) : super(defaultValue);
  EnvyInterpolator<bool> get defaultInterpolator => new BooleanInterpolator();
}

class ColorProperty extends EnvyProperty<Color> {
  ColorProperty({Color defaultValue: Color.black}) : super(Color.black);
  EnvyInterpolator<Color> get defaultInterpolator => new RgbaInterpolator();
}

class TextAlign2dProperty extends EnvyProperty<TextAlign2d> {
  TextAlign2dProperty() : super(TextAlign2d.START);
  EnvyInterpolator<TextAlign2d> get defaultInterpolator => new BinaryInterpolator<TextAlign2d>();
}

class TextBaseline2dProperty extends EnvyProperty<TextBaseline2d> {
  TextBaseline2dProperty() : super(TextBaseline2d.ALPHABETIC);
  EnvyInterpolator<TextBaseline2d> get defaultInterpolator => new BinaryInterpolator<TextBaseline2d>();
}

class LineCap2dProperty extends EnvyProperty<LineCap2d> {
  LineCap2dProperty() : super(LineCap2d.BUTT);
  EnvyInterpolator<LineCap2d> get defaultInterpolator => new BinaryInterpolator<LineCap2d>();
}

class LineJoin2dProperty extends EnvyProperty<LineJoin2d> {
  LineJoin2dProperty() : super(LineJoin2d.MITER);
  EnvyInterpolator<LineJoin2d> get defaultInterpolator => new BinaryInterpolator<LineJoin2d>();
}

class CompositeOperation2dProperty extends EnvyProperty<CompositeOperation2d> {
  CompositeOperation2dProperty() : super(CompositeOperation2d.SOURCE_OVER);
  EnvyInterpolator<CompositeOperation2d> get defaultInterpolator => new BinaryInterpolator<CompositeOperation2d>();
}

class DrawingStyle2dProperty extends EnvyProperty<DrawingStyle2d> {
  DrawingStyle2dProperty() : super(new DrawingStyle2d());
  EnvyInterpolator<DrawingStyle2d> get defaultInterpolator => new DrawingStyle2dInterpolator();
}

class Anchor2dProperty extends EnvyProperty<Anchor2d> {
  Anchor2dProperty() : super(new Anchor2d());
  EnvyInterpolator<Anchor2d> get defaultInterpolator => new Anchor2dInterpolator();
}

class AngleProperty extends EnvyProperty<Angle> {
  AngleProperty() : super(new Angle(rad: 0));
  EnvyInterpolator<Angle> get defaultInterpolator => new AngleInterpolator();
}

class PointProperty extends EnvyProperty<Math.Point> {
  PointProperty() : super(new Math.Point(0, 0));
  EnvyInterpolator<Point> get defaultInterpolator => new PointInterpolator();
}

class PointListProperty extends EnvyProperty<PointList> {
  PointListProperty() : super(new PointList());
  EnvyInterpolator<PointList> get defaultInterpolator => new PointListInterpolator();
}

class CssStyleProperty extends EnvyProperty<CssStyle> {
  CssStyleProperty() : super(new CssStyle());
  EnvyInterpolator<CssStyle> get defaultInterpolator => new CssStyleInterpolator();
}

class FontProperty extends EnvyProperty<Font> {
  FontProperty() : super(new Font());
  EnvyInterpolator<Font> get defaultInterpolator => new FontInterpolator();
}

class Vector2Property extends EnvyProperty<Vector2> {
  Vector2Property() : super(vec2zero);
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class Scale2Property extends EnvyProperty<Vector2> {
  Scale2Property() : super(vec2one);
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class Skew2Property extends EnvyProperty<Vector2> {
  Skew2Property() : super(vec2zero);
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class PathInterpolation2dProperty extends EnvyProperty<PathInterpolation2d> {
  PathInterpolation2dProperty() : super(PathInterpolation2d.LINEAR);
  EnvyInterpolator<PathInterpolation2d> get defaultInterpolator => new BinaryInterpolator<PathInterpolation2d>();
}
