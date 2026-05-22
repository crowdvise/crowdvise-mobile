class SignUpPayload {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignUpPayload({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}