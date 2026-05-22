import 'dart:convert';

import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/features/auth/data/dto/login_payload_dto.dart';
import 'package:crowdvise/features/auth/data/dto/sign_up_payload_dto.dart';
import 'package:crowdvise/features/auth/data/services/auth_api_service.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:crowdvise/features/auth/domain/model/login_payload.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_model.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_payload.dart';
import 'package:crowdvise/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final api = getIt.get<AuthApiService>();
  final _pref = getIt.getAsync<SharedPreferences>();
  final apiKey = dotenv.env['SUPABASE_API_KEY']!;

  @override
  Future<ApiResult<LoginModel>> login({required LoginPayload payload}) async {
    try {
      final pref = await _pref;

      final param = LoginPayloadDto(
        email: payload.email,
        password: payload.password,
      );
      final result = await api.login(
        apiKey: apiKey,
        grantType: 'password',
        payload: param,
      );

      accessToken = "Bearer ${result.accessToken}";
      await pref.setString(tokenKey, result.accessToken);
      await pref.setString(user, jsonEncode(result.user.toJson()));

      return ApiResult.success(result.toDto());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }

  @override
  Future<ApiResult<SignUpModel>> register({
    required SignUpPayload payload,
  }) async {
    try {
      final param = SignUpPayloadDto(
        firstName: payload.firstName,
        lastName: payload.lastName,
        email: payload.email,
        password: payload.password,
      );
      final result = await api.register(apiKey: apiKey, payload: param);
      return ApiResult.success(result.toDto());
    } catch (e) {
      return ApiResult.failure(e);
    }
  }
}
