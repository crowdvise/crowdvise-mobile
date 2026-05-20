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
}