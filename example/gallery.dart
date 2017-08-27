import 'package:angular/angular.dart';
import 'annular_section2d/test_annular_section2d.dart';

@Component(
  selector: "gallery",
  templateUrl: 'gallery.html',
  directives: const[TestAnnularSection2d],
)
class Gallery implements AfterViewInit {


  void ngAfterViewInit() {
    print("GALLERY VIEW INITIALIZED");
  }
}

