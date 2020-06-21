import 'dart:async';
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';
import 'package:quantity/quantity.dart' show Angle;
import '../../ng/envy_scene.dart';
import '../../src/envy/data/source/boolean/boolean_source.dart';
import '../../src/envy/data/source/number/number_source.dart';
import '../../src/envy/envy_scene_graph.dart';
import '../../src/envy/graphic/twod/annular_section2d.dart';
import '../../src/envy/html/canvas_node.dart';
import 'pie_slice.dart';

/// Displays and manages a pie chart.
@Component(
  selector: 'envy-pie',
  templateUrl: 'envy_pie.html',
  styleUrls: const <String>['envy_pie.css'],
  directives: const <Object>[
    EnvyScene,
  ],
)
class EnvyPie implements AfterViewInit, OnDestroy {
  /// Constructs a new instance.
  EnvyPie(this._change);

  // Services.
  final ChangeDetectorRef _change;

  /// The slices that constitute the pie
  List<PieSlice> get slices => _slices;
  List<PieSlice> _slices;
  @Input()
  set slices(List<PieSlice> value) {
    if (value != _slices) {
      _slices = value;
      _updateData();
      _change.markForCheck();
    }
  }

  /// THe inner radius of the pie slices in pixels (defaults to zero).
  @Input()
  num innerRadius = 0;

  /// THe outer radius of the pie slices in pixels (defaults to max available).
  @Input()
  num outerRadius;

  /// The start angle of the first slice (defaults to zero).
  @Input()
  Angle startAngle = new Angle(deg: 0);

  /// The direction around the circle in which slices are drawn (defaults to clockwise).
  @Input()
  bool clockwise = true;

  /// Broadcasts mouse events for the pie slices.
  @Output()
  Stream<Graphic2dIntersection> get sliceEvent => _sliceEvent.stream;
  final StreamController<Graphic2dIntersection> _sliceEvent = new StreamController<Graphic2dIntersection>.broadcast();

  /// A reference to the scene component that displays the pie.
  @ViewChild(EnvyScene)
  EnvyScene scene;

  @override
  void ngAfterViewInit() {
    _createGraphic();
    _updateData();
  }

  void _createGraphic() {
    final EnvySceneGraph esg = scene?.sceneGraph;
    final CanvasNode canvas = new CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final KeyedDataset dataset = new KeyedDataset('pieData', esg.root, 'key');

    // Annular Section.
    final AnnularSection2d s = new AnnularSection2d();
    canvas.attach(s);

    //s.x.update = new NumberConstant.array(<num>[75, 225, 375]);
    //s.y.update = new NumberConstant.array(<num>[55]);
    s.innerRadius.update = new NumberConstant(innerRadius);
    s.outerRadius.update = new NumberConstant(outerRadius);
    s.startAngle.update = new AngleData.keyed(dataset, 'startAngle');
    s.endAngle.update = new AngleData.keyed(dataset, 'endAngle');
    s.lineWidth.update = new NumberConstant(2);
    s.fillStyle.update = new DrawingStyle2dData.keyed(dataset, 'fillStyle');
    s.strokeStyle.update = new DrawingStyle2dData.keyed(dataset, 'strokeStyle');
    s.fill.update = new BooleanConstant(true);
    s.stroke.update = new BooleanConstant(true);

    // Forward mouse events.
    s.onClick.listen(_sliceEvent.add);
    s.onDoubleClick.listen(_sliceEvent.add);
    s.onMouseEnter.listen(_sliceEvent.add);
    s.onMouseLeave.listen(_sliceEvent.add);
    s.onMouseOut.listen(_sliceEvent.add);
    s.onMouseOver.listen(_sliceEvent.add);
    s.onMouseDown.listen(_sliceEvent.add);
    s.onMouseUp.listen(_sliceEvent.add);

    esg.updateGraph();
  }

  void _updateData() {
    final EnvySceneGraph esg = scene?.sceneGraph;

    final List<Map<String, dynamic>> data = <Map<String, dynamic>>[];

    final num total =
        slices.map<num>((PieSlice slice) => slice.value ?? 0).reduce((num value, num element) => value + element);

    Angle cursor = new Angle(rad: startAngle.mks);
    for (final PieSlice slice in _slices) {
      final Map<String, dynamic> sliceData = <String, dynamic>{
        'key': slice.key,
        'fillStyle': slice.fillStyle,
        'strokeStyle': slice.strokeStyle,
        'startAngle': cursor,
      };
      final double fraction = slice.value / total;
      cursor = cursor + new Angle(deg: 360 * fraction) as Angle;
      sliceData['endAngle'] = cursor;

      data.add(sliceData);
    }

    esg.root.addDataset('pieData', list: data);
    esg.updateGraph();
  }

  @override
  void ngOnDestroy() {
    _sliceEvent?.close();
  }
}
