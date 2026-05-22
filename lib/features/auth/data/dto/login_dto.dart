// To parse this JSON data, do
//
//     final loginDto = loginDtoFromJson(jsonString);

import 'package:crowdvise/features/auth/data/dto/sign_up_dto.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'login_dto.g.dart';

LoginDto loginDtoFromJson(String str) => LoginDto.fromJson(json.decode(str));

String loginDtoToJson(LoginDto data) => json.encode(data.toJson());

@JsonSerializable()
class LoginDto {
  @JsonKey(name: "access_token")
  String accessToken;
  @JsonKey(name: "token_type")
  String tokenType;
  @JsonKey(name: "expires_in")
  int expiresIn;
  @JsonKey(name: "expires_at")
  int expiresAt;
  @JsonKey(name: "refresh_token")
  String refreshToken;
  @JsonKey(name: "user")
  UserDto user;
  @JsonKey(name: "weak_password")
  dynamic weakPassword;

  LoginDto({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.refreshToken,
    required this.user,
    required this.weakPassword,
  });

  LoginModel toDto() {
    return LoginModel(
      accessToken: accessToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      expiresAt: expiresAt,
      refreshToken: refreshToken,
      user: user.toDto(),
      weakPassword: weakPassword,
    );
  }

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}

@JsonSerializable()
class UserDto {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "aud")
  String aud;
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "email_confirmed_at")
  DateTime emailConfirmedAt;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "confirmation_sent_at")
  DateTime confirmationSentAt;
  @JsonKey(name: "confirmed_at")
  DateTime confirmedAt;
  @JsonKey(name: "last_sign_in_at")
  DateTime lastSignInAt;
  @JsonKey(name: "app_metadata")
  AppMetadataDto appMetadata;
  @JsonKey(name: "user_metadata")
  DataDto userMetadata;
  @JsonKey(name: "identities")
  List<IdentityDto> identities;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "is_anonymous")
  bool isAnonymous;

  UserDto({
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

  UserModel toDto() {
    return UserModel(
      id: id,
      aud: aud,
      role: role,
      email: email,
      phone: phone,
      confirmationSentAt: confirmationSentAt,
      appMetadata: appMetadata.toDto(),
      userMetadata: userMetadata.toDto(),
      identities: identities.map((identity) => identity.toDto()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isAnonymous: isAnonymous,
      emailConfirmedAt: emailConfirmedAt,
      confirmedAt: confirmedAt,
      lastSignInAt: lastSignInAt,
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
