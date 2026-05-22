// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginPayloadDto _$LoginPayloadDtoFromJson(Map<String, dynamic> json) =>
    LoginPayloadDto(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginPayloadDtoToJson(LoginPayloadDto instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};
