// To parse this JSON data, do
//
//     final signUpDto = signUpDtoFromJson(jsonString);

import 'package:crowdvise/features/auth/domain/model/sign_up_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'sign_up_dto.g.dart';

SignUpDto signUpDtoFromJson(String str) => SignUpDto.fromJson(json.decode(str));

String signUpDtoToJson(SignUpDto data) => json.encode(data.toJson());

@JsonSerializable()
class SignUpDto {
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "aud")
  String aud;
  @JsonKey(name: "role")
  String role;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "phone")
  String phone;
  @JsonKey(name: "confirmation_sent_at")
  DateTime confirmationSentAt;
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

  SignUpDto({
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

  SignUpModel toDto() {
    return SignUpModel(
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
    );
  }

  factory SignUpDto.fromJson(Map<String, dynamic> json) =>
      _$SignUpDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpDtoToJson(this);
}

@JsonSerializable()
class AppMetadataDto {
  @JsonKey(name: "provider")
  String provider;
  @JsonKey(name: "providers")
  List<String> providers;

  AppMetadataDto({required this.provider, required this.providers});

  AppMetadata toDto() {
    return AppMetadata(
      provider: provider,
      providers: providers,
    );
  }

  factory AppMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$AppMetadataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppMetadataDtoToJson(this);
}

@JsonSerializable()
class IdentityDto {
  @JsonKey(name: "identity_id")
  String identityId;
  @JsonKey(name: "id")
  String id;
  @JsonKey(name: "user_id")
  String userId;
  @JsonKey(name: "identity_data")
  DataDto identityData;
  @JsonKey(name: "provider")
  String provider;
  @JsonKey(name: "last_sign_in_at")
  DateTime lastSignInAt;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  @JsonKey(name: "updated_at")
  DateTime updatedAt;
  @JsonKey(name: "email")
  String email;

  IdentityDto({
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

  Identity toDto() {
    return Identity(
      identityId: identityId,
      id: id,
      userId: userId,
      identityData: identityData.toDto(),
      provider: provider,
      lastSignInAt: lastSignInAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      email: email,
    );
  }

  factory IdentityDto.fromJson(Map<String, dynamic> json) =>
      _$IdentityDtoFromJson(json);

  Map<String, dynamic> toJson() => _$IdentityDtoToJson(this);
}

@JsonSerializable()
class DataDto {
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "email_verified")
  bool emailVerified;
  @JsonKey(name: "phone_verified")
  bool phoneVerified;
  @JsonKey(name: "sub")
  String sub;

  DataDto({
    required this.email,
    required this.emailVerified,
    required this.phoneVerified,
    required this.sub,
  });

  Data toDto() {
    return Data(
      email: email,
      emailVerified: emailVerified,
      phoneVerified: phoneVerified,
      sub: sub,
    );
  }

  factory DataDto.fromJson(Map<String, dynamic> json) =>
      _$DataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DataDtoToJson(this);
}
