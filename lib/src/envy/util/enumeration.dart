/// The abstract base class for all enumerations.
abstract class Enumeration<T> {
  /// The constructor.
  const Enumeration(this.value);

  /// The enumerated value.
  final T value;

  @override
  String toString() => value?.toString();
}
