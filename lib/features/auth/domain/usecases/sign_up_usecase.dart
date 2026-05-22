import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/use_case/use_case.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_model.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_payload.dart';
import 'package:crowdvise/features/auth/domain/repository/auth_repository.dart';

class SignUpUsecase implements UseCase<SignUpModel, SignUpPayload> {
  late final AuthRepository repository;
  late final SignUpPayload _param;

  SignUpUsecase(this.repository, this._param);

  @override
  Future<ApiResult<SignUpModel>> invoke() {
    return repository.register(payload: _param);
  }

  @override
  SignUpPayload get param => _param;
}
