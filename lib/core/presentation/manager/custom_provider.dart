import 'dart:async';

import 'package:flutter/material.dart';

/// Base provider with a lightweight event channel used by screens to react to
/// one-off outcomes (navigate on success, show an error, ...).
///
/// Only the most recent [listen] subscriber receives events. Screens call
/// [listen] in `onStarted`, so the subscribing screen is always the active
/// one. Previous controllers are closed to avoid leaks.
class CustomProvider extends ChangeNotifier {
  StreamController<dynamic>? _stream;
  bool loading = false;
  bool _disposed = false;

  StreamSubscription<dynamic> listen(Function(dynamic) event) {
    _closeStream();
    final controller = StreamController<dynamic>();
    _stream = controller;
    return controller.stream.listen(event);
  }

  void setLoading(bool value) {
    if (loading == value || _disposed) return;
    loading = value;
    notifyListeners();
  }

  /// Legacy toggle. Prefer [setLoading] — toggling silently inverts state when
  /// two requests overlap or a future fails before resetting.
  void onLoad() {
    loading = !loading;
    notifyListeners();
  }

  void _closeStream() {
    final stream = _stream;
    _stream = null;
    if (stream != null && !stream.isClosed) {
      stream.close();
    }
  }

  void close() => _closeStream();

  void add(dynamic data) {
    if (data is String && data.contains('ThrottlerException')) {
      return;
    }
    final stream = _stream;
    if (stream != null && !stream.isClosed) {
      stream.add(data);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _closeStream();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
