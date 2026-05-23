import 'package:crowdvise/core/presentation/manager/custom_provider.dart';

class DashboardProvider extends CustomProvider {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void updateIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}