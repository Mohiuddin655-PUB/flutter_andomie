import 'package:flutter/material.dart';

extension on String? {
  String? get trimmedRoute {
    if (this == null) return null;
    String route = this ?? '';
    if (route.isEmpty) return '';
    return _filter(route);
  }

  String _filter(String route) {
    if (route.isEmpty) return '';
    final detector = RouteManager._._separator;
    if (!route.startsWith(detector) && !route.endsWith(detector)) return route;
    if (route.startsWith(detector)) {
      route = route.substring(1, route.length);
    }
    if (route.endsWith(detector)) {
      route = route.substring(0, route.length - 1);
    }
    return _filter(route);
  }
}

class RouteManager {
  RouteManager._internal();

  bool _filter = true;
  bool _multiple = true;
  String _separator = '/';
  List<String?> _routes = [];
  Iterable<String> _ignorableRoutes = [];
  Iterable<String> _supportedRoutes = [];
  ValueChanged<String>? _callback;

  void _n() {
    if (_callback == null) return;
    _callback!(routes);
  }

  static RouteManager? _i;

  static RouteManager get _ => _i ??= RouteManager._internal();

  static String? get currentRoute => _._routes.lastOrNull;

  static String? get initialRoute => _._routes.firstOrNull;

  static String? get previousRoute {
    return _._routes.elementAtOrNull(_._routes.length - 2);
  }

  static String get routes {
    return _._routes
        .map((e) => e ?? '')
        .where((e) => e.isNotEmpty)
        .join(_._separator);
  }

  static set allowFilter(bool value) => _._filter = value;

  static set allowMultiple(bool value) => _._multiple = value;

  static set ignorableRoutes(Iterable<String> value) {
    _._ignorableRoutes = value.map((e) {
      return _._filter ? e.trimmedRoute ?? e : e;
    }).where((segment) {
      return segment.isNotEmpty;
    });
  }

  static set initialRoutes(String path) {
    _._routes = path.split(_._separator).where((segment) {
      if (segment.isEmpty) return false;
      if (isIgnorableRoute(segment)) return false;
      return isSupportedRoute(segment);
    }).toList();
    _._n();
  }

  static set separator(String value) => _._separator = value;

  static set supportedRoutes(Iterable<String> value) {
    _._supportedRoutes = value.map((e) {
      return _._filter ? e.trimmedRoute ?? e : e;
    }).where((segment) {
      return segment.isNotEmpty;
    });
  }

  static bool _isIgnorableRoute(String? route, [bool filter = false]) {
    if (_._ignorableRoutes.isEmpty) return false;
    return _._ignorableRoutes.contains(filter ? route.trimmedRoute : route);
  }

  static bool _isSupportedRoute(String? route, [bool filter = false]) {
    if (_._supportedRoutes.isEmpty) return true;
    return _._supportedRoutes.contains(filter ? route.trimmedRoute : route);
  }

  static bool isIgnorableRoute(String? route) {
    return _isIgnorableRoute(route, _._filter);
  }

  static bool isSupportedRoute(String? route) {
    return _isSupportedRoute(route, _._filter);
  }

  static void push(String? route) {
    final mRoute = _._filter ? route.trimmedRoute : route;
    if (_isIgnorableRoute(mRoute)) return;
    if (!_isSupportedRoute(mRoute)) return;
    if (_._multiple || !_._routes.contains(mRoute)) {
      _._routes.add(mRoute);
      _._n();
    }
  }

  static void pop([String? route]) {
    final mRoute = _._filter ? route.trimmedRoute : route;
    if (_isIgnorableRoute(mRoute)) return;
    if (!_isSupportedRoute(mRoute)) return;
    if (mRoute == null) {
      _._routes.removeLast();
    } else {
      _._routes.remove(mRoute);
    }
    _._n();
  }

  static void replace(String? route, String? previousRoute) {
    final mRoute = _._filter ? route.trimmedRoute : route;
    final mOldRoute = _._filter ? previousRoute.trimmedRoute : previousRoute;
    if (mOldRoute == mRoute) return;
    if (currentRoute == mRoute) return;
    if (_isIgnorableRoute(mRoute)) return;
    if (!_isSupportedRoute(mRoute)) return;
    if (previousRoute != null) {
      _._routes.remove(mOldRoute);
    } else {
      _._routes.removeLast();
    }
    if (currentRoute == mRoute) return;
    if (_isIgnorableRoute(mOldRoute) || !_isSupportedRoute(mOldRoute)) {
      _._routes.removeLast();
    }
    _._routes.add(mRoute);
    _._n();
  }

  static void clear([String? route]) {
    _._routes.clear();
    final mRoute = _._filter ? route.trimmedRoute : route;
    if (!_isIgnorableRoute(mRoute) && _isSupportedRoute(mRoute)) {
      if (_._multiple || !_._routes.contains(mRoute)) _._routes.add(mRoute);
    }
    _._n();
  }

  static void listen(ValueChanged<String> listener) {
    _._callback = listener;
  }
}

class RouteMonitor extends NavigatorObserver {
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    final previous = oldRoute?.settings.name;
    final current = newRoute?.settings.name;
    if (newRoute is PageRoute) RouteManager.replace(current, previous);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final current = route.settings.name;
    if (route is PageRoute) RouteManager.clear(current);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final current = route.settings.name;
    if (route is PageRoute) RouteManager.push(current);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final previous = route.settings.name;
    if (route is PageRoute) RouteManager.pop(previous);
  }
}
