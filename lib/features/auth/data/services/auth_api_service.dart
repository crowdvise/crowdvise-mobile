import 'package:crowdvise/core/domain/utils/constants.dart';
import 'package:crowdvise/features/auth/data/dto/login_dto.dart';
import 'package:crowdvise/features/auth/data/dto/login_payload_dto.dart';
import 'package:crowdvise/features/auth/data/dto/sign_up_dto.dart';
import 'package:crowdvise/features/auth/data/dto/sign_up_payload_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: supabaseAuthUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  static const authentication = 'apikey';

  @POST('signup')
  Future<SignUpDto> register({
    @Header(authentication) required String apiKey,
    @Body() required SignUpPayloadDto payload,
  });

  @POST('token')
  Future<LoginDto> login({
    @Header(authentication) required String apiKey,
    @Query('grant_type') required String grantType,
    @Body() required LoginPayloadDto payload,
  });
}
