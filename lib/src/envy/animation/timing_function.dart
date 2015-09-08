part of envy;

abstract class TimingFunction {
  /// Convert a value between 0-1 (inclusive) to another
  /// value between 0-1 (inclusive) according to some algorithm.
  ///
  num output(num input);
}

class LinearFunction extends TimingFunction {
  static LinearFunction _instance;

  factory LinearFunction() => _instance != null ? _instance : new LinearFunction._internal();

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

  final num p1;
  final num p2;
  final num p3;
  final num p4;

  CubicBezierCurve(this.p1, this.p2, this.p3, this.p4);

  num output(num input) {
    num inputSquared = input * input;
    num inputCubed = inputSquared * input;
    num oneMinusInput = 1 - input;
    num oneMinusInputSquared = oneMinusInput * oneMinusInput;
    num oneMinusInputCubed = oneMinusInputSquared * oneMinusInput;

    return p1 * oneMinusInputCubed +
        3 * p2 * oneMinusInputSquared * input +
        3 * p3 * oneMinusInput * inputSquared +
        p4 * inputCubed;
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
  num output(num input) => Math.min(end ? input ~/ delta : input ~/ delta + 1, intervalCount) * delta;
}
