import 'package:crowdvise/features/session/presentation/screens/dashboard.dart';
import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushReplacement(Widget screen) {
    return Navigator.of(this).pushReplacement(MaterialPageRoute(builder: (_) {
      return screen;
    }));
  }

  Future<dynamic> pushNamedReplacement(String route, {Object? args}) {
    return Navigator.of(this).pushReplacementNamed(route, arguments: args);
  }

  Future<dynamic> push(Widget screen) {
    return Navigator.of(this).push(MaterialPageRoute(builder: (_) {
      return screen;
    }));
  }

  Future<dynamic> pushNamed(String route, {Object? args}) {
    return Navigator.of(this).pushNamed(route, arguments: args);
  }

  pop([Object? arg]) {
    Navigator.of(this).pop(arg);
  }

  Future<dynamic> pushAndReplaceUntil(Widget screen, String id) {
    return Navigator.of(this).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) {
          return screen;
        }), (route) {
      return route.settings.name != id;
    });
  }

  Future<dynamic> pushNamedAndClear(String id, {Object? args}){
    return Navigator.of(this).pushNamedAndRemoveUntil(
        id, (Route<dynamic> route) => false,
        arguments: args);
  }

  Future<dynamic> pushNamedAndReplaceUntil(String route, String id,
      {Object? args}) {
    return Navigator.of(this).pushNamedAndRemoveUntil(
        route, ModalRoute.withName(id),
        arguments: args);
  }

  popUntil(List<String> id) {
    Navigator.of(this).popUntil((route) {
      return id.contains(route.settings.name);
    });
  }

  T getArgs<T>() {
    return ModalRoute.of(this)?.settings.arguments as T;
  }

  /// Pushes a screen inside the dashboard's nested navigator (desktop) so the
  /// sidebar stays visible. Falls back to root navigator on mobile.
  Future<dynamic> pushInner(Widget screen) {
    final inner = dashboardNavigatorKey.currentState;
    if (inner != null) {
      return inner.push(MaterialPageRoute(builder: (_) => screen));
    }
    return push(screen);
  }

  /// Replaces current route inside the dashboard's nested navigator (desktop).
  /// Falls back to root pushReplacement on mobile.
  Future<dynamic> pushReplacementInner(Widget screen) {
    final inner = dashboardNavigatorKey.currentState;
    if (inner != null) {
      return inner.pushReplacement(MaterialPageRoute(builder: (_) => screen));
    }
    return pushReplacement(screen);
  }

  /// Pops inside the dashboard nested navigator if it can, otherwise pops root.
  void popInner([Object? arg]) {
    final inner = dashboardNavigatorKey.currentState;
    if (inner != null && inner.canPop()) {
      inner.pop(arg);
    } else {
      Navigator.of(this).pop(arg);
    }
  }

  void pushNamedInner(String route, {Object? args}) {
    final inner = dashboardNavigatorKey.currentState;
    if (inner != null) {
      inner.pushNamed(route, arguments: args);
    } else {
      Navigator.of(this).pushNamed(route, arguments: args);
    }
  }
}
