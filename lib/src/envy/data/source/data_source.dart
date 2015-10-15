part of envy;

/// The base class for all data source classes.
///
/// Data sources provide an array of values of a specific type.
///
abstract class DataSource<T> {
  //final List<T> values;

  /// How to fill in missing values at end of array
  Extrapolation extrapolation;

  static final NullDataSource nullDataSource = new NullDataSource();

  /// DataSources must provide values as a function of index
  T valueAt(int index);

  /// The "preferred" array size of the data source
  int get rawSize;

  /// Refesh values (called when a dynamic node is preparing for animation)
  void refresh();
}

/// Constant data sources implement an array of values of a specific type.
///
abstract class ArrayDataSource<T> extends DataSource<T> {
  final List<T> values;

  /// Constructs a data source with an empty growable list.
  ArrayDataSource() : values = [];

  /// Constructs a data source with a custom values list.
  ArrayDataSource._internal(this.values);

  /// The unextrapolated size of the values list
  int get rawSize => values.length;

  T valueAt(int i) =>
      (i < values.length) ? values[i] : (extrapolation?.valueAt(i, values) ?? (values.isNotEmpty ? values.last : null));
}

class NullDataSource extends ArrayDataSource<dynamic> {
  /// Fixed, empty list
  static final List emptyList = new List(0);

  // construct with a fixed-size empty list
  NullDataSource() : super._internal(emptyList);

  /// No-op refresh
  void refresh() {}
}
