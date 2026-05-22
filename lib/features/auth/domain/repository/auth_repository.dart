import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:crowdvise/features/auth/domain/model/login_payload.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_model.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_payload.dart';

abstract class AuthRepository {
  Future<ApiResult<SignUpModel>> register({required SignUpPayload payload});
  Future<ApiResult<LoginModel>> login({required LoginPayload payload});
}
