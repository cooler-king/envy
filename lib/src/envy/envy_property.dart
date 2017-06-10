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

  /// An optional property has an effective raw size of zero, deferring to other properties
  /// to drive the size of a property set.
  bool optional;

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

  /// An optional payload that may be used for things like identifying a property during debugging.
  dynamic payload;


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

  EnvyProperty(this.defaultValue, {this.optional: false});

  DataSource<T> get enter => _enter ?? DataSource.nullDataSource;

  void set enter(DataSource<T> dataSource) {
    _enter = dataSource;
  }

  DataSource<T> get update => _update ?? DataSource.nullDataSource;

  void set update(DataSource<T> dataSource) {
    _update = dataSource;
  }

  DataSource<T> get exit => _exit ?? DataSource.nullDataSource;

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

        print("_updateStartValues... adding value ${_value}");
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

    // Value may be String ("deadJim")
    dynamic val;

    for (_i = 0; _i < _size; _i++) {
        val = _update?.valueAt(_i) ?? (_enter?.valueAt(_i));

      if (val == null) val = defaultValue;

      // If the value (of a keyed property) is no longer available, use exit value
      if (val == dataNotAvailable) {
        val = _exit?.valueAt(_i);
        if (val == null || val == dataNotAvailable) {
          // No exit value, use first acceptable of update, enter or default
          val = _update?.valueAt(_i);
          if (val == null || val == dataNotAvailable) val = _enter?.valueAt(_i);
          if (val == null || val == dataNotAvailable) val = defaultValue;
        }
      }

      _value = val;

      // Debug
      assert(_value != dataNotAvailable);

      _targetValues.add(_value);
    }

    // Set target values for exiting nodes
    for (_i = _size; _i < _currentValues.length; _i++) {
      val = exit.valueAt(_i);
      if (val == null || val == dataNotAvailable) val = _currentValues[_i];

      _value = val;

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
    if (!finish) {
      for (_i = 0; _i < (finish ? _size : _targetValues.length); _i++) {
        _currentValues.add(interp.interpolate(_startValues[_i], _targetValues[_i], fraction));
      }
    } else {
      for (_i = 0; _i < (finish ? _size : _targetValues.length); _i++) {
        // For finish values, only include available update or enter data
        if ((_update?.valueAt(_i) ?? _enter?.valueAt(_i)) != dataNotAvailable) {
          _currentValues.add(interp.interpolate(_startValues[_i], _targetValues[_i], fraction));
        }
      }
    }
  }

  void _refreshDataSources() {
    _enter?.refresh();
    _update?.refresh();
    _exit?.refresh();
  }
}

class GenericProperty extends EnvyProperty<dynamic> {
  GenericProperty({dynamic defaultValue: 0, bool optional: false}) : super(defaultValue, optional: optional);
  EnvyInterpolator<dynamic> get defaultInterpolator => new BinaryInterpolator();
}

class NumberProperty extends EnvyProperty<num> {
  NumberProperty({num defaultValue: 0, bool optional: false}) : super(defaultValue, optional: optional);
  EnvyInterpolator<num> get defaultInterpolator => new NumberInterpolator();
}

class StringProperty extends EnvyProperty<String> {
  StringProperty({String defaultValue: "", bool optional: false}) : super(defaultValue, optional: optional);
  EnvyInterpolator<String> get defaultInterpolator => new BinaryInterpolator<String>();
}

class BooleanProperty extends EnvyProperty<bool> {
  BooleanProperty({bool defaultValue: false, bool optional: false}) : super(defaultValue, optional: optional);
  EnvyInterpolator<bool> get defaultInterpolator => new BooleanInterpolator();
}

class ColorProperty extends EnvyProperty<Color> {
  ColorProperty({Color defaultValue: Color.black, bool optional: false}) : super(Color.black, optional: optional);
  EnvyInterpolator<Color> get defaultInterpolator => new RgbaInterpolator();
}

class TextAlign2dProperty extends EnvyProperty<TextAlign2d> {
  TextAlign2dProperty({bool optional: false}) : super(TextAlign2d.START, optional: optional);
  EnvyInterpolator<TextAlign2d> get defaultInterpolator => new BinaryInterpolator<TextAlign2d>();
}

class TextBaseline2dProperty extends EnvyProperty<TextBaseline2d> {
  TextBaseline2dProperty({bool optional: false}) : super(TextBaseline2d.ALPHABETIC, optional: optional);
  EnvyInterpolator<TextBaseline2d> get defaultInterpolator => new BinaryInterpolator<TextBaseline2d>();
}

class LineCap2dProperty extends EnvyProperty<LineCap2d> {
  LineCap2dProperty({bool optional: false}) : super(LineCap2d.BUTT, optional: optional);
  EnvyInterpolator<LineCap2d> get defaultInterpolator => new BinaryInterpolator<LineCap2d>();
}

class LineJoin2dProperty extends EnvyProperty<LineJoin2d> {
  LineJoin2dProperty({bool optional: false}) : super(LineJoin2d.MITER, optional: optional);
  EnvyInterpolator<LineJoin2d> get defaultInterpolator => new BinaryInterpolator<LineJoin2d>();
}

class CompositeOperation2dProperty extends EnvyProperty<CompositeOperation2d> {
  CompositeOperation2dProperty({bool optional: false}) : super(CompositeOperation2d.SOURCE_OVER, optional: optional);
  EnvyInterpolator<CompositeOperation2d> get defaultInterpolator => new BinaryInterpolator<CompositeOperation2d>();
}

class DrawingStyle2dProperty extends EnvyProperty<DrawingStyle2d> {
  DrawingStyle2dProperty({bool optional: false}) : super(new DrawingStyle2d(), optional: optional);
  EnvyInterpolator<DrawingStyle2d> get defaultInterpolator => new DrawingStyle2dInterpolator();
}

class Anchor2dProperty extends EnvyProperty<Anchor2d> {
  Anchor2dProperty({bool optional: false}) : super(new Anchor2d(), optional: optional);
  EnvyInterpolator<Anchor2d> get defaultInterpolator => new Anchor2dInterpolator();
}

class AngleProperty extends EnvyProperty<Angle> {
  AngleProperty({bool optional: false}) : super(new Angle(rad: 0), optional: optional);
  EnvyInterpolator<Angle> get defaultInterpolator => new AngleInterpolator();
}

class PointProperty extends EnvyProperty<Math.Point> {
  PointProperty({bool optional: false}) : super(new Math.Point(0, 0), optional: optional);
  EnvyInterpolator<Point> get defaultInterpolator => new PointInterpolator();
}

class PointListProperty extends EnvyProperty<PointList> {
  PointListProperty({bool optional: false}) : super(new PointList(), optional: optional);
  EnvyInterpolator<PointList> get defaultInterpolator => new PointListInterpolator();
}

class NumberListProperty extends EnvyProperty<NumberList> {
  NumberListProperty({bool optional: false}) : super(new NumberList(), optional: optional);
  EnvyInterpolator<NumberList> get defaultInterpolator => new NumberListInterpolator();
}

class CssStyleProperty extends EnvyProperty<CssStyle> {
  CssStyleProperty({bool optional: false}) : super(new CssStyle(), optional: optional);
  EnvyInterpolator<CssStyle> get defaultInterpolator => new CssStyleInterpolator();
}

class FontProperty extends EnvyProperty<Font> {
  FontProperty({bool optional: false}) : super(new Font(), optional: optional);
  EnvyInterpolator<Font> get defaultInterpolator => new FontInterpolator();
}

class Vector2Property extends EnvyProperty<Vector2> {
  Vector2Property({bool optional: false}) : super(vec2zero, optional: optional);
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class Scale2Property extends EnvyProperty<Vector2> {
  Scale2Property({bool optional: false}) : super(vec2one, optional: optional);
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class Skew2Property extends EnvyProperty<Vector2> {
  Skew2Property({bool optional: false}) : super(vec2zero, optional: optional);
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class PathInterpolation2dProperty extends EnvyProperty<PathInterpolation2d> {
  PathInterpolation2dProperty({bool optional: false}) : super(PathInterpolation2d.LINEAR, optional: optional);
  EnvyInterpolator<PathInterpolation2d> get defaultInterpolator => new BinaryInterpolator<PathInterpolation2d>();
}

/// A generic EnvyProperty that exposes its internals.
///
/// This facilitates testing private methods and may have other potential uses
/// in situations where direct manipulation of values is desired.
///
class NakedProperty extends EnvyProperty<dynamic> {
  NakedProperty({dynamic defaultValue: 0}) : super(defaultValue);
  EnvyInterpolator<dynamic> get defaultInterpolator => new BinaryInterpolator();

  List get currentValues => _currentValues;
  List get startValues => _startValues;
  List get targetValues => _targetValues;

  void refreshDataSources() {
    refreshDataSources();
  }

  void preparePropertyForAnimation(int size) {
    _preparePropertyForAnimation(size);
  }

  void updateStartValues() {
    updateStartValues();
  }

  void updateTargetValues() {
    updateTargetValues();
  }
}
