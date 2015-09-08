part of envy;

/// The base class for all Envy interpolators.
///
abstract class EnvyInterpolator<T> {

  /// All EnvyInterpolators must be able to provide a value between [a] and [b] based on a time [fraction]
  /// between 0 and 1.
  ///
  T interpolate(T a, T b, num fraction);
}
