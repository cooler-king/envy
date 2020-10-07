import 'dart:html' show Element, Node;
import '../css/css_style.dart';
import '../data/source/string/string_source.dart';
import '../dynamic_node.dart';
import '../envy_node.dart';
import '../envy_property.dart';
import '../group_node.dart';
import '../html/enum/dir_attribute.dart';
import 'population/independent_population_strategy.dart';
import 'population/population_strategy.dart';

/// Common base for all Envy nodes that are rendered in normal HTML.
abstract class HtmlNode extends GroupNode with DynamicNode {
  /// Needed to allow use with DynamicNode Mixin.
  HtmlNode() : this.population(IndependentPopulationStrategy());

  /// Constructs a instance with a particular population strategy.
  HtmlNode.population(this.populationStrategy) {
    _initElementProperties();

    // The default population strategy is 'Independent,' which will populate _each_
    // DOM node of the Envy [HtmlNode] parent with all of the DOM nodes
    // generated by this Envy [HtmlNode].
    populationStrategy ??= IndependentPopulationStrategy();
  }

  /// The HTML nodes that render the contents of this Envy node.
  final Map<DomNodeCoupling, Node> domNodesMap = <DomNodeCoupling, Node>{};

  /// The [populationStrategy] determines how an Envy node populates the
  /// DOM nodes of parent Envy node.
  PopulationStrategy populationStrategy;

  /// The set of parent DOM nodes last update pass
  final Map<DomNodeCoupling, Node> prevDomNodesMap = <DomNodeCoupling, Node>{};

  int _prevDomSize = 0;

  bool _populationStrategyChanged = false;

  /// Generate a DOM node.
  Node generateNode();

  /// Initialize properties common to all HTML nodes.
  /// Provides a single value for the id.  This makes the default size (number of instances
  /// in the DOM) of an [HtmlNode] equal to one.
  void _initElementProperties() {
    //TODO Map<String, String> attributes
    //TODO CssClassSet classes
    properties['className'] = StringProperty();
    properties['contentEditable'] = BooleanProperty();
    //TODO Map<String, String> dataset
    properties['dir'] = StringProperty(defaultValue: DirAttribute.ltr.value);
    properties['draggable'] = BooleanProperty();
    // TODO dropzone = List of strings (space separated keywords)
    properties['hidden'] = BooleanProperty();
    properties['id'] = StringProperty()..enter = StringConstant('id-$hashCode');
    // TODO innerHtml (support this?)
    properties['lang'] = StringProperty();
    properties['pseudo'] = StringProperty();
    properties['scrollLeft'] = NumberProperty();
    properties['scrollTop'] = NumberProperty();
    properties['scrollLeft'] = NumberProperty();
    properties['style'] = CssStyleProperty();
    properties['tabIndex'] = NumberProperty();
    properties['text'] = StringProperty();
    properties['title'] = StringProperty();
    properties['translate'] = BooleanProperty();
  }

  /// The DOM nodes associated with this Envy node.
  List<Node> get domNodes => List<Node>.from(domNodesMap.values);

  /// CSS styling.
  CssStyleProperty get style => properties['style'] as CssStyleProperty;

  /// In addition to setting the parent node reference, [HtmlNode]s attach and
  /// detach their DOM nodes as appropriate.
  @override
  set parent(EnvyNode node) {
    // Remove DOM nodes if parent has changed
    if (node != super.parent && super.parent != null) {
      for (final Node n in domNodesMap.values) {
        n.remove();
      }
    }

    super.parent = node;

    //TODO
    /*
    // Add the DOM node to the parent's
    HtmlNode target = domParent;
    if(target != null) {
      target.domNode.append(_domNode);
    }
    * */
  }

  /// Called post-properties update but before children are updated.
  @override
  void groupUpdatePre(num timeFraction, {dynamic context, bool finish = false}) {
    updateDom();
  }

  /// Updates the DOM.
  void updateDom() {
    final int newDomSize = size;

    // Only need to manage DOM nodes if the population strategy has changed
    // or the parent DOM nodes have changed or the nominal size has changed.
    //TODO detect changes in parent DOM lineup
    if (newDomSize != _prevDomSize || _populationStrategyChanged) {
      final HtmlNode parentHtml = htmlParent;
      final int parentDomCount = parentHtml?.domNodesMap?.length ?? 0;

      // Create/attach, remove/destroy nodes as necessary.
      _manageDomNodes(parentDomCount, newDomSize);

      _prevDomSize = newDomSize;
      _populationStrategyChanged = false;
    }

    // Apply the updated properties
    for (var i = 0; i < domNodes.length; i++) {
      if (style.rawSize > 0) {
        final style = this.style.valueAt(i);
        _applyStyle(domNodes[i], style);
      }
    }

    // Children are updated by GroupNode.update().
  }

  /// Sets the style properties in [node] equal to those
  /// represented by [cssStyle].
  void _applyStyle(Node node, CssStyle cssStyle) {
    if (node is Element) {
      for (final String prop in cssStyle.keys) {
        node.style.setProperty(prop, cssStyle[prop].css);
      }
    }
  }

  /// Mange the DOM nodes, creating/attaching and removing/destoying
  /// nodes as necessary.
  ///
  /// [domNodesMap] is updated by this method.
  ///
  /// Given the number of DOM nodes generated by the parent Envy node,
  /// determine the number of DOM nodes this [HtmlNode] should generate
  /// along with the index of the DOM node parent and the index into the
  /// property values of this node.
  ///
  /// The current [PopulationStrategy] determines how the DOM nodes
  /// are distributed among the parent DOM nodes.
  void _manageDomNodes(int parentDomNodeCount, int childCount) {
    populationStrategy ??= IndependentPopulationStrategy();
    final List<DomNodeCoupling> coupling = populationStrategy.determineCoupling(parentDomNodeCount, childCount);

    final List<DomNodeCoupling> remainingCouplings = List<DomNodeCoupling>.from(domNodesMap.keys);

    for (final DomNodeCoupling dnc in coupling) {
      // Create nodes as necessary
      if (!domNodesMap.containsKey(dnc)) {
        final Node newNode = generateNode();
        domNodesMap[dnc] = newNode;

        // Actually attach to parent DOM node
        final HtmlNode domParent = htmlParent;
        // print('MANAGING DOM NODES ${this}... html parent = ${domParent}');
        if (domParent != null) domParent.domNodes[dnc.parentIndex].append(newNode);
      } else {
        // Already coupled
        remainingCouplings.remove(dnc);
      }
    }

    // If any node couplings were not reused, remove associated nodes.
    for (final DomNodeCoupling dnc in remainingCouplings) {
      // Detach the DOM node...
      domNodesMap[dnc].remove();
      remainingCouplings.remove(dnc);

      // ...and remove from the map.
      domNodesMap.remove(dnc);
    }
  }
}
