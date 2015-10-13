part of envy;

abstract class Enumeration<T> {
  final T value;

  const Enumeration(this.value);

  @override
  String toString() => value?.toString();
}
