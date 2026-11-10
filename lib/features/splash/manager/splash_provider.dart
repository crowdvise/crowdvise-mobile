import 'dart:async';

import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:logger/logger.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Resolves the first screen once: dashboard when a session exists, landing
/// otherwise (onboarding still pending is signalled with -1).
class SplashProvider extends CustomProvider {
  final _pref = getIt.getAsync<SharedPreferences>();
  String? accountType;
  bool _started = false;

  @override
  StreamSubscription<dynamic> listen(Function(dynamic) event) {
    final subscription = super.listen(event);
    // Start only after the screen is listening, so the resolved destination
    // can never be emitted before there is a subscriber.
    if (!_started) {
      _started = true;
      _resolve();
    }
    return subscription;
  }

  Future<void> _resolve() async {
    // Small brand beat; long enough for the splash animation to settle.
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    try {
      final value = await _pref;
      final onboardingDone = value.getBool(onboardingKey);
      final token = value.getString(tokenKey);
      final loggedInUser = value.getString(user);

      final hasSession =
          (token?.isNotEmpty ?? false) && (loggedInUser?.isNotEmpty ?? false);

      if (hasSession) {
        accessToken = 'Bearer $token';
        add(1);
        return;
      }

      // No usable session. First launch goes through onboarding, otherwise
      // straight to the landing page.
      add(onboardingDone == null ? -1 : 0);
    } catch (e) {
      Logger().d(e);
      add(0);
    }
  }
}
