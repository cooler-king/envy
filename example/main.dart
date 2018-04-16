import 'package:angular/angular.dart';
import 'gallery.dart';

// ignore_for_file: URI_HAS_NOT_BEEN_GENERATED
import 'gallery.template.dart' as app;
import 'main.template.dart' as ng;

void main() {
  runApp<Gallery>(app.GalleryNgFactory as ComponentFactory<Gallery>);
}
