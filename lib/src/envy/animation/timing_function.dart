import 'dart:math' show min;

abstract class TimingFunction {
  /// Convert a value between 0-1 (inclusive) to another
  /// value between 0-1 (inclusive) according to some algorithm.
  ///
  num output(num input);
}

class LinearFunction extends TimingFunction {
  static LinearFunction _instance;

  factory LinearFunction() => _instance ?? (new LinearFunction._internal());

  LinearFunction._internal() {
    _instance = this;
  }

  num output(num input) => input;
}

class CubicBezierCurve extends TimingFunction {
  static final CubicBezierCurve ease = new CubicBezierCurve(0.25, 0.1, 0.25, 1);
  static final CubicBezierCurve easeIn = new CubicBezierCurve(0.42, 0, 1, 1);
  static final CubicBezierCurve easeOut = new CubicBezierCurve(0, 0, 0.58, 1);
  static final CubicBezierCurve easeInOut = new CubicBezierCurve(0.42, 0, 0.58, 1);

  final num cpx1;
  final num cpy1;
  final num cpx2;
  final num cpy2;

  CubicBezierCurve(this.cpx1, this.cpy1, this.cpx2, this.cpy2);

  num output(num input) {
    num inputSquared = input * input;
    num inputCubed = inputSquared * input;

    num c = 3 * cpy1;
    num b = 3 * (cpy2 - cpy1) - c;
    num a = 1 - c - b;

    return a * inputCubed + b * inputSquared + c * input;
  }
}

class StepFunction extends TimingFunction {
  static final StepFunction step_start = new StepFunction(1, false);
  static final StepFunction step_end = new StepFunction(1, true);

  final int intervalCount;
  final bool end;
  final num delta;

  StepFunction(num intervals, [this.end = true])
      : this.intervalCount = intervals,
        delta = 1 / intervals;

  //TODO some rounding problems... see tests
  num output(num input) => min(end ? input ~/ delta : input ~/ delta + 1, intervalCount) * delta;
}
