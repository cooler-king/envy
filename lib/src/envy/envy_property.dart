import 'dart:math' show max, Point;
import 'package:quantity/quantity.dart' show Angle;
import 'package:vector_math/vector_math.dart';
import 'animation/animation_group.dart';
import 'color/color.dart';
import 'css/css_style.dart';
import 'data/source/data_source.dart';
import 'data/source/extrapolate/extrapolation.dart';
import 'graphic/twod/anchor2d.dart';
import 'graphic/twod/drawing_style2d.dart';
import 'graphic/twod/enum/composite_operation2d.dart';
import 'graphic/twod/enum/line_cap2d.dart';
import 'graphic/twod/enum/line_join2d.dart';
import 'graphic/twod/enum/path_interpolation2d.dart';
import 'graphic/twod/enum/text_align2d.dart';
import 'graphic/twod/enum/text_baseline2d.dart';
import 'graphic/twod/number_list.dart';
import 'graphic/twod/point_list.dart';
import 'interpolate/anchor2d_interpolator.dart';
import 'interpolate/angle_interpolator.dart';
import 'interpolate/binary_interpolator.dart';
import 'interpolate/color_interpolator.dart';
import 'interpolate/css_style_interpolator.dart';
import 'interpolate/drawing_style2d_interpolator.dart';
import 'interpolate/envy_interpolator.dart';
import 'interpolate/font_interpolator.dart';
import 'interpolate/number_interpolator.dart';
import 'interpolate/number_list_interpolator.dart';
import 'interpolate/point_interpolator.dart';
import 'interpolate/point_list_interpolator.dart';
import 'interpolate/vector2_interpolator.dart';
import 'multiplicity/multiplicity.dart';
import 'text/font.dart';

final Vector2 vec2zero = new Vector2(0.0, 0.0);
final Vector2 vec2one = new Vector2(1.0, 1.0);

/// The base class for all Envy properties.
abstract class EnvyProperty<T> {
  int _size = 0;

  /// An optional property has an effective raw size of zero, deferring to other properties
  /// to drive the size of a property set.
  bool optional;

  final List<T> _startValues = <T>[];
  final List<T> _currentValues = <T>[];
  final List<T> _targetValues = <T>[];

  final T defaultValue;

  DataSource<T> _enter;
  DataSource<T> _update;
  DataSource<T> _exit;

  // For efficiency
  int _i = 0;
  T _value;
  NullDataSource<T> nullDataSource = new NullDataSource<T>();
  //T dataNotAvailable = new DataNotAvailable<T>().token;

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
  Extrapolation<T> extrapolation;

  //TODO category class?
  /// Support optional grouping of properties in UI
  String category;

  //TODO can advanced just be a category?
  bool advanced = false;

  // optional override of alpha for specific property
  AnimationGroup animationOverride;

  EnvyProperty(this.defaultValue, {this.optional = false});

  DataSource<T> get enter => _enter ?? nullDataSource;

  set enter(DataSource<T> dataSource) {
    _enter = dataSource;
  }

  DataSource<T> get update => _update ?? nullDataSource;

  set update(DataSource<T> dataSource) {
    _update = dataSource;
  }

  DataSource<T> get exit => _exit ?? nullDataSource;

  set exit(DataSource<T> dataSource) {
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
  int get rawSize => max(enter.rawSize, update.rawSize);

  EnvyInterpolator<T> get interpolator => _interpolator ??= defaultInterpolator;

  set interpolator(EnvyInterpolator<T> interp) {
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
  void preparePropertyForAnimation(int size) {
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
    _startValues
      ..clear()
      ..addAll(_currentValues);

    if (_size > _currentValues.length) {
      // Size greater than number of current values... some will be entering
      for (_i = _currentValues.length; _i < _size; _i++) {
        _value = _enter == null || _enter.dataNotAvailableAt(_i) ? null : _enter.valueAt(_i);
        _value = _value ?? (_update == null || _update.dataNotAvailableAt(_i) ? null : _update.valueAt(_i));
        _value = _value ?? defaultValue;

        //print('_updateStartValues... adding value ${_value}');
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

    // Value may be String ('deadJim')
    T val;

    for (_i = 0; _i < _size; _i++) {
      val = _update?.valueAt(_i) ?? _enter?.valueAt(_i);

      if (val == null) {
        // If the value (of a keyed property) is no longer available, use exit value.
        final bool dataNotAvailable =
            (_update?.dataNotAvailableAt(_i) ?? false) || (_enter?.dataNotAvailableAt(_i) ?? false);
        if (dataNotAvailable) {
          val = _exit == null || _exit.dataNotAvailableAt(_i) ? null : _exit.valueAt(_i);
          val = val ?? _update?.valueAt(_i) ?? _enter?.valueAt(_i) ?? defaultValue;
        } else {
          // Regular null value means use default value.
          val = defaultValue;
        }
      }
/*
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
*/
      _value = val;

      // Debug
      //assert(_value != dataNotAvailable);

      _targetValues.add(_value);
    }

    // Set target values for exiting nodes
    for (_i = _size; _i < _currentValues.length; _i++) {
      val = _exit == null || _exit.dataNotAvailableAt(_i) ? null : _exit.valueAt(_i);
      _value = val ?? _currentValues[_i];

      // Debug
      //assert(_value != dataNotAvailable);

      _targetValues.add(_value);
    }
  }

  /// Calculate the current values based on the start and target values,
  /// the timing [fraction] and the interpolator.
  ///
  void updateValues(num fraction, {bool finish = false}) {
    final EnvyInterpolator<T> interp = interpolator;
    _currentValues.clear();
    if (!finish) {
      for (_i = 0; _i < (finish ? _size : _targetValues.length); _i++) {
        _currentValues.add(interp.interpolate(_startValues[_i], _targetValues[_i], fraction));
      }
    } else {
      for (_i = 0; _i < (finish ? _size : _targetValues.length); _i++) {
        // For finish values, only include available update or enter data
        T val = _update == null || _update.dataNotAvailableAt(_i) ? null : update?.valueAt(_i);
        val = val ?? (_enter == null || _enter.dataNotAvailableAt(_i) ? null : _enter.valueAt(_i));
        if (val != null) {
          _currentValues.add(interp.interpolate(_startValues[_i], _targetValues[_i], fraction));
        }
      }
    }
  }

  void refreshDataSources() {
    _enter?.refresh();
    _update?.refresh();
    _exit?.refresh();
  }
}

class GenericProperty extends EnvyProperty<dynamic> {
  GenericProperty({dynamic defaultValue = 0, bool optional = false}) : super(defaultValue, optional: optional);

  @override
  EnvyInterpolator<dynamic> get defaultInterpolator => new BinaryInterpolator<dynamic>();
}

class NumberProperty extends EnvyProperty<num> {
  NumberProperty({num defaultValue = 0, bool optional = false}) : super(defaultValue, optional: optional);

  @override
  EnvyInterpolator<num> get defaultInterpolator => new NumberInterpolator();
}

class StringProperty extends EnvyProperty<String> {
  StringProperty({String defaultValue = '', bool optional = false}) : super(defaultValue, optional: optional);

  @override
  EnvyInterpolator<String> get defaultInterpolator => new BinaryInterpolator<String>();
}

class BooleanProperty extends EnvyProperty<bool> {
  BooleanProperty({bool defaultValue = false, bool optional = false}) : super(defaultValue, optional: optional);

  @override
  EnvyInterpolator<bool> get defaultInterpolator => new BooleanInterpolator();
}

class ColorProperty extends EnvyProperty<Color> {
  ColorProperty({Color defaultValue = Color.black, bool optional = false}) : super(defaultValue, optional: optional);

  @override
  EnvyInterpolator<Color> get defaultInterpolator => new RgbaInterpolator();
}

class TextAlign2dProperty extends EnvyProperty<TextAlign2d> {
  TextAlign2dProperty({bool optional = false}) : super(TextAlign2d.start, optional: optional);

  @override
  EnvyInterpolator<TextAlign2d> get defaultInterpolator => new BinaryInterpolator<TextAlign2d>();
}

class TextBaseline2dProperty extends EnvyProperty<TextBaseline2d> {
  TextBaseline2dProperty({bool optional = false}) : super(TextBaseline2d.alphabetic, optional: optional);

  @override
  EnvyInterpolator<TextBaseline2d> get defaultInterpolator => new BinaryInterpolator<TextBaseline2d>();
}

class LineCap2dProperty extends EnvyProperty<LineCap2d> {
  LineCap2dProperty({bool optional = false}) : super(LineCap2d.butt, optional: optional);

  @override
  EnvyInterpolator<LineCap2d> get defaultInterpolator => new BinaryInterpolator<LineCap2d>();
}

class LineJoin2dProperty extends EnvyProperty<LineJoin2d> {
  LineJoin2dProperty({bool optional = false}) : super(LineJoin2d.miter, optional: optional);

  @override
  EnvyInterpolator<LineJoin2d> get defaultInterpolator => new BinaryInterpolator<LineJoin2d>();
}

class CompositeOperation2dProperty extends EnvyProperty<CompositeOperation2d> {
  CompositeOperation2dProperty({bool optional = false}) : super(CompositeOperation2d.sourceOver, optional: optional);

  @override
  EnvyInterpolator<CompositeOperation2d> get defaultInterpolator => new BinaryInterpolator<CompositeOperation2d>();
}

class DrawingStyle2dProperty extends EnvyProperty<DrawingStyle2d> {
  DrawingStyle2dProperty({bool optional = false}) : super(new DrawingStyle2d(), optional: optional);

  @override
  EnvyInterpolator<DrawingStyle2d> get defaultInterpolator => new DrawingStyle2dInterpolator();
}

class Anchor2dProperty extends EnvyProperty<Anchor2d> {
  Anchor2dProperty({bool optional = false}) : super(new Anchor2d(), optional: optional);

  @override
  EnvyInterpolator<Anchor2d> get defaultInterpolator => new Anchor2dInterpolator();
}

class AngleProperty extends EnvyProperty<Angle> {
  AngleProperty({bool optional = false}) : super(new Angle(rad: 0), optional: optional);

  @override
  EnvyInterpolator<Angle> get defaultInterpolator => new AngleInterpolator();
}

class PointProperty extends EnvyProperty<Point<num>> {
  PointProperty({bool optional = false}) : super(const Point<num>(0, 0), optional: optional);

  @override
  EnvyInterpolator<Point<num>> get defaultInterpolator => new PointInterpolator();
}

class PointListProperty extends EnvyProperty<PointList> {
  PointListProperty({bool optional = false}) : super(new PointList(), optional: optional);

  @override
  EnvyInterpolator<PointList> get defaultInterpolator => new PointListInterpolator();
}

class NumberListProperty extends EnvyProperty<NumberList> {
  NumberListProperty({bool optional = false}) : super(new NumberList(), optional: optional);

  @override
  EnvyInterpolator<NumberList> get defaultInterpolator => new NumberListInterpolator();
}

class CssStyleProperty extends EnvyProperty<CssStyle> {
  CssStyleProperty({bool optional = false}) : super(new CssStyle(), optional: optional);

  @override
  EnvyInterpolator<CssStyle> get defaultInterpolator => new CssStyleInterpolator();
}

class FontProperty extends EnvyProperty<Font> {
  FontProperty({bool optional = false}) : super(new Font(), optional: optional);

  @override
  EnvyInterpolator<Font> get defaultInterpolator => new FontInterpolator();
}

class Vector2Property extends EnvyProperty<Vector2> {
  Vector2Property({bool optional = false}) : super(vec2zero, optional: optional);

  @override
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class Scale2Property extends EnvyProperty<Vector2> {
  Scale2Property({bool optional = false}) : super(vec2one, optional: optional);

  @override
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class Skew2Property extends EnvyProperty<Vector2> {
  Skew2Property({bool optional = false}) : super(vec2zero, optional: optional);

  @override
  EnvyInterpolator<Vector2> get defaultInterpolator => new Vector2Interpolator();
}

class PathInterpolation2dProperty extends EnvyProperty<PathInterpolation2d> {
  PathInterpolation2dProperty({bool optional = false}) : super(PathInterpolation2d.linear, optional: optional);

  @override
  EnvyInterpolator<PathInterpolation2d> get defaultInterpolator => new BinaryInterpolator<PathInterpolation2d>();
}

/// A generic EnvyProperty that exposes its internals.
///
/// This facilitates testing private methods and may have other potential uses
/// in situations where direct manipulation of values is desired.
///
class NakedProperty extends EnvyProperty<dynamic> {
  NakedProperty({dynamic defaultValue = 0}) : super(defaultValue);

  @override
  EnvyInterpolator<dynamic> get defaultInterpolator => new BinaryInterpolator<dynamic>();

  List<dynamic> get currentValues => _currentValues;
  List<dynamic> get startValues => _startValues;
  List<dynamic> get targetValues => _targetValues;
}
