import 'package:provider/provider.dart';
import 'package:crowdvise/features/history/presentation/manager/history_provider.dart';
import 'package:crowdvise/features/session/presentation/manager/session_provider.dart';
import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class CoreModule {
  Dio dio() {
    final dio = Dio(
      BaseOptions(
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(minutes: 15),
        // sendTimeout: const Duration(seconds: 60),
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(AwesomeDioInterceptor());
    }

    // Add Interceptor to handle token expiration
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          final data = error.response?.data;
          final isUnauthorizedMessage =
              data is Map && data['message'] == 'Unauthorized';
          if (error.response?.statusCode == 401 || isUnauthorizedMessage) {
            _handleTokenExpiration();
          }
          return handler.next(error);
        },
      ),
    );
    return dio;
  }

  Future<SharedPreferences> preferences() {
    return SharedPreferences.getInstance();
  }

  //This function clears all stored user
  // preferences (excluding the onboarding key) and navigates to login screen
  Future<void> _handleTokenExpiration() async {
    accessToken = '';
    userType = '';
    currentRole = null;
    final pref = await preferences();
    await pref.remove(user);
    await pref.remove(tokenKey);
    await pref.remove(currentEmail);
    await pref.remove(userRoleKey);

    final nav = navigator.currentState;
    final context = nav?.context;
    if (nav == null || context == null || !context.mounted) return;

    try {
      context.read<SessionProvider>().reset();
      context.read<HistoryProvider>().reset();
    } catch (_) {
      // Ignore if the providers are not mounted.
    }

    nav.pushAndRemoveUntil(
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
}
