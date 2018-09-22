import 'dart:collection';
import 'dynamic_node.dart';
import 'html/html_node.dart';

/// The base class for all nodes that can be added to the Envy scene graph.
///
/// Every EnvyNode can optionally contain data.
///
abstract class EnvyNode {
  String id;

  EnvyNode _parent;

  HashMap<String, dynamic> _datasetMap;

  EnvyNode();

  EnvyNode get parent => _parent;

  /// Get the HtmlNode ancestor of this EnvyNode.
  ///
  /// Not every EnvyNode in the EnvySceneGraph has a
  /// corresponding DOM node, so this gives a way to
  /// "skip over" those EnvyNodes during DOM manipulation.
  ///
  /// Return null if no HtmlNode ancestor is found in the
  /// EnvySceneGraph.
  HtmlNode get htmlParent {
    if (_parent is HtmlNode) return _parent as HtmlNode;
    if (_parent == null) return null;

    // ignore: recursive_getters
    return _parent.htmlParent;
  }

  set parent(EnvyNode node) {
    if (node != _parent) {
      _parent = node;
      //TODO request update?
    }
  }

  void update(num fraction, {dynamic context, bool finish = false}) {
    if (this is DynamicNode) (this as DynamicNode).updateProperties(fraction, finish: finish);
  }

  /// Subclasses should override if they need to be initialized for animation
  /// upon attachment to scene graph.
  ///
  void prepareForAnimation() {}

  /// Add a dataset to this node.
  ///
  /// The dataset must be a List, Map, String, num or bool.
  ///
  /// If this node already contains a dataset named [name] then the
  /// new dataset will replace it.
  ///
  void addDataset(String name, {List<dynamic> list, Map<dynamic, dynamic> map, String text, num number, bool boolean}) {
    _datasetMap ??= new HashMap<String, dynamic>();
    _datasetMap[name] = list ?? (map ?? (text ?? (number ?? boolean)));
  }

  /// Removes the [name]d dataset from this node.
  ///
  /// If the dataset does not exist, null is returned.  Otherwise
  /// the dataset is returned.
  ///
  Object removeDataset(String name) => _datasetMap?.remove(name);

  /// Gets a [name]d dataset from this node, or if this node does not contain
  /// a dataset by that name then from the closest ancestor to contain such a dataset.
  ///
  /// If no dataset is found, null is returned.
  ///
  Object getDataset(String name) {
    if (_datasetMap != null && _datasetMap.containsKey(name)) {
      return _datasetMap[name];
    } else {
      if (_parent != null) return _parent.getDataset(name);
    }

    return null;
  }
}
