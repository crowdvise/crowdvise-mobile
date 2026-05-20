import 'package:crowdvise/core/domain/model/generic_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'generic_dto.g.dart';

@JsonSerializable()
class GenericDto {
  @JsonKey(name: "success")
  final bool success;
  @JsonKey(name: "message")
  final String message;

  GenericDto({
    required this.success,
    required this.message,
  });

  GenericModel toDto() {
    return GenericModel(success: success, message: message);
  }

  factory GenericDto.fromJson(Map<String, dynamic> json) =>
      _$GenericDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GenericDtoToJson(this);
}
