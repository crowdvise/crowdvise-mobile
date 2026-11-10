import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/validation/validation.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/auth/domain/repository/auth_repository.dart';
import 'package:crowdvise/features/auth/domain/usecases/login_usecase.dart';
import 'package:crowdvise/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:crowdvise/features/auth/presentation/manager/auth_state.dart';

class AuthProvider extends CustomProvider {
  AuthProvider({this.isLogin = false});

  final bool isLogin;
  final state = AuthState();
  final _repo = getIt.get<AuthRepository>();

  void setFirstName(String firstName) {
    state.firstName = firstName.trim();
    state.firstNameError = firstName.validateFirstName();
    _validateInfo();
  }

  void setLastName(String lastName) {
    state.lastName = lastName.trim();
    state.lastNameError = lastName.validateLastName();
    _validateInfo();
  }

  void setEmail(String email) {
    state.email = email.trim();
    state.emailError = email.validateEmail();
    _validateInfo();
  }

  void setPassword(String password) {
    state.password = password;
    state.passwordError =
        isLogin ? password.validateLoginPassword() : password.validatePassword();
    // Keep the confirm field in sync while typing.
    if (state.confirmPassword.isNotEmpty) {
      state.confirmPasswordError = state.confirmPassword.validateRePassword(
        password,
      );
    }
    _validateInfo();
  }
  void setIndustry(String industry) {
    state.industry = industry;
    state.industryError = industry.validateField();
    _validateInfo();
  }

  void setConfirmPassword(String confirmPassword) {
    state.confirmPassword = confirmPassword;
    state.confirmPasswordError = confirmPassword.validateRePassword(
      state.password,
    );
    _validateInfo();
  }

  void _validateInfo() {
    final emailOk = state.email.validateEmail() == null;
    final passwordOk = isLogin
        ? state.password.validateLoginPassword() == null
        : state.password.validatePassword() == null;

    if (isLogin) {
      state.isValidated = emailOk && passwordOk;
    } else {
      state.isValidated = [
        state.firstName.validateFirstName() == null,
        state.lastName.validateLastName() == null,
        emailOk,
        state.industry.validateField() == null,
        passwordOk,
        state.confirmPassword.validateRePassword(state.password) == null,
      ].validate();
    }
    notifyListeners();
  }

  Future<void> register() async {
    if (loading || !state.isValidated) return;
    setLoading(true);
    try {
      final value = await SignUpUsecase(_repo, state.toSignUpPayload()).invoke();
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });
      if (result != null) add(result);
    } catch (e) {
      add(ApiResult.failure(e).toError());
    } finally {
      setLoading(false);
    }
  }

  Future<void> login() async {
    if (loading) return;
    setLoading(true);
    try {
      final value = await LoginUsecase(_repo, state.toLoginPayload()).invoke();
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });
      if (result != null) add(result);
    } catch (e) {
      add(ApiResult.failure(e).toError());
    } finally {
      setLoading(false);
    }
  }
}
