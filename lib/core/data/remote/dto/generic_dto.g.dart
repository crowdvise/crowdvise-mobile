// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericDto _$GenericDtoFromJson(Map<String, dynamic> json) => GenericDto(
  success: json['success'] as bool,
  message: json['message'] as String,
);

Map<String, dynamic> _$GenericDtoToJson(GenericDto instance) =>
    <String, dynamic>{'success': instance.success, 'message': instance.message};
