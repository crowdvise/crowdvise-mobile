// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginDto _$LoginDtoFromJson(Map<String, dynamic> json) => LoginDto(
  accessToken: json['access_token'] as String,
  tokenType: json['token_type'] as String,
  expiresIn: (json['expires_in'] as num).toInt(),
  expiresAt: (json['expires_at'] as num).toInt(),
  refreshToken: json['refresh_token'] as String,
  user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
  weakPassword: json['weak_password'],
);

Map<String, dynamic> _$LoginDtoToJson(LoginDto instance) => <String, dynamic>{
  'access_token': instance.accessToken,
  'token_type': instance.tokenType,
  'expires_in': instance.expiresIn,
  'expires_at': instance.expiresAt,
  'refresh_token': instance.refreshToken,
  'user': instance.user,
  'weak_password': instance.weakPassword,
};

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: json['id'] as String,
  aud: json['aud'] as String,
  role: json['role'] as String,
  email: json['email'] as String,
  emailConfirmedAt: DateTime.parse(json['email_confirmed_at'] as String),
  phone: json['phone'] as String,
  confirmationSentAt: DateTime.parse(json['confirmation_sent_at'] as String),
  confirmedAt: DateTime.parse(json['confirmed_at'] as String),
  lastSignInAt: DateTime.parse(json['last_sign_in_at'] as String),
  appMetadata: AppMetadataDto.fromJson(
    json['app_metadata'] as Map<String, dynamic>,
  ),
  userMetadata: DataDto.fromJson(json['user_metadata'] as Map<String, dynamic>),
  identities: (json['identities'] as List<dynamic>)
      .map((e) => IdentityDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  isAnonymous: json['is_anonymous'] as bool,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'aud': instance.aud,
  'role': instance.role,
  'email': instance.email,
  'email_confirmed_at': instance.emailConfirmedAt.toIso8601String(),
  'phone': instance.phone,
  'confirmation_sent_at': instance.confirmationSentAt.toIso8601String(),
  'confirmed_at': instance.confirmedAt.toIso8601String(),
  'last_sign_in_at': instance.lastSignInAt.toIso8601String(),
  'app_metadata': instance.appMetadata,
  'user_metadata': instance.userMetadata,
  'identities': instance.identities,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'is_anonymous': instance.isAnonymous,
};
