@HtmlImport('envy_div.html')
library envy_element;

import 'package:polymer/polymer.dart';
import 'package:envy/envy.dart';

@CustomTag("envy-div")
class EnvyDiv extends PolymerElement {
  String spec;

  EnvySceneGraph sceneGraph = new EnvySceneGraph();

  EnvyDiv.created() : super.created() {
    //print("Envy div CREATED");
  }

  void attached() {
    super.attached();
    //print("Envy div ATTACHED");

    sceneGraph.htmlHost = this;

    //sceneGraph.updateGraph();
  }

  void detached() {
    super.detached();
    //print("Envy div DETACHED");
  }
}
