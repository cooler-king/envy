import 'dart:async';
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';
import 'package:envy/src/envy/util/logger.dart';
import 'package:quantity/quantity.dart' show Angle;
import 'package:vector_math/vector_math.dart' show Vector2;
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
      Timer.run(_updateData);
    }
  }

  /// THe inner radius of the pie slices in pixels (defaults to zero).
  @Input()
  num innerRadius = 0;

  /// THe outer radius of the pie slices in pixels (defaults to max available).
  @Input()
  num outerRadius;

  /// The start angle of the first slice (defaults to zero, the x-axis).
  @Input()
  Angle startAngle = new Angle(deg: 0);

  /// The direction around the circle in which slices are drawn (defaults to clockwise).
  @Input()
  bool clockwise = true;

  /// The center of the pie, in pixels.
  Vector2 get origin => _origin;
  Vector2 _origin = new Vector2.zero();
  @Input()
  set origin(Vector2 value) {
    if (value != _origin) {
      _origin = value;
      _updateData();
    }
  }

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

    final num radius = outerRadius ?? 50;
    print('RADIUS  $radius');

    s.startAngle.enter = new AngleConstant(startAngle + new Angle(deg: 360) as Angle);
    s.endAngle.enter = new AngleConstant(startAngle + new Angle(deg: 360) as Angle);
    s.outerRadius.enter = new NumberData.keyed(dataset, 'innerRadius');
    s.innerRadius.enter = new NumberData.keyed(dataset, 'innerRadius');
    s.opacity.enter = new NumberConstant(0.1);

    s.x.update = new NumberData.keyed(dataset, 'x');
    s.y.update = new NumberData.keyed(dataset, 'y');
    s.innerRadius.update = new NumberData.keyed(dataset, 'innerRadius');
    s.outerRadius.update = new NumberData.keyed(dataset, 'outerRadius');
    s.startAngle.update = new AngleData.keyed(dataset, 'startAngle');
    s.endAngle.update = new AngleData.keyed(dataset, 'endAngle');
    s.lineWidth.update = new NumberConstant(2);
    s.fillStyle.update = new DrawingStyle2dData.keyed(dataset, 'fillStyle');
    s.strokeStyle.update = new DrawingStyle2dData.keyed(dataset, 'strokeStyle');
    s.fill.update = new BooleanConstant(true);
    s.stroke.update = new BooleanConstant(true);
    s.opacity.update = new NumberData.keyed(dataset, 'opacity');

    s.startAngle.exit = new AngleConstant(startAngle + new Angle(deg: 360) as Angle);
    s.endAngle.exit = new AngleConstant(startAngle + new Angle(deg: 360) as Angle);
    s.outerRadius.exit = new NumberData.keyed(dataset, 'innerRadius');
    s.opacity.exit = new NumberConstant(0.01);

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
    try {
      final EnvySceneGraph esg = scene?.sceneGraph;

      final List<Map<String, dynamic>> data = <Map<String, dynamic>>[];

      final num total =
          slices.map<num>((PieSlice slice) => slice.value ?? 0).reduce((num value, num element) => value + element);
      if (total == 0) {
        esg.updateGraph();
        return;
      }

      Angle cursor = new Angle(rad: startAngle.mks);
      for (final PieSlice slice in _slices) {
        final Map<String, dynamic> sliceData = <String, dynamic>{
          'key': slice.key,
          'fillStyle': slice.fillStyle,
          'strokeStyle': slice.strokeStyle,
          'startAngle': cursor,
          'x': origin?.x ?? outerRadius / 2,
          'y': origin?.y ?? outerRadius / 2,
          'innerRadius': innerRadius,
          'outerRadius': outerRadius,
          'opacity': slice.opacity,
        };
        final double fraction = slice.value / total;
        final Angle delta = new Angle(deg: 360 * fraction);
        cursor = (clockwise ? cursor + delta : cursor - delta) as Angle;
        sliceData['endAngle'] = cursor;

        data.add(sliceData);
      }

      esg.root.addDataset('pieData', list: data);
      esg.updateGraph();
    } catch (e, s) {
      logger.severe('Unable to update pie data', e, s);
    }
  }

  @override
  void ngOnDestroy() {
    _sliceEvent?.close();
  }
}
