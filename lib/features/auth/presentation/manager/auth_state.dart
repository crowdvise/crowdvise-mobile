import 'package:crowdvise/features/auth/domain/model/login_payload.dart';
import 'package:crowdvise/features/auth/domain/model/sign_up_payload.dart';

class AuthState {
  bool isValidated = false;
  String firstName = '';
  String? firstNameError;
  String lastName = '';
  String? lastNameError;
  String email = '';
  String? emailError;
  String password = '';
  String? passwordError;
  String confirmPassword = '';
  String? confirmPasswordError;

  SignUpPayload toSignUpPayload() {
    return SignUpPayload(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: confirmPassword,
    );
  }

  LoginPayload toLoginPayload() {
    return LoginPayload(email: email, password: password);
  }
}
