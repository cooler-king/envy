import 'dart:math' show min;

/// An abstract base class for timing functions.
// ignore: one_member_abstracts
abstract class TimingFunction {
  /// Convert a value between 0-1 (inclusive) to another
  /// value between 0-1 (inclusive) according to some algorithm.
  num output(num input);
}

/// Linear timing.
class LinearFunction extends TimingFunction {
  /// Constructs a instance.
  factory LinearFunction() => _instance ?? (LinearFunction._internal());

  LinearFunction._internal() {
    _instance = this;
  }

  static LinearFunction _instance;

  @override
  num output(num input) => input;
}

/// Non-linear timing.
class CubicBezierCurve extends TimingFunction {
  /// Constructs a instance.
  CubicBezierCurve(this.cpx1, this.cpy1, this.cpx2, this.cpy2);

  /// Ease.
  static final CubicBezierCurve ease = CubicBezierCurve(0.25, 0.1, 0.25, 1);

  /// Starts slowly.
  static final CubicBezierCurve easeIn = CubicBezierCurve(0.42, 0, 1, 1);

  /// Ends slowly.
  static final CubicBezierCurve easeOut = CubicBezierCurve(0, 0, 0.58, 1);

  /// Fastest in the middle.
  static final CubicBezierCurve easeInOut = CubicBezierCurve(0.42, 0, 0.58, 1);

  /// The x-value of the first curve parameter.
  final num cpx1;

  /// The y-value of the first curve parameter.
  final num cpy1;

  /// The x-value of the second curve parameter.
  final num cpx2;

  /// The y-value of the second curve parameter.
  final num cpy2;

  @override
  num output(num input) {
    final inputSquared = input * input;
    final inputCubed = inputSquared * input;

    final c = 3 * cpy1;
    final b = 3 * (cpy2 - cpy1) - c;
    final a = 1 - c - b;

    return a * inputCubed + b * inputSquared + c * input;
  }
}

/// Changes values abruptly.
class StepFunction extends TimingFunction {
  /// Constructs a instance.
  StepFunction(this.intervalCount, [this.end = true]) : delta = 1 / intervalCount;

  /// Steps at the start.
  static final StepFunction stepStart = StepFunction(1, false);

  /// Steps at the end.
  static final StepFunction stepEnd = StepFunction(1, true);

  /// The number of steps.
  final int intervalCount;

  /// Whether the steps skew toward the end of the beginning.
  final bool end;

  /// The delta.
  final num delta;

  //TODO some rounding problems... see tests
  @override
  num output(num input) => min(end ? input ~/ delta : input ~/ delta + 1, intervalCount) * delta;
}
