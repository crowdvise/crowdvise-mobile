// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDto _$HistoryDtoFromJson(Map<String, dynamic> json) => HistoryDto(
  runs: (json['runs'] as List<dynamic>)
      .map((e) => RunDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HistoryDtoToJson(HistoryDto instance) =>
    <String, dynamic>{'runs': instance.runs};

RunDto _$RunDtoFromJson(Map<String, dynamic> json) => RunDto(
  id: json['id'] as String,
  productDescription: json['product_description'] as String,
  targetSegment: json['target_segment'] as String,
  panelSize: (json['panel_size'] as num).toInt(),
  overallConversionRate: (json['overall_conversion_rate'] as num).toDouble(),
  overallDropoutRate: (json['overall_dropout_rate'] as num).toDouble(),
  overallDelayedRate: (json['overall_delayed_rate'] as num).toDouble(),
  readinessScore: (json['readiness_score'] as num).toInt(),
  createdAt: json['created_at'] as String,
);

Map<String, dynamic> _$RunDtoToJson(RunDto instance) => <String, dynamic>{
  'id': instance.id,
  'product_description': instance.productDescription,
  'target_segment': instance.targetSegment,
  'panel_size': instance.panelSize,
  'overall_conversion_rate': instance.overallConversionRate,
  'overall_dropout_rate': instance.overallDropoutRate,
  'overall_delayed_rate': instance.overallDelayedRate,
  'readiness_score': instance.readinessScore,
  'created_at': instance.createdAt,
};
