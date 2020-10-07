import '../../util/enumeration.dart';

/// In HTML5, some HTML elements which provide support for CORS, such as <img> or <video>, have a
/// `crossorigin` attribute (crossOrigin property), which lets you configure the CORS requests for the
/// element's fetched data.
///
/// See https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS for more information on CORS.
class CrossOrigin extends Enumeration<String> {
  /// Constructs a enw instance.
  const CrossOrigin(String value) : super(value);

  /// CORS requests for this element will not have the credentials flag set
  static const CrossOrigin anonymous = CrossOrigin('anonymous');

  /// CORS requests for this element will have the credentials flag set; this means
  /// the request will provide credentials
  static const CrossOrigin useCredentials = CrossOrigin('use_credentials');
}
