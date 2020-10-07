import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';
import 'package:envy/src/envy/util/logger.dart';
import '../../ng/envy_scene.dart';
import '../../src/envy/graphic/twod/path2d.dart';
import '../../src/envy/html/canvas_node.dart';
import 'line_series.dart';

/// Displays and manages a line graph.
@Component(
  selector: 'envy-line-graph',
  templateUrl: 'envy_line_graph.html',
  styleUrls: <String>['envy_line_graph.css'],
  directives: <Object>[
    coreDirectives,
    EnvyScene,
  ],
)
class EnvyLineGraph<X, Y> implements AfterViewInit, OnDestroy {
  /// Constructs a instance.
  EnvyLineGraph(this._change);

  // Services.
  final ChangeDetectorRef _change;

  /// A list of data series -- one entry for each line.
  List<LineSeries<X, Y>> get seriesList => _seriesList;
  List<LineSeries<X, Y>> _seriesList = <LineSeries<X, Y>>[];
  @Input()
  set seriesList(List<LineSeries<X, Y>> value) {
    if (value != _seriesList) {
      _seriesList = value ?? <LineSeries<X, Y>>[];
      Timer.run(_updateData);
    }
  }

  /// A reference to the wrapper element.
  @ViewChild('wrapper')
  Element wrapper;

  /// A reference to the tooltip element.
  @ViewChild('tooltipEl')
  Element tooltipEl;

  /// Controls whether the tooltip is displayed.
  bool showTooltip = false;

  /// Controls the HTML displayed in the tooltip.
  String tooltipHtml;

  /// Defines the CSS styling of the tooltip.
  Map<String, String> tooltipStyle;

  /// Broadcasts mouse events for the markers.
  @Output()
  Stream<Graphic2dIntersection> get markerEvent => _markerEvent.stream;
  final StreamController<Graphic2dIntersection> _markerEvent = StreamController<Graphic2dIntersection>.broadcast();

  /// A reference to the scene component that displays the line graph.
  @ViewChild(EnvyScene)
  EnvyScene scene;

  CanvasNode _canvas;

  @override
  void ngAfterViewInit() {
    _createGraphic();
    _updateData();
  }

  void _createGraphic() {
    final esg = scene?.sceneGraph;
    _canvas = CanvasNode(1000, 100);
    esg.attachToRoot(_canvas);

    final dataset = KeyedDataset('vertexData', esg.root, 'key');

    // One path for each line series.
    final s = Path2d();
    _canvas.attach(s);

    s.points.enter = PointListData('points', _canvas);
    PointListData.keyed(dataset, 'points');

    esg.updateGraph();
  }

  void _updateData() {
    try {
      final esg = scene?.sceneGraph;

      final data = <Map<String, dynamic>>[];

      if (seriesList?.isNotEmpty == true) {
        for (final series in seriesList) {
          final map = <String, dynamic>{
            'key': series.key,
            'points': seriesToPointList(series),
          };

          data.add(map);
        }

        /*
        final rand = Random();
        final newPointData = PointList(<Point<num>>[
          Point<num>(1, rand.nextDouble() * 300),
          Point<num>(20, rand.nextDouble() * 300),
          Point<num>(40, rand.nextDouble() * 300),
          Point<num>(60, rand.nextDouble() * 300),
          Point<num>(80, rand.nextDouble() * 300),
          Point<num>(100 + rand.nextDouble() * 100, rand.nextDouble() * 300)
        ]);*/

        _canvas.addDataset('vertexData', list: data);
        esg.updateGraph();
      }
    } catch (e, s) {
      logger.severe('Unable to update pie data', e, s);
    }
  }

  /// Stand down when the mouse leaves.
  void handleExit() {
    Timer(const Duration(milliseconds: 900), () {
      showTooltip = false;
      _change.markForCheck();
    });
  }

  /// Converts a line series to pixel points
  PointList seriesToPointList(LineSeries series) {
    final pointList = PointList();
    for (var i = 0; i < series.length; i++) {
      //TODO SCALE, custom convert etc
      pointList.add(Point<num>(series.xList[i] as num, series.yList[i]));
    }

    return pointList;
  }

  @override
  void ngOnDestroy() {
    _markerEvent?.close();
  }
}
