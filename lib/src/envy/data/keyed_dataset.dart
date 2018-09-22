import '../envy_node.dart';

/// Identifies a dataset within a node and holds a key property
/// for convenience that may be used when constructing multiple
/// data accessors that differ only in property.
class KeyedDataset {
  /// The name of the dataset.
  String name;

  /// The node in which the dataset is found.
  EnvyNode node;

  /// The key property.
  String keyProp;

  /// Constructs a new instance.
  KeyedDataset(this.name, this.node, this.keyProp);
}
