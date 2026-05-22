class SignUpModel {
  String id;
  String aud;
  String role;
  String email;
  String phone;
  DateTime confirmationSentAt;
  AppMetadata appMetadata;
  Data userMetadata;
  List<Identity> identities;
  DateTime createdAt;
  DateTime updatedAt;
  bool isAnonymous;

  SignUpModel({
    required this.id,
    required this.aud,
    required this.role,
    required this.email,
    required this.phone,
    required this.confirmationSentAt,
    required this.appMetadata,
    required this.userMetadata,
    required this.identities,
    required this.createdAt,
    required this.updatedAt,
    required this.isAnonymous,
  });
}

class AppMetadata {
  String provider;
  List<String> providers;

  AppMetadata({required this.provider, required this.providers});
}

class Identity {
  String identityId;
  String id;
  String userId;
  Data identityData;
  String provider;
  DateTime lastSignInAt;
  DateTime createdAt;
  DateTime updatedAt;
  String email;

  Identity({
    required this.identityId,
    required this.id,
    required this.userId,
    required this.identityData,
    required this.provider,
    required this.lastSignInAt,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
  });
}

class Data {
  String email;
  bool emailVerified;
  bool phoneVerified;
  String sub;

  Data({
    required this.email,
    required this.emailVerified,
    required this.phoneVerified,
    required this.sub,
  });
}
