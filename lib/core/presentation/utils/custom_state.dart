import 'package:flutter/material.dart';

abstract class CustomState<T extends StatefulWidget>
    extends State<T> with RouteAware, WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) onStarted();
    });
    onStart();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    onDestroy();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) routeObserver.subscribe(this, route);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
    if (state == AppLifecycleState.paused) {
      onPause();
    }
  }

  @override
  void didPushNext() {
    onPush();
    super.didPushNext();
  }

  @override
  void didPopNext() {
    onPopNext();
    super.didPopNext();
  }

  void onStarted() {}
  void onStart() {}
  void onResume() {}
  void onPause() {}
  void onPopNext() {}
  void onDestroy() {}

  void onPush() {}
}

final routeObserver = RouteObserver<ModalRoute<void>>();
final navigator = GlobalKey<NavigatorState>();
