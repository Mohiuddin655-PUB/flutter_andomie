part of 'providers/providers.dart';

class UrlProvider {
  const UrlProvider._();

  static const String http = "http";
  static const String https = "https";

  static String createByBase(String baseUrl, String path) => "$baseUrl/$path";

  static String createByCustom(String protocol, String domain, String path) =>
      UrlBuilder(protocol, domain).create(path);

  static String createByHttp(String domain, String path) =>
      UrlBuilder(http, domain).create(path);

  static String createByHttps(String domain, String path) =>
      UrlBuilder(https, domain).create(path);
}

class UrlBuilder {
  final String _protocol;
  final String _domain;

  UrlBuilder(this._protocol, this._domain);

  String get domain => _domain;

  String get protocol => _protocol;

  String get baseUrl => "$protocol://$domain";

  String create(String path) => "$baseUrl/$path";
}
