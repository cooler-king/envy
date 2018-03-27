import '../../util/enumeration.dart';

/// In HTML5, some HTML elements which provide support for CORS, such as <img> or <video>, have a
/// crossorigin attribute (crossOrigin property), which lets you configure the CORS requests for the
/// element's fetched data.
///
/// See https://developer.mozilla.org/en-US/docs/HTTP/Access_control_CORS for more information on CORS.
///
class CrossOrigin extends Enumeration<String> {
  /// CORS requests for this element will not have the credentials flag set
  static const CrossOrigin anonymous = const CrossOrigin('anonymous');

  /// CORS requests for this element will have the credentials flag set; this means
  /// the request will provide credentials
  static const CrossOrigin useCredentials = const CrossOrigin('use_credentials');

  const CrossOrigin(String value) : super(value);
}
