part of envy;

class FillMode extends Enumeration<String> {
  static const FillMode NONE = const FillMode("none");
  static const FillMode FORWARDS = const FillMode("forwards");
  static const FillMode BACKWARDS = const FillMode("backwards");
  static const FillMode BOTH = const FillMode("both");

  const FillMode(String value) : super(value);
}
