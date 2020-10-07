import 'package:angular/angular.dart' show Pipe, PipeTransform;
import 'package:angular/security.dart' show DomSanitizationService;

@Pipe('keepHtml', pure: false)

/// Bypasses security stripping of HTML to allow inclusion of binding and attribute values, for example.
/// WARNING:  only use this when the content is known to be safe (especially that the content does not
/// include any script tags).
class KeepHtmlPipe implements PipeTransform {
  /// Constructs a instance, injecting needed services.
  KeepHtmlPipe(this._domSanitizationSvc);

  final DomSanitizationService _domSanitizationSvc;

  /// Bypasses HTML sanitization, returning the original content.
  dynamic transform(dynamic content) => _domSanitizationSvc.bypassSecurityTrustHtml(content as String);
}
