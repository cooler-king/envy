part of envy;

/// [PopulationMode] determines how an Envy node populates the
/// DOM nodes of its parent Envy node.
///
/// The default value is INDEPENDENT, which will populate _each_
/// DOM node of the Envy [HtmlNode] parent with all of the DOM nodes
/// generated by this Envy [HtmlNode].
///
class PopulationMode extends Enumeration<String> {

  /// Populates _each_ DOM node of an Envy [HtmlNode] parent with all of the
  /// DOM nodes generated by a child Envy [HtmlNode].
  static const PopulationMode INDEPENDENT = const PopulationMode("independent");

  /// Populates the DOM nodes of an Envy [HtmlNode] parent such that they will
  /// have an equal number of children (subject to the amount of nodes
  /// available for distribution).  If equal distribution is impossible the
  /// DOM nodes of the parent having higher indices will have fewer children.
  static const PopulationMode DISTRIBUTE = const PopulationMode("distribute");

  /// Populates the DOM nodes of an Envy [HtmlNode] parent with a single node.
  /// Ignores any missing or extra children.
  static const PopulationMode PARALLEL = const PopulationMode("parallel");

  /// Populates the DOM nodes of an Envy [HtmlNode] parent with a single node.
  /// Ignores any missing or extra children.
  static const PopulationMode PARALLEL_EXTRAPOLATE = const PopulationMode("parallel");

  const PopulationMode(String value) : super(value);
}