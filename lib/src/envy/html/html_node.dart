part of envy;

/// Common base for all Envy nodes that are rendered in normal HTML.
///
abstract class HtmlNode extends GroupNode with DynamicNode {

  //ObservableList<EnvyNode> _observableChildren;

  // The HTML nodes that render the contents of this Envy node
  final LinkedHashMap<DomNodeCoupling, Node> _domNodesMap = new LinkedHashMap<DomNodeCoupling, Node>();

  /// The [populationStrategy] determines how an Envy node populates the
  /// DOM nodes of parent Envy node.
  ///
  PopulationStrategy populationStrategy;

  /// The set of parent DOM nodes last update pass
  final LinkedHashMap<DomNodeCoupling, Node> _prevDomNodesMap = new LinkedHashMap<DomNodeCoupling, Node>();

  int _prevDomSize = 0;

  bool _populationStrategyChanged = false;

  /// Needed to allow use with DynamicNode Mixin
  HtmlNode() : this.population(new IndependentPopulationStrategy());

  HtmlNode.population(this.populationStrategy) {
    _initElementProperties();

    // The default population strategy is "Independent," which will populate _each_
    // DOM node of the Envy [HtmlNode] parent with all of the DOM nodes
    // generated by this Envy [HtmlNode].
    if (populationStrategy == null) populationStrategy = new IndependentPopulationStrategy();
  }

  /// Generate a new DOM node.
  Node generateNode();

  /// Initialize properties common to all HTML nodes.
  ///
  /// Provides a single value for the id.  This makes the default size (number of instances
  /// in the DOM) of an [HtmlNode] equal to one.
  ///
  void _initElementProperties() {
    //TODO Map<String, String> attributes
    //TODO CssClassSet classes
    properties["className"] = new StringProperty();
    properties["contentEditable"] = new BooleanProperty();
    //TODO Map<String, String> dataset
    properties["dir"] = new StringProperty(defaultValue: DirAttribute.LTR.value);
    properties["draggable"] = new BooleanProperty();
    // TODO dropzone = List of strings (space separated keywords)
    properties["hidden"] = new BooleanProperty();
    properties["id"] = new StringProperty()..enter = new StringConstant("id-${hashCode}");
    // TODO innerHtml (support this?)
    properties["lang"] = new StringProperty();
    properties["pseudo"] = new StringProperty();
    properties["scrollLeft"] = new NumberProperty();
    properties["scrollTop"] = new NumberProperty();
    properties["scrollLeft"] = new NumberProperty();
    properties["style"] = new CssStyleProperty();
    properties["tabIndex"] = new NumberProperty();
    properties["text"] = new StringProperty();
    properties["title"] = new StringProperty();
    properties["translate"] = new BooleanProperty();
  }

  List<Node> get domNodes => new List.from(_domNodesMap.values);

  CssStyleProperty get style => properties["style"];

  /// In addition to setting the parent node reference, [HtmlNode]s attach and
  /// detach their DOM nodes as appropriate.
  ///
  @override
  void set parent(EnvyNode node) {
    // Remove DOM nodes if parent has changed
    if (node != _parent && _parent != null) _domNodesMap.values.forEach((Node n) {
      n.remove();
    });

    _parent = node;

    //TODO
    /*
    // Add the DOM node to the new parent's 
    HtmlNode target = domParent;
    if(target != null) {
      target.domNode.append(_domNode);
    }
    * */
  }

  /// Called post-properties update but before children are updated.
  @override
  void groupUpdatePre(num timeFraction, {dynamic context, bool finish: false}) {
    _updateDom();
  }

  ///
  void _updateDom() {
    int newDomSize = size;

    //print("++++ HTML NODE UPDATE DOM DEPENDS ON SIZE... ${newDomSize}/${_prevDomSize}");

    // Only need to manage DOM nodes if the population stategy has changed
    // or the parent DOM nodes have changed or the nominal size has changed
    //TODO detect changes in parent DOM lineup
    //if(newSize != _prevSize || parentDomNodesChanged || _populationStrategyChanged) {
    if (newDomSize != _prevDomSize || _populationStrategyChanged) {
      HtmlNode parentHtml = htmlParent;
      int parentDomCount = parentHtml != null ? parentHtml._domNodesMap.length : 0;

      // Create/attach, remove/destroy nodes as necesary
      _manageDomNodes(parentDomCount, newDomSize);

      _prevDomSize = newDomSize;
      _populationStrategyChanged = false;
    }

    // Apply the updated properties
    for (int i = 0; i < domNodes.length; i++) {
      if (style.rawSize > 0) {
        CssStyle style = this.style.valueAt(i);
        _applyStyle(domNodes[i], style);
      }
    }

    // Children are updated by GroupNode.update()
  }

  /// Sets the style properties in [node] equal to those
  /// represented by [cssStyle].
  ///
  void _applyStyle(Node node, CssStyle cssStyle) {
    if (node is Element) {
      for (String prop in cssStyle.keys) {
        node.style.setProperty(prop, cssStyle[prop].css);
      }
    }
  }

  /*
  /// Determines whether any parent DOM nodes have changed since the last DOM update.
  /// 
  bool get parentDomNodesChanged {
    HtmlNode parentHtml = htmlParent;
    if(parentHtml == null) return false;
    
    if(_prevDomNodesMap.length != _domNodesMap.length) return true;
    
    // Each one must be identical
    for(DomNodeCoupling dnc in _domNodesMap.keys) {
      if(!identical(_prevDomNodesMap[dnc], _domNodesMap[dnc])) return true;
    }
    
    return false;
  }*/

  /// Mange the DOM nodes, creating/attaching and removing/destoying
  /// nodes as necessary.
  ///
  /// [_domNodesMap] is updated by this method.
  ///
  /// Given the number of DOM nodes generated by the parent Envy node,
  /// determine the number of DOM nodes this [HtmlNode] should generate
  /// along with the index of the DOM node parent and the index into the
  /// property values of this node.
  ///
  /// The current [PopulationStrategy] determines how the DOM nodes
  /// are distributed among the parent DOM nodes.
  ///
  void _manageDomNodes(int parentDomNodeCount, int childCount) {

    //print("MANAGING DOM NODES ${this}");
    List<DomNodeCoupling> couplingList = [];
    if (populationStrategy == null) populationStrategy = new IndependentPopulationStrategy();
    List<DomNodeCoupling> coupling = populationStrategy.determineCoupling(parentDomNodeCount, childCount);

    List<DomNodeCoupling> remainingCouplings = new List.from(_domNodesMap.keys);

    for (DomNodeCoupling dnc in coupling) {

      // Create new nodes as necessary
      if (!_domNodesMap.containsKey(dnc)) {
        Node newNode = this.generateNode();
        _domNodesMap[dnc] = newNode;

        // Actually attach to parent DOM node
        HtmlNode domParent = htmlParent;
        // print("MANAGING DOM NODES ${this}... html parent = ${domParent}");
        if (domParent != null) domParent.domNodes[dnc.parentIndex].append(newNode);
      } else {
        // Already coupled
        remainingCouplings.remove(dnc);
      }
    }

    // If any node couplings were not reused, remove associated nodes
    for (DomNodeCoupling dnc in remainingCouplings) {
      // detach the DOM node...
      _domNodesMap[dnc].remove();
      remainingCouplings.remove(dnc);

      // ...and remove from the map
      _domNodesMap.remove(dnc);
    }

    // keep track of Html parent's nodes
    //_prevDomNodesMap.clear();
    //_prevDomNodesMap.addAll(_)
  }
}
