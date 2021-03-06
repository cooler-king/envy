import 'dart:async';
import 'dart:html';
import 'dart:math' show max;
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';
import 'package:envy/src/envy/util/logger.dart';
import 'package:quantity/quantity.dart' show Angle;
import 'package:vector_math/vector_math.dart' show Vector2;
import '../../ng/envy_scene.dart';
import '../../src/envy/data/source/boolean/boolean_source.dart';
import '../../src/envy/data/source/number/number_source.dart';
import '../../src/envy/graphic/twod/annular_section2d.dart';
import '../../src/envy/html/canvas_node.dart';
import '../../src/envy/util/keep_html_pipe.dart';
import 'pie_slice.dart';

/// Displays and manages a pie chart.
@Component(
  selector: 'envy-pie',
  templateUrl: 'envy_pie.html',
  styleUrls: <String>['envy_pie.css'],
  directives: <Object>[
    coreDirectives,
    EnvyScene,
  ],
  pipes: <Object>[
    KeepHtmlPipe,
  ],
)
class EnvyPie implements AfterViewInit, OnDestroy {
  /// Constructs a instance.
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
  Angle startAngle = Angle(deg: 0);

  /// The direction around the circle in which slices are drawn (defaults to clockwise).
  @Input()
  bool counterclockwise = false;

  /// A reference to the wrapper element.
  @ViewChild('wrapper')
  Element wrapper;

  /// A reference to the tooltip element.
  @ViewChild('tooltipEl')
  Element tooltipEl;

  /// Controls whether the tooltip is displayed.
  bool showTooltip = false;

  /// Controls the HTML displayed in the tooltip
  String tooltipHtml;

  /// defines the CSS styling of the tooltip.
  Map<String, String> tooltipStyle;

  /// The current slice that the mouse is over (if any).
  PieSlice hoverSlice;

  /// The center of the pie, in pixels.
  Vector2 get origin => _origin;
  Vector2 _origin = Vector2.zero();
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
  final StreamController<Graphic2dIntersection> _sliceEvent = StreamController<Graphic2dIntersection>.broadcast();

  /// A reference to the scene component that displays the pie.
  @ViewChild(EnvyScene)
  EnvyScene scene;

  @override
  void ngAfterViewInit() {
    _createGraphic();
    _updateData();
  }

  void _createGraphic() {
    final esg = scene?.sceneGraph;
    final canvas = CanvasNode(1000, 100);
    esg.attachToRoot(canvas);

    final dataset = KeyedDataset('pieData', esg.root, 'key');

    // Annular Section.
    final s = AnnularSection2d();
    canvas.attach(s);

    s.startAngle.enter = AngleConstant(startAngle + Angle(deg: 360) as Angle);
    s.endAngle.enter = AngleConstant(startAngle + Angle(deg: 360) as Angle);
    s.outerRadius.enter = NumberData.keyed(dataset, 'innerRadius');
    s.innerRadius.enter = NumberData.keyed(dataset, 'innerRadius');
    s.opacity.enter = NumberConstant(0.1);

    s.x.update = NumberData.keyed(dataset, 'x');
    s.x.interpolator = BinaryInterpolator<num>(<num>[0.0]);
    s.y.update = NumberData.keyed(dataset, 'y');
    s.y.interpolator = BinaryInterpolator<num>(<num>[0.0]);

    s.innerRadius.update = NumberData.keyed(dataset, 'innerRadius');
    s.innerRadius.interpolator = BinaryInterpolator<num>(<num>[0.0]);
    s.outerRadius.update = NumberData.keyed(dataset, 'outerRadius');
    s.outerRadius.interpolator = BinaryInterpolator<num>(<num>[0.0]);
    s.startAngle.update = AngleData.keyed(dataset, 'startAngle');
    s.endAngle.update = AngleData.keyed(dataset, 'endAngle');
    s.lineWidth.update = NumberConstant(2);
    s.fillStyle.update = DrawingStyle2dData.keyed(dataset, 'fillStyle');
    s.strokeStyle.update = DrawingStyle2dData.keyed(dataset, 'strokeStyle');
    s.fill.update = BooleanConstant(true);
    s.stroke.update = BooleanConstant(true);
    s.opacity.update = NumberData.keyed(dataset, 'opacity');

    s.startAngle.exit = AngleConstant(startAngle + Angle(deg: 360) as Angle);
    s.endAngle.exit = AngleConstant(startAngle + Angle(deg: 360) as Angle);
    s.outerRadius.exit = NumberData.keyed(dataset, 'innerRadius');
    s.opacity.exit = NumberConstant(0.01);

    // Update tooltip visibility on enter and leave.
    s.onMouseEnter.listen((Graphic2dIntersection g2di) {
      try {
        final slice = _slices[g2di.index];
        hoverSlice = slice;
        Timer(const Duration(milliseconds: 750), () => _updateTooltip(slice, g2di));
      } catch (e, s) {
        logger.severe('Problem handling pie slice mouse enter', e, s);
      }

      // Forward the event to any other listeners.
      _sliceEvent.add(g2di);
    });
    s.onMouseLeave.listen((Graphic2dIntersection g2di) {
      hoverSlice = null;
      showTooltip = false;
      _change.markForCheck();

      // Forward the event to any other listeners.
      _sliceEvent.add(g2di);
    });
    s.onMouseMove.listen((Graphic2dIntersection g2di) {
      if (showTooltip) {
        final slice = _slices[g2di.index];
        _updateTooltip(slice, g2di);
      }
    });

    // Forward other mouse events.
    s.onClick.listen(_sliceEvent.add);
    s.onDoubleClick.listen(_sliceEvent.add);
    s.onMouseOut.listen(_sliceEvent.add);
    s.onMouseOver.listen(_sliceEvent.add);
    s.onMouseDown.listen(_sliceEvent.add);
    s.onMouseUp.listen(_sliceEvent.add);

    // Text Label
    final label2d = Text2d();
    canvas.attach(label2d);

    label2d.text.enter = StringData.keyed(dataset, 'labelText');
    label2d.text.interpolator = BinaryInterpolator<String>(<num>[0.0]);
    label2d.font.enter = FontConstant(
        Font(family: FontFamily.sansSerif, size: FontSize.cssLength(CssLength.px(11)), weight: FontWeight.normal));

    label2d.x.update = NumberData.keyed(dataset, 'labelX');
    label2d.x.interpolator = BinaryInterpolator<num>(<num>[0.0]);
    label2d.y.update = NumberData.keyed(dataset, 'labelY');
    label2d.y.interpolator = BinaryInterpolator<num>(<num>[0.0]);
    label2d.fillStyle.update = DrawingStyle2dData.keyed(dataset, 'labelFill');
    label2d.opacity.update = NumberData.keyed(dataset, 'labelOpacity');
    label2d.anchor.update = Anchor2dData.keyed(dataset, 'labelAnchor');
    label2d.rotation.update = AngleData.keyed(dataset, 'labelRotation');

    esg.updateGraph();
  }

  void _updateTooltip(PieSlice slice, Graphic2dIntersection g2di) {
    if (slice?.tooltip != null && slice == hoverSlice) {
      showTooltip = true;
      tooltipHtml = slice.tooltip.html;

      final style =
          slice.tooltip.cssStyle != null ? Map<String, String>.from(slice.tooltip.cssStyle) : <String, String>{};

      final wrapperRect = wrapper.getBoundingClientRect();

      // X
      final offsetX = g2di.event.client.x - wrapperRect.left;
      final fromRight = wrapperRect.width - offsetX;
      final tooltipX = max(0, fromRight < 150 ? wrapperRect.width - 150 : offsetX);

      // Y
      String tooltipTop, tooltipBottom;
      final offsetY = g2di.event.client.y - wrapperRect.top;
      final topHalf = offsetY < 0.5 * wrapperRect.height;
      if (topHalf) {
        tooltipTop = '${offsetY + 24}px';
        tooltipBottom = 'unset';
      } else {
        tooltipTop = 'unset';
        tooltipBottom = '${wrapperRect.height - offsetY + 4}px';
      }

      style['left'] = '${tooltipX}px';
      style['top'] = tooltipTop;
      style['bottom'] = tooltipBottom;
      tooltipStyle = style;
      _change.markForCheck();
    }
  }

  void _updateData() {
    try {
      final esg = scene?.sceneGraph;

      final data = <Map<String, dynamic>>[];

      if (slices?.isNotEmpty == true) {
        final total =
            slices.map<num>((PieSlice slice) => slice.value ?? 0).reduce((num value, num element) => value + element);
        if (total == 0) {
          esg.updateGraph();
          return;
        }

        var cursor = Angle(rad: startAngle.mks);
        for (final slice in _slices) {
          final sliceData = <String, dynamic>{
            'key': slice.key,
            'fillStyle': slice.fillStyle,
            'strokeStyle': slice.strokeStyle,
            'startAngle': cursor,
            'x': origin?.x ?? outerRadius / 2,
            'y': origin?.y ?? outerRadius / 2,
            'innerRadius': innerRadius,
            'outerRadius': outerRadius,
            'opacity': slice.opacity,
            'labelText': slice.label?.text ?? '',
          };
          final fraction = slice.value / total;
          var delta = Angle(deg: 360 * fraction);
          if (counterclockwise) delta = delta * -1 as Angle;

          final labelRadius = innerRadius + 0.01 * (slice.label?.radialPct ?? 50) * (outerRadius - innerRadius);
          final labelAngle = cursor + delta * 0.01 * (slice.label?.spanPct ?? 50) as Angle;

          if (counterclockwise) {
            sliceData['endAngle'] = cursor;
          } else {
            sliceData['startAngle'] = cursor;
          }

          cursor = cursor + delta as Angle;

          if (counterclockwise) {
            sliceData['startAngle'] = cursor;
          } else {
            sliceData['endAngle'] = cursor;
          }

          sliceData['labelText'] = slice.label?.text ?? '';
          sliceData['labelX'] = sliceData['x'] + labelRadius * labelAngle.cosine();
          sliceData['labelY'] = sliceData['y'] + labelRadius * labelAngle.sine();
          sliceData['labelFill'] = slice.label?.fillStyle ?? DrawingStyle2d.black;
          sliceData['labelOpacity'] = slice.label?.opacity ?? 1;
          sliceData['labelRotation'] = slice.label?.rotation ?? Angle(deg: 0);
          sliceData['labelAnchor'] = slice.label?.anchor ?? Anchor2d(mode: AnchorMode2d.center);

          data.add(sliceData);
        }
      }

      esg.root.addDataset('pieData', list: data);
      esg.updateGraph();
    } catch (e, s) {
      logger.severe('Unable to update pie data', e, s);
    }
  }

  /// Stand down when the mouse leaves.
  void handleExit() {
    Timer(const Duration(milliseconds: 900), () {
      hoverSlice = null;
      showTooltip = false;
      _change.markForCheck();
    });
  }

  @override
  void ngOnDestroy() {
    _sliceEvent?.close();
  }
}
