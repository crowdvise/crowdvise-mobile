import 'package:crowdvise/core/di/core_module_container.dart';
import 'package:crowdvise/core/domain/utils/utils.dart';
import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/splash/manager/onboarding_state.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnboardingProvider extends CustomProvider {
  var state = OnboardingState();
  final _pref = getIt.getAsync<SharedPreferences>();

  void init() {
    state = OnboardingState();
    notifyListeners();
  }

  void setIndex(int value) {
    state.currentPage = value;
    notifyListeners();
  }

  // bool isEnd(){
  //   return state.currentPage == state.onboardingList.length - 1;
  // }

  void setOnboarding() {
    _pref.then((value) {
      value.setBool(onboardingKey, true);
    });
  }

}
