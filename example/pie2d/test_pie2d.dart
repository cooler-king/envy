import 'dart:async';
import 'dart:math';
import 'package:angular/angular.dart';
import 'package:envy/envy.dart';
import 'package:envy/ng/envy_pie/envy_pie.dart';
import 'package:envy/ng/envy_pie/pie_slice.dart';
import 'package:quantity/quantity.dart';

@Component(
  selector: 'test-pie2d',
  templateUrl: 'test_pie2d.html',
  styleUrls: <String>['test_pie2d.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
  directives: <Object>[EnvyPie],
)
class TestPie2d implements AfterViewInit {
  TestPie2d(this._change);

  // Services.
  final ChangeDetectorRef _change;

  @ViewChild('basic', read: EnvyPie)
  EnvyPie basicScene;

  @ViewChild('dynamic', read: EnvyPie)
  EnvyPie dynamicPie;

  List<PieSlice> basicSlices = <PieSlice>[];
  List<PieSlice> dynamicSlices = <PieSlice>[];

  num dynamicInnerRadius = 0;

  Angle ang0 = angle0;
  Angle ang45 = angle45;
  Angle ang90 = angle90;
  Angle ang180 = angle180;
  Angle ang270 = angle270;
  Angle angNeg90 = Angle(deg: -90);

  @override
  void ngAfterViewInit() {
    Timer.run(() {
      testBasic();
      testDynamic();
    });
  }

  void testBasic() {
    basicSlices = <PieSlice>[
      PieSlice(
          key: 'slice1',
          value: 7,
          fillStyle: DrawingStyle2d(color: Color.aliceBlue),
          strokeStyle: DrawingStyle2d(color: Color.white)),
      PieSlice(
          key: 'slice2',
          value: 3,
          fillStyle: DrawingStyle2d(color: Color.blue),
          strokeStyle: DrawingStyle2d(color: Color.white))
    ];

    basicScene.scene.sceneGraph.updateGraph();
    basicScene.scene.sceneGraph.setAnimationDuration(millis: 300);
    _change.markForCheck();
  }

  void testDynamic() {
    dynamicSlices = <PieSlice>[
      PieSlice(
          key: 'slice1',
          value: 7,
          fillStyle: DrawingStyle2d(color: Color.cyan),
          strokeStyle: DrawingStyle2d(color: Color.white)),
      PieSlice(
          key: 'slice2',
          value: 3,
          fillStyle: DrawingStyle2d(color: Color.blue),
          strokeStyle: DrawingStyle2d(color: Color.white))
    ];

    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      final list = <PieSlice>[];

      final rand = Random();
      final count = 1 + rand.nextInt(7);
      for (var i = 0; i < count; i++) {
        final slice = PieSlice(
            key: 'slice$i',
            value: rand.nextInt(50),
            fillStyle: DrawingStyle2d(color: Color.random()),
            strokeStyle: DrawingStyle2d(color: Color.white));

        list.add(slice);
      }

      dynamicSlices = list;

      dynamicInnerRadius = 50 * rand.nextDouble();
      _change.markForCheck();
    });
  }
}
