class SignUpPayload {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String industry;

  SignUpPayload({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.industry,
  });
}