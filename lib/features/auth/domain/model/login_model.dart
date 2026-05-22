import 'package:crowdvise/features/auth/domain/model/sign_up_model.dart';

class LoginModel {
    String accessToken;
    String tokenType;
    int expiresIn;
    int expiresAt;
    String refreshToken;
    UserModel user;
    dynamic weakPassword;

    LoginModel({
        required this.accessToken,
        required this.tokenType,
        required this.expiresIn,
        required this.expiresAt,
        required this.refreshToken,
        required this.user,
        required this.weakPassword,
    });

}

class UserModel {
    String id;
    String aud;
    String role;
    String email;
    DateTime emailConfirmedAt;
    String phone;
    DateTime confirmationSentAt;
    DateTime confirmedAt;
    DateTime lastSignInAt;
    AppMetadata appMetadata;
    Data userMetadata;
    List<Identity> identities;
    DateTime createdAt;
    DateTime updatedAt;
    bool isAnonymous;

    UserModel({
        required this.id,
        required this.aud,
        required this.role,
        required this.email,
        required this.emailConfirmedAt,
        required this.phone,
        required this.confirmationSentAt,
        required this.confirmedAt,
        required this.lastSignInAt,
        required this.appMetadata,
        required this.userMetadata,
        required this.identities,
        required this.createdAt,
        required this.updatedAt,
        required this.isAnonymous,
    });

}
