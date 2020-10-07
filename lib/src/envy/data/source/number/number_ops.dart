import 'dart:math' show exp, max, log, pow, sqrt;
import 'number_source.dart';

/// Unary operations take a single number source.
abstract class UnaryOp extends NumberSource {
  /// Constructs a instance.
  UnaryOp(this.ns);

  /// The sole number source.
  NumberSource ns;

  @override
  int get rawSize => ns.rawSize;

  @override
  void refresh() {
    // Do nothing by default
  }
}

/// Binary operations take two number sources.
abstract class BinaryOp extends NumberSource {
  /// Constructs a instance.
  BinaryOp(this.ns1, this.ns2);

  /// The first number source.
  NumberSource ns1;

  /// The second number source.
  NumberSource ns2;

  @override
  int get rawSize => max(ns1.rawSize, ns2.rawSize);

  // No-op refresh
  @override
  void refresh() {
    // Do nothing by default
  }
}

/// Multiple operations take an arbitrary number of number sources.
abstract class MultipleOp extends NumberSource {
  /// Constructs a instance.
  MultipleOp(NumberSource num1, NumberSource num2) {
    _list..add(num1)..add(num2);
  }

  /// Constructs a instance from a list of number sources.
  MultipleOp.list(List<NumberSource> list) {
    _list.addAll(list);
  }

  final List<NumberSource> _list = <NumberSource>[];

  @override
  int get rawSize {
    int mx = 0;
    for (final NumberSource ns in _list) {
      mx = max(mx, ns.rawSize);
    }
    return mx;
  }

  // No-op refresh
  @override
  void refresh() {
    // Do nothing by default
  }
}

/// Supplies the negative of [ns].
class Neg extends UnaryOp {
  /// Constructs a instance.
  Neg(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => -ns.valueAt(index);
}

/// Supplies the absolute value of [ns].
class Abs extends UnaryOp {
  /// Constructs a instance.
  Abs(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => ns.valueAt(index).abs();
}

/// Supplies the least integer no smaller than [ns].
class Ceil extends UnaryOp {
  /// Constructs a instance.
  Ceil(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => ns.valueAt(index).ceil();
}

/// Supplies the greatest integer no greater than [ns].
class Floor extends UnaryOp {
  /// Constructs a instance.
  Floor(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => ns.valueAt(index).floor();
}

/// Supplies the the natural exponent, e, to the power of [ns].
class Exp extends UnaryOp {
  /// Constructs a instance.
  Exp(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => exp(ns.valueAt(index));
}

/// Supplies the the natural logarithm of [ns].
class Log extends UnaryOp {
  /// Constructs a instance.
  Log(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => log(ns.valueAt(index));
}

/// Supplies the integer closest to [ns].
/// Rounds away from zero in case of a tie (x.5).
class Round extends UnaryOp {
  /// Constructs a instance.
  Round(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => ns.valueAt(index).round();
}

/// Supplies the square root of [ns].
class Sqrt extends UnaryOp {
  /// Constructs a instance.
  Sqrt(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => sqrt(ns.valueAt(index));
}

/// Supplies the integer obtained by discarding any fractional digits from [ns].
class Truncate extends UnaryOp {
  /// Constructs a instance.
  Truncate(NumberSource ns) : super(ns);

  @override
  num valueAt(int index) => ns.valueAt(index).truncate();
}

/// Supplies the sum of an arbitrary number of numbers.
class Sum extends MultipleOp {
  /// Constructs a instance.
  Sum(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  /// Constructs a instance from a list of number sources.
  Sum.list(List<NumberSource> list) : super.list(list);

  @override
  num valueAt(int index) {
    num total = 0;
    for (final NumberSource ns in _list) {
      total += ns.valueAt(index);
    }
    return total;
  }
}

/// Supplies the value of [ns2] subtracted from [ns1].
class Diff extends BinaryOp {
  /// Constructs a instance.
  Diff(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  @override
  num valueAt(int index) => ns1.valueAt(index) - ns2.valueAt(index);
}

/// Supplies the product of an arbitrary number of numbers.
class Product extends MultipleOp {
  /// Constructs a instance.
  Product(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  /// Constructs a instance from a list of number sources.
  Product.list(List<NumberSource> list) : super.list(list);

  @override
  num valueAt(int index) {
    num total = 1;
    for (final NumberSource ns in _list) {
      total *= ns.valueAt(index);
    }
    return total;
  }
}

/// Supplies the value of [ns1] divided by [ns2].
class Quotient extends BinaryOp {
  /// Constructs a instance.
  Quotient(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  @override
  num valueAt(int index) => ns1.valueAt(index) / ns2.valueAt(index);
}

/// Supplies the remainder of the truncating division of [ns1] by [ns2].
class Remainder extends BinaryOp {
  /// Constructs a instance.
  Remainder(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  @override
  num valueAt(int index) => ns1.valueAt(index).remainder(ns2.valueAt(index));
}

/// Supplies the value of [ns1] raised to the power of [ns2].
///
class Pow extends BinaryOp {
  /// Constructs a instance.
  Pow(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  @override
  num valueAt(int index) => pow(ns1.valueAt(index), ns2.valueAt(index));
}

/// Supplies the minimum value found in an arbitrary set of numbers.
class Min extends MultipleOp {
  /// Constructs a instance.
  Min(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  /// Constructs a instance from a list of number sources.
  Min.list(List<NumberSource> list) : super.list(list);

  @override
  num valueAt(int index) {
    num min = double.infinity;
    for (final NumberSource ns in _list) {
      final num value = ns.valueAt(index);
      if (value < min) min = value;
    }
    return min;
  }
}

/// Supplies the maximum value found in an arbitrary set of numbers.
class Max extends MultipleOp {
  /// Constructs a instance.
  Max(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  /// Constructs a instance from a list of number sources.
  Max.list(List<NumberSource> list) : super.list(list);

  @override
  num valueAt(int index) {
    num max = double.negativeInfinity;
    for (final NumberSource ns in _list) {
      final num value = ns.valueAt(index);
      if (value > max) max = value;
    }
    return max;
  }
}

/// Supplies the result of the Euclidean modulo (ns1 % ns2) operator.
class Modulo extends BinaryOp {
  /// Constructs a instance.
  Modulo(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  @override
  num valueAt(int index) => ns1.valueAt(index) % ns2.valueAt(index);
}

/// Supplies the result of the truncating division (ns1 ~/ ns2) operator.
class TruncDiv extends BinaryOp {
  /// Constructs a instance.
  TruncDiv(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  @override
  num valueAt(int index) => ns1.valueAt(index) ~/ ns2.valueAt(index);
}

/// Supplies the result of clamping [ns1] to the range defined
/// by [ns2] (lower limit) and [ns3] (upper limit).
class Clamp extends NumberSource {
  /// Constructs a instance from three number sources.
  Clamp(this.ns1, this.ns2, this.ns3);

  /// The value to be clamped.
  NumberSource ns1;

  /// The lower limit.
  NumberSource ns2;

  /// The upper limit.
  NumberSource ns3;

  @override
  num valueAt(int index) => ns1.valueAt(index).clamp(ns2.valueAt(index), ns3.valueAt(index));

  @override
  int get rawSize => max(ns1.rawSize, max(ns2.rawSize, ns3.rawSize));

  // No-op refresh.
  @override
  void refresh() {}
}
