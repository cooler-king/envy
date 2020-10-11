import 'package:angular/angular.dart';
import 'annular_section2d/test_annular_section2d.dart';
import 'bar2d/test_bar2d.dart';
import 'circle2d/test_circle2d.dart';
import 'cross2d/test_cross2d.dart';
import 'image2d/test_image2d.dart';
import 'lineGraph2d/test_line_graph2d.dart';
import 'path2d/test_path2d.dart';
import 'pie2d/test_pie2d.dart';
import 'rect2d/test_rect2d.dart';
import 'star2d/test_star2d.dart';
import 'text2d/test_text2d.dart';
import 'triangle2d/test_triangle2d.dart';

@Component(
  selector: 'gallery',
  templateUrl: 'gallery.html',
  styleUrls: <String>['gallery.css'],
  directives: <Object>[
    coreDirectives,
    TestAnnularSection2d,
    TestBar2d,
    TestCircle2d,
    TestCross2d,
    TestImage2d,
    TestLineGraph2d,
    TestPath2d,
    TestPie2d,
    TestRect2d,
    TestStar2d,
    TestText2d,
    TestTriangle2d,
  ],
)
class Gallery {
  String page = 'annular_section2d';
}
