import 'dart:convert';
import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/auth/data/dto/login_dto.dart';
import 'package:crowdvise/features/auth/domain/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountState {
  UserModel? userModel;
  AccountState({this.userModel});

  AccountState copyWith({UserModel? userModel}) {
    return AccountState(userModel: userModel ?? this.userModel);
  }
}

class AccountProvider extends CustomProvider {
  AccountProvider() : super() {
    _fetchUser();
  }
  final state = AccountState();

  Future<void> _fetchUser() async {
    onLoad();
    try {
      final pref = await getIt.getAsync<SharedPreferences>();
      final userString = pref.getString(user);

      if (userString != null) {
        final userDto = UserDto.fromJson(jsonDecode(userString));
        final userModel = userDto.toDto();

        state.userModel = userModel;
      }
    } catch (e) {
      // Failed to parse
    } finally {
      onLoad();
    }
  }

  Future<void> logout() async {
    final pref = await getIt.getAsync<SharedPreferences>();
    await pref.remove(tokenKey);
    await pref.remove(user);
    await pref.remove(currentEmail);
  }
}
