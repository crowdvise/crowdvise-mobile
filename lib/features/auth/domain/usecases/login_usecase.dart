import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/use_case/use_case.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:crowdvise/features/auth/domain/model/login_payload.dart';
import 'package:crowdvise/features/auth/domain/repository/auth_repository.dart';

class LoginUsecase implements UseCase<LoginModel, LoginPayload> {
  late final AuthRepository repository;
  late final LoginPayload _param;

  LoginUsecase(this.repository, this._param);

  @override
  Future<ApiResult<LoginModel>> invoke() {
    return repository.login(payload: _param);
  }

  @override
  LoginPayload get param => _param;
}
