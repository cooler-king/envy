import 'dart:math' show min;

// ignore: one_member_abstracts
abstract class TimingFunction {
  /// Convert a value between 0-1 (inclusive) to another
  /// value between 0-1 (inclusive) according to some algorithm.
  num output(num input);
}

class LinearFunction extends TimingFunction {
  factory LinearFunction() => _instance ?? (new LinearFunction._internal());

  LinearFunction._internal() {
    _instance = this;
  }

  static LinearFunction _instance;

  @override
  num output(num input) => input;
}

class CubicBezierCurve extends TimingFunction {
  /// Constructs a new instance.
  CubicBezierCurve(this.cpx1, this.cpy1, this.cpx2, this.cpy2);

  static final CubicBezierCurve ease = new CubicBezierCurve(0.25, 0.1, 0.25, 1);
  static final CubicBezierCurve easeIn = new CubicBezierCurve(0.42, 0, 1, 1);
  static final CubicBezierCurve easeOut = new CubicBezierCurve(0, 0, 0.58, 1);
  static final CubicBezierCurve easeInOut = new CubicBezierCurve(0.42, 0, 0.58, 1);

  final num cpx1;
  final num cpy1;
  final num cpx2;
  final num cpy2;

  @override
  num output(num input) {
    final num inputSquared = input * input;
    final num inputCubed = inputSquared * input;

    final num c = 3 * cpy1;
    final num b = 3 * (cpy2 - cpy1) - c;
    final num a = 1 - c - b;

    return a * inputCubed + b * inputSquared + c * input;
  }
}

class StepFunction extends TimingFunction {
  StepFunction(this.intervalCount, [this.end = true]) : delta = 1 / intervalCount;

  static final StepFunction stepStart = new StepFunction(1, false);
  static final StepFunction stepEnd = new StepFunction(1, true);

  final int intervalCount;
  final bool end;
  final num delta;

  //TODO some rounding problems... see tests
  @override
  num output(num input) => min(end ? input ~/ delta : input ~/ delta + 1, intervalCount) * delta;
}
