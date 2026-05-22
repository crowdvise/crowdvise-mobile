import 'package:json_annotation/json_annotation.dart';

part 'login_payload_dto.g.dart';

@JsonSerializable()
class LoginPayloadDto {
    @JsonKey(name: "email")
    String email;
    @JsonKey(name: "password")
    String password;

    LoginPayloadDto({
        required this.email,
        required this.password,
    });

    factory LoginPayloadDto.fromJson(Map<String, dynamic> json) => _$LoginPayloadDtoFromJson(json);

    Map<String, dynamic> toJson() => _$LoginPayloadDtoToJson(this);
}
