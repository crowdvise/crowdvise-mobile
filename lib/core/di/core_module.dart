import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/utils/custom_state.dart';
import 'package:crowdvise/features/auth/presentation/screens/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
    dio.interceptors.add(AwesomeDioInterceptor());

    // Add Interceptor to handle token expiration
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response?.statusCode == 401 ||
              error.response?.data['message'] == 'Unauthorized') {
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
  void _handleTokenExpiration() {
    preferences().then((value) {
      value.remove(user);
      value.remove(tokenKey);
      value.remove(currentEmail);
      // value.remove(userRoleKey);
      // value.remove(savedIds);

      navigator.currentState?.pushAndRemoveUntil(
        CupertinoPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    });
  }
}
