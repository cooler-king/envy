part of envy;

/// Unary operations take a single number source.
///
abstract class UnaryOp extends NumberSource {
  NumberSource ns;

  UnaryOp(this.ns);

  int get rawSize => ns.rawSize;
}

/// Binary operations take two number sources.
///
abstract class BinaryOp extends NumberSource {
  NumberSource ns1;
  NumberSource ns2;

  BinaryOp(this.ns1, this.ns2);

  int get rawSize => Math.max(ns1.rawSize, ns2.rawSize);

  // No-op refresh
  void refresh();
}


/// Multiple operations take an arbitrary number of number sources.
///
abstract class MultipleOp extends NumberSource {
  final List<NumberSource> _list = [];

  MultipleOp(NumberSource num1, NumberSource num2) {
    _list.add(num1);
    _list.add(num2);
  }

  MultipleOp.list(List<NumberSource> list) {
    _list.addAll(list);
  }

  int get rawSize {
    int max = 0;
    for (var ns in _list) {
      max = Math.max(max, ns.rawSize);
    }
  }

  // No-op refresh
  void refresh() {
    // Do nothing by default
  }
}

/// Supplies the negative of [ns].
///
class Neg extends UnaryOp {

  Neg(NumberSource ns) : super(ns);

  num valueAt(int i) => -(ns.valueAt(i));
}

/// Supplies the absolute value of [ns].
///
class Abs extends UnaryOp {

  Abs(NumberSource ns) : super(ns);

  num valueAt(int i) => ns.valueAt(i).abs();
}

/// Supplies the least integer no smaller than [ns].
///
class Ceil extends UnaryOp {

  Ceil(NumberSource ns) : super(ns);

  num valueAt(int i) => ns.valueAt(i).ceil();
}

/// Supplies the greatest integer no greater than [ns].
///
class Floor extends UnaryOp {

  Floor(NumberSource ns) : super(ns);

  num valueAt(int i) => ns.valueAt(i).floor();
}

/// Supplies the the natural exponent, e, to the power of [ns].
///
class Exp extends UnaryOp {

  Exp(NumberSource ns) : super(ns);

  num valueAt(int i) => Math.exp(ns.valueAt(i));
}

/// Supplies the the natural logarithm of [ns].
///
class Log extends UnaryOp {

  Log(NumberSource ns) : super(ns);

  num valueAt(int i) => Math.log(ns.valueAt(i));
}

/// Supplies the integer closest to [ns].
///
/// Rounds away from zero in case of a tie (x.5).
///
class Round extends UnaryOp {

  Round(NumberSource ns) : super(ns);

  num valueAt(int i) => ns.valueAt(i).round();
}

/// Supplies the square root of [ns].
///
class Sqrt extends UnaryOp {

  Sqrt(NumberSource ns) : super(ns);

  num valueAt(int i) => Math.sqrt(ns.valueAt(i));
}

/// Supplies the integer obtained by discarding any fractional digits from [ns].
///
class Truncate extends UnaryOp {

  Truncate(NumberSource ns) : super(ns);

  num valueAt(int i) => ns.valueAt(i).truncate();
}

/// Supplies the sum of an arbitrary number of numbers.
///
class Sum extends MultipleOp {

  Sum(NumberSource ns1, NumberSource ns2): super(ns1, ns2);

  Sum.list(List<NumberSource> list) : super.list(list);

  num valueAt(int i) {
    num total = 0;
    for (var ns in _list) {
      total += ns.valueAt(i);
    }
    return total;
  }
}

/// Supplies the value of [ns2] subtracted from [ns1].
///
class Diff extends BinaryOp {

  Diff(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  num valueAt(int i) => ns1.valueAt(i) - ns2.valueAt(i);
}

/// Supplies the product of an arbitrary number of numbers.
///
class Product extends MultipleOp {

  Product(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  Product.list(List<NumberSource> list) : super.list(list);

  num valueAt(int i) {
    num total = 1;
    for (var ns in _list) {
      total *= ns.valueAt(i);
    }
    return total;
  }
}

/// Supplies the value of [ns1] divided by [ns2].
///
class Quotient extends BinaryOp {

  Quotient(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  num valueAt(int i) => ns1.valueAt(i) / ns2.valueAt(i);
}

/// Supplies the remainder of the truncating division of [ns1] by [ns2].
///
class Remainder extends BinaryOp {

  Remainder(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  num valueAt(int i) => ns1.valueAt(i).remainder(ns2.valueAt(i));
}

/// Supplies the value of [ns1] raised to the power of [ns2].
///
class Pow extends BinaryOp {

  Pow(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  num valueAt(int i) => Math.pow(ns1.valueAt(i), ns2.valueAt(i));
}

/// Supplies the minimum value found in an arbitrary set of numbers.
///
class Min extends MultipleOp {

  Min(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  Min.list(List<NumberSource> list) : super.list(list);

  num valueAt(int i) {
    num min = double.INFINITY;
    for (var ns in _list) {
      num value = ns.valueAt(i);
      if(value < min) min = value;
    }
    return min;
  }
}

/// Supplies the maximum value found in an arbitrary set of numbers.
///
class Max extends MultipleOp {

  Max(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  Max.list(List<NumberSource> list) : super.list(list);

  num valueAt(int i) {
    num max = double.NEGATIVE_INFINITY;
    for (var ns in _list) {
      num value = ns.valueAt(i);
      if(value > max) max = value;
    }
    return max;
  }
}

/// Supplies the result of the Euclidean modulo (ns1 % ns2) operator.
///
class Modulo extends BinaryOp {

  Modulo(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  num valueAt(int i) => ns1.valueAt(i) % ns2.valueAt(i);
}

/// Supplies the result of the truncating division (ns1 ~/ ns2) operator.
///
class TruncDiv extends BinaryOp {

  TruncDiv(NumberSource ns1, NumberSource ns2) : super(ns1, ns2);

  num valueAt(int i) => ns1.valueAt(i) ~/ ns2.valueAt(i);
}


/// Supplies the result of clamping [ns1] to the range defined
/// by [ns2] (lower limit) and [ns3] (upper limit).
///
class Clamp extends NumberSource {
  NumberSource ns1;
  NumberSource ns2;
  NumberSource ns3;

  Clamp(this.ns1, this.ns2, this.ns3);

  num valueAt(int i) => ns1.valueAt(i).clamp(ns2.valueAt(i), ns3.valueAt(i));

  int get rawSize => Math.max(ns1.rawSize, Math.max(ns2.rawSize, ns3.rawSize));

  // No-op refresh
  void refresh() {}

}
