// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpPayloadDto _$SignUpPayloadDtoFromJson(Map<String, dynamic> json) =>
    SignUpPayloadDto(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$SignUpPayloadDtoToJson(SignUpPayloadDto instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'password': instance.password,
    };
