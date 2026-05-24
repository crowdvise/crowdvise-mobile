import 'package:json_annotation/json_annotation.dart';

part 'sign_up_payload_dto.g.dart';

@JsonSerializable()
class SignUpPayloadDto {
    @JsonKey(name: "first_name")
    String firstName;
    @JsonKey(name: "last_name")
    String lastName;
    @JsonKey(name: "email")
    String email;
    @JsonKey(name: "password")
    String password;
    @JsonKey(name: "industry")
    String industry;

    SignUpPayloadDto({
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.password,
        required this.industry,
    });

    factory SignUpPayloadDto.fromJson(Map<String, dynamic> json) => _$SignUpPayloadDtoFromJson(json);

    Map<String, dynamic> toJson() => _$SignUpPayloadDtoToJson(this);
}
