import 'dart:async';
import 'package:angular/angular.dart';
import 'package:envy/ng/envy_line_graph/envy_line_graph.dart';
import 'package:envy/ng/envy_line_graph/line_series.dart';

@Component(
  selector: 'test-line-graph2d',
  templateUrl: 'test_line_graph2d.html',
  styleUrls: <String>['test_line_graph2d.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: <Object>[EnvyLineGraph],
)
class TestLineGraph2d implements AfterViewInit {
  TestLineGraph2d(this._change);

  // Services.
  final ChangeDetectorRef _change;

  @ViewChild('basic', read: EnvyLineGraph)
  EnvyLineGraph basicScene;

  List<LineSeries<num, num>> basicSeriesList = <LineSeries<num, num>>[];

  @override
  void ngAfterViewInit() {
    Timer.run(() {
      testBasic();
    });
  }

  void testBasic() {
    basicSeriesList = <LineSeries<num, num>>[
      LineSeries<num, num>('basic', 'Basic', <num>[100, 200, 300, 400, 500], <num>[20, 10, 30, 5, 25]),
    ];

    basicScene.scene.sceneGraph.updateGraph();
    basicScene.scene.sceneGraph.setAnimationDuration(millis: 300);
    _change.markForCheck();
  }
}
