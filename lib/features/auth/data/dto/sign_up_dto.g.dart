// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpDto _$SignUpDtoFromJson(Map<String, dynamic> json) => SignUpDto(
  id: json['id'] as String,
  aud: json['aud'] as String,
  role: json['role'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  confirmationSentAt: DateTime.parse(json['confirmation_sent_at'] as String),
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

Map<String, dynamic> _$SignUpDtoToJson(SignUpDto instance) => <String, dynamic>{
  'id': instance.id,
  'aud': instance.aud,
  'role': instance.role,
  'email': instance.email,
  'phone': instance.phone,
  'confirmation_sent_at': instance.confirmationSentAt.toIso8601String(),
  'app_metadata': instance.appMetadata,
  'user_metadata': instance.userMetadata,
  'identities': instance.identities,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'is_anonymous': instance.isAnonymous,
};

AppMetadataDto _$AppMetadataDtoFromJson(Map<String, dynamic> json) =>
    AppMetadataDto(
      provider: json['provider'] as String,
      providers: (json['providers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AppMetadataDtoToJson(AppMetadataDto instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'providers': instance.providers,
    };

IdentityDto _$IdentityDtoFromJson(Map<String, dynamic> json) => IdentityDto(
  identityId: json['identity_id'] as String,
  id: json['id'] as String,
  userId: json['user_id'] as String,
  identityData: DataDto.fromJson(json['identity_data'] as Map<String, dynamic>),
  provider: json['provider'] as String,
  lastSignInAt: DateTime.parse(json['last_sign_in_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  email: json['email'] as String,
);

Map<String, dynamic> _$IdentityDtoToJson(IdentityDto instance) =>
    <String, dynamic>{
      'identity_id': instance.identityId,
      'id': instance.id,
      'user_id': instance.userId,
      'identity_data': instance.identityData,
      'provider': instance.provider,
      'last_sign_in_at': instance.lastSignInAt.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'email': instance.email,
    };

DataDto _$DataDtoFromJson(Map<String, dynamic> json) => DataDto(
  email: json['email'] as String?,
  emailVerified: json['email_verified'] as bool?,
  phoneVerified: json['phone_verified'] as bool?,
  sub: json['sub'] as String?,
);

Map<String, dynamic> _$DataDtoToJson(DataDto instance) => <String, dynamic>{
  'email': instance.email,
  'email_verified': instance.emailVerified,
  'phone_verified': instance.phoneVerified,
  'sub': instance.sub,
};
