import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/validation/validation.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/auth/domain/repository/auth_repository.dart';
import 'package:crowdvise/features/auth/domain/usecases/login_usecase.dart';
import 'package:crowdvise/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:crowdvise/features/auth/presentation/manager/auth_state.dart';

class AuthProvider extends CustomProvider {
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
    state.passwordError = password.validatePassword();
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
    state.isValidated = [
      state.firstName.validateField() == null,
      state.lastName.validateField() == null,
      state.email.validateField() == null,
      state.password.validateField() == null,
      state.confirmPassword.validateRePassword(state.password) == null,
    ].validate();
    notifyListeners();
  }

  void register() {
    onLoad();

    final result = SignUpUsecase(_repo, state.toSignUpPayload()).invoke();
    result.then((value) {
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });

      if (result != null) {
        add(result);
      }
      onLoad();
    });
  }

  void login() {
    onLoad();

    final result = LoginUsecase(_repo, state.toLoginPayload()).invoke();
    result.then((value) {
      final result = value.getOrElse((error) {
        add(error);
        return null;
      });

      if (result != null) {
        add(result);
      }
      onLoad();
    });
  }
}
