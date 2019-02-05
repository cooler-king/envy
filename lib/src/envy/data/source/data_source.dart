import '../data_accessor.dart';
import 'extrapolate/extrapolation.dart';

/// The base class for all data source classes.
///
/// Data sources provide an array of values of a specific type.
///
abstract class DataSource<T> {
  //final List<T> values;

  /// How to fill in missing values at end of array
  Extrapolation<T> extrapolation;

  /// DataSources must provide values as a function of index
  T valueAt(int index);

  /// The "preferred" array size of the data source
  int get rawSize;

  /// Used to indicate data not available while preserving type semantics.
  //T dataNotAvailable = null;
  //TODO accessor here?
  DataAccessor accessor;

  /// Refresh values (called when a dynamic node is preparing for animation)
  void refresh();

  bool dataNotAvailableAt(int index) => accessor?.dataUnavailableIndices?.contains(index) ?? false;
}

/// Constant data sources implement an array of values of a specific type.
///
abstract class ArrayDataSource<T> extends DataSource<T> {
  /// Constructs a data source with an empty growable list.
  ArrayDataSource() : values = <T>[];

  /// Constructs a data source with a custom values list.
  ArrayDataSource._internal(this.values);

  final List<T> values;

  /// The unextrapolated size of the values list.
  @override
  int get rawSize => values.length;

  /// dynamic return type to support dataNotAvailable.
  @override
  T valueAt(int i) =>
      (i < values.length) ? values[i] : (extrapolation?.valueAt(i, values) ?? (values.isNotEmpty ? values.last : null));
}

class NullDataSource<T> extends ArrayDataSource<T> {
  factory NullDataSource() {
    if (!_perType.containsKey(T)) _perType[T] = new NullDataSource<T>._internal();
    return _perType[T] as NullDataSource<T>;
  }

  // construct with a fixed-size empty list
  NullDataSource._internal() : super._internal(<T>[]);

  // For efficiency.
  static final Map<Type, NullDataSource<dynamic>> _perType = <Type, NullDataSource<dynamic>>{};

  /// No-op refresh
  @override
  void refresh() {}
}

/*
/// These tokens are used to indicate data not available while preserving type semantics.
final Map<Type, Object> _dnaTokens = new Map<Type, Object>();

/// Retrieve the "data not available" token for the specified type.
///
/// A token that indicates a position in the array for which there is no data
/// (needed for keyed property support).
//T dataNotAvailable(Type t) => null as T;

Object dataNotAvailable(Type t) {
  if (!_dnaTokens.containsKey(t)) _dnaTokens[t] = null as t;
  return _dnaTokens[t];
}
*/
