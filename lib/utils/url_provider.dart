part of 'providers/providers.dart';

/// A utility class for working with URLs.
class UrlProvider {
  const UrlProvider._();

  /// Protocol constant for HTTP.
  static const String http = "http";

  /// Protocol constant for HTTPS.
  static const String https = "https";

  /// Creates a URL by combining a base URL and a path.
  ///
  /// Example:
  /// ```dart
  /// String fullUrl = UrlProvider.createByBase("https://example.com", "api/data");
  /// print(fullUrl); // Output: "https://example.com/api/data"
  /// ```
  static String createByBase(String baseUrl, String path) => "$baseUrl/$path";

  /// Creates a URL by specifying a custom protocol, domain, and path.
  ///
  /// Example:
  /// ```dart
  /// String fullUrl = UrlProvider.createByCustom("ftp", "example.org", "files/docs");
  /// print(fullUrl); // Output: "ftp://example.org/files/docs"
  /// ```
  static String createByCustom(String protocol, String domain, String path) =>
      UrlBuilder(protocol, domain).create(path);

  /// Creates an HTTP URL by specifying a domain and path.
  ///
  /// Example:
  /// ```dart
  /// String fullUrl = UrlProvider.createByHttp("example.com", "api/data");
  /// print(fullUrl); // Output: "http://example.com/api/data"
  /// ```
  static String createByHttp(String domain, String path) =>
      UrlBuilder(http, domain).create(path);

  /// Creates an HTTPS URL by specifying a domain and path.
  ///
  /// Example:
  /// ```dart
  /// String fullUrl = UrlProvider.createByHttps("example.com", "api/data");
  /// print(fullUrl); // Output: "https://example.com/api/data"
  /// ```
  static String createByHttps(String domain, String path) =>
      UrlBuilder(https, domain).create(path);
}

/// A builder class for constructing URLs.
class UrlBuilder {
  final String _protocol;
  final String _domain;

  /// Constructs a `UrlBuilder` with the specified protocol and domain.
  UrlBuilder(this._protocol, this._domain);

  /// Gets the domain of the URL.
  String get domain => _domain;

  /// Gets the protocol of the URL.
  String get protocol => _protocol;

  /// Gets the base URL formed by combining the protocol and domain.
  String get baseUrl => "$protocol://$domain";

  /// Creates a complete URL by combining the base URL and a path.
  ///
  /// Example:
  /// ```dart
  /// String fullUrl = UrlBuilder("https", "example.com").create("api/data");
  /// print(fullUrl); // Output: "https://example.com/api/data"
  /// ```
  String create(String path) => "$baseUrl/$path";
}
