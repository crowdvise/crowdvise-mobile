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

  void pop([Object? arg]) {
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

  void popUntil(List<String> id) {
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

  /// Replaces the whole detail stack with [screen], keeping the dashboard tab
  /// root underneath. Used after a simulation/fix run so Back returns home
  /// instead of re-entering the loading flow.
  Future<dynamic> replaceInnerUntilRoot(Widget screen) {
    final route = MaterialPageRoute(builder: (_) => screen);
    final inner = dashboardNavigatorKey.currentState;
    if (inner != null) {
      return inner.pushAndRemoveUntil(route, (r) => r.isFirst);
    }
    return Navigator.of(this, rootNavigator: true)
        .pushAndRemoveUntil(route, (r) => r.isFirst);
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

  /// Safely clears the entire navigation stack and returns to the Dashboard.
  /// Works consistently across Mobile (root stack) and Web (nested navigator)
  /// by forcing the action onto the root navigator.
  void goHome() {
    final inner = dashboardNavigatorKey.currentState;
    if (inner != null) {
      // Desktop: pop detail screens off the inner navigator and show Home.
      switchDashboardTab(inner.context, 0);
    } else {
      // On Mobile, replace the root stack
      Navigator.of(this, rootNavigator: true).pushNamedAndRemoveUntil(
        DashboardScreen.id,
        (Route<dynamic> route) => false,
      );
    }
  }
}
